import { vec3 } from 'gl-matrix';
import { gltfCamera } from './camera.js';
import { jsToGl, clamp } from './utils.js';

const VecZero = vec3.create();

class UserCamera extends gltfCamera
{
    constructor(
        position = [0, 0, 0],
        target = [0, 0,0],
        up = [0, 1, 0],
        xRot = 0,
        yRot = 0,
        zoom = 1)
    {
        super();

        this.position = jsToGl(position);
        this.target = jsToGl(target);
        this.up = jsToGl(up);
        this.xRot = xRot;
        this.yRot = yRot;
        this.zoom = zoom;
        this.zoomFactor = 1.04;
        this.rotateSpeed = 1 / 180;
        this.scaleFactor = 1;
    }

    updatePosition()
    {
        // calculate direction from focus to camera (assuming camera is at positive z)
        // yRot rotates *around* x-axis, xRot rotates *around* y-axis
        const direction = vec3.fromValues(0, 0, 1);
        this.toLocalRotation(direction);

        const position = vec3.create();
        vec3.scale(position, direction, this.zoom);
        vec3.add(position, position, this.target);

        this.position = position;
    }

    reset(gltf)
    {
        this.xRot = 0;
        this.yRot = 0;
        this.fitViewToAsset(gltf);
    }

    zoomIn(value)
    {
        if (value > 0)
        {
            this.zoom *= this.zoomFactor;
        }
        else
        {
            this.zoom /= this.zoomFactor;
        }
    }

    rotate(x, y)
    {
        const yMax = Math.PI / 2 - 0.01;
        this.xRot += (x * this.rotateSpeed);
        this.yRot += (y * this.rotateSpeed);
        this.yRot = clamp(this.yRot, -yMax, yMax);
    }

    pan(x, y)
    {
        const moveSpeed = 1 / (this.scaleFactor * 200);

        const left = vec3.fromValues(-1, 0, 0);
        this.toLocalRotation(left);
        vec3.scale(left, left, x * moveSpeed);

        const up = vec3.fromValues(0, 1, 0);
        this.toLocalRotation(up);
        vec3.scale(up, up, y * moveSpeed);

        vec3.add(this.target, this.target, up);
        vec3.add(this.target, this.target, left);
    }

    fitViewToAsset(gltf)
    {
        const min = vec3.fromValues(Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE);
        const max = vec3.fromValues(Number.MIN_VALUE, Number.MIN_VALUE, Number.MIN_VALUE);

        this.getAssetExtends(gltf, min, max);
        this.fitCameraTargetToExtends(min, max);
        this.fitZoomToExtends(min, max);
    }

    toLocalRotation(vector)
    {
        vec3.rotateX(vector, vector, VecZero, -this.yRot);
        vec3.rotateY(vector, vector, VecZero, -this.xRot);
    }

    getLookAtTarget()
    {
        return this.target;
    }

    getPosition()
    {
        return this.position;
    }

    getAssetExtends(gltf, outMin, outMax)
    {
        for (const node of gltf.nodes)
        {
            if (node.mesh === undefined)
            {
                continue;
            }

            const mesh = gltf.meshes[node.mesh];
            if (mesh.primitives === undefined)
            {
                continue;
            }

            for (const primitive of mesh.primitives)
            {
                const attribute = primitive.attributes.find(a => a.attribute == "POSITION");
                if (attribute === undefined)
                {
                    continue;
                }

                const accessor = gltf.accessors[attribute.accessor];
                const assetMin = vec3.create();
                const assetMax = vec3.create();
                this.getExtendsFromAccessor(accessor, node.worldTransform, assetMin, assetMax);

                for (const i of [0, 1, 2])
                {
                    outMin[i] = Math.min(outMin[i], assetMin[i]);
                    outMax[i] = Math.max(outMax[i], assetMax[i]);
                }
            }
        }
    }

    fitZoomToExtends(min, max)
    {
        const maxAxisLength = Math.max(max[0] - min[0], max[1] - min[1]);
        this.zoom = this.getFittingZoom(maxAxisLength);
    }

    fitCameraTargetToExtends(min, max)
    {
        for (const i of [0, 1, 2])
        {
            this.target[i] = (max[i] + min[i]) / 2;
        }
    }

    getFittingZoom(axisLength)
    {
        const yfov = this.yfov;
        const xfov = this.yfov * this.aspectRatio;

        const yZoom = axisLength / 2 / Math.tan(yfov / 2);
        const xZoom = axisLength / 2 / Math.tan(xfov / 2);

        return Math.max(xZoom, yZoom);
    }

    getExtendsFromAccessor(accessor, worldTransform, outMin, outMax)
    {
        const boxMin = vec3.create();
        vec3.transformMat4(boxMin, jsToGl(accessor.min), worldTransform);

        const boxMax = vec3.create();
        vec3.transformMat4(boxMax, jsToGl(accessor.max), worldTransform);

        const center = vec3.create();
        vec3.add(center, boxMax, boxMin);
        vec3.scale(center, center, 0.5);

        const centerToSurface = vec3.create();
        vec3.sub(centerToSurface, boxMax, center);

        const radius = vec3.length(centerToSurface);

        for (const i of [1, 2, 3])
        {
            outMin[i] = center[i] - radius;
            outMax[i] = center[i] + radius;
        }
    }
};

export { UserCamera };
