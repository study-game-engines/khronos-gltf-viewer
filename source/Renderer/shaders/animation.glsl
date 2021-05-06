#ifdef HAS_TARGET_POSITION_0_VEC4
in vec3 a_target_position0;
#endif

#ifdef HAS_TARGET_POSITION_1_VEC4
in vec3 a_target_position1;
#endif

#ifdef HAS_TARGET_POSITION_2_VEC4
in vec3 a_target_position2;
#endif

#ifdef HAS_TARGET_POSITION_3_VEC4
in vec3 a_target_position3;
#endif

#ifdef HAS_TARGET_POSITION_4_VEC4
in vec3 a_target_position4;
#endif

#ifdef HAS_TARGET_POSITION_5_VEC4
in vec3 a_target_position5;
#endif

#ifdef HAS_TARGET_POSITION_6_VEC4
in vec3 a_target_position6;
#endif

#ifdef HAS_TARGET_POSITION_7_VEC4
in vec3 a_target_position7;
#endif

#ifdef HAS_TARGET_NORMAL_0_VEC4
in vec3 a_target_normal0;
#endif

#ifdef HAS_TARGET_NORMAL_1_VEC4
in vec3 a_target_normal1;
#endif

#ifdef HAS_TARGET_NORMAL_2_VEC4
in vec3 a_target_normal2;
#endif

#ifdef HAS_TARGET_NORMAL_3_VEC4
in vec3 a_target_normal3;
#endif

#ifdef HAS_TARGET_TANGENT_0_VEC4
in vec3 a_target_tangent0;
#endif

#ifdef HAS_TARGET_TANGENT_1_VEC4
in vec3 a_target_tangent1;
#endif

#ifdef HAS_TARGET_TANGENT_2_VEC4
in vec3 a_target_tangent2;
#endif

#ifdef HAS_TARGET_TANGENT_3_VEC4
in vec3 a_target_tangent3;
#endif

#ifdef USE_MORPHING
uniform float u_morphWeights[WEIGHT_COUNT];
#endif

#ifdef HAS_JOINTS_0_VEC4
in vec4 a_joints_0;
#endif

#ifdef HAS_JOINTS_1_VEC4
in vec4 a_joints_1;
#endif

#ifdef HAS_WEIGHTS_0_VEC4
in vec4 a_weights_0;
#endif

#ifdef HAS_WEIGHTS_1_VEC4
in vec4 a_weights_1;
#endif

#ifdef USE_SKINNING
uniform mat4 u_jointMatrix[JOINT_COUNT];
uniform mat4 u_jointNormalMatrix[JOINT_COUNT];
#endif

#ifdef USE_SKINNING
mat4 getSkinningMatrix()
{
    mat4 skin = mat4(0);

    #if defined(HAS_WEIGHTS_0_VEC4) && defined(HAS_JOINTS_0_VEC4)
    skin +=
        a_weights_0.x * u_jointMatrix[int(a_joints_0.x)] +
        a_weights_0.y * u_jointMatrix[int(a_joints_0.y)] +
        a_weights_0.z * u_jointMatrix[int(a_joints_0.z)] +
        a_weights_0.w * u_jointMatrix[int(a_joints_0.w)];
    #endif

    #if defined(HAS_WEIGHTS_1_VEC4) && defined(HAS_JOINTS_1_VEC4)
    skin +=
        a_weights_1.x * u_jointMatrix[int(a_joints_1.x)] +
        a_weights_1.y * u_jointMatrix[int(a_joints_1.y)] +
        a_weights_1.z * u_jointMatrix[int(a_joints_1.z)] +
        a_weights_1.w * u_jointMatrix[int(a_joints_1.w)];
    #endif

    return skin;
}

mat4 getSkinningNormalMatrix()
{
    mat4 skin = mat4(0);

    #if defined(HAS_WEIGHTS_0_VEC4) && defined(HAS_JOINTS_0_VEC4)
    skin +=
        a_weights_0.x * u_jointNormalMatrix[int(a_joints_0.x)] +
        a_weights_0.y * u_jointNormalMatrix[int(a_joints_0.y)] +
        a_weights_0.z * u_jointNormalMatrix[int(a_joints_0.z)] +
        a_weights_0.w * u_jointNormalMatrix[int(a_joints_0.w)];
    #endif

    #if defined(HAS_WEIGHTS_1_VEC4) && defined(HAS_JOINTS_1_VEC4)
    skin +=
        a_weights_1.x * u_jointNormalMatrix[int(a_joints_1.x)] +
        a_weights_1.y * u_jointNormalMatrix[int(a_joints_1.y)] +
        a_weights_1.z * u_jointNormalMatrix[int(a_joints_1.z)] +
        a_weights_1.w * u_jointNormalMatrix[int(a_joints_1.w)];
    #endif

    return skin;
}
#endif // !USE_SKINNING

#ifdef USE_MORPHING
vec4 getTargetPosition()
{
    vec4 pos = vec4(0);

#ifdef HAS_TARGET_POSITION_0_VEC4
    pos.xyz += u_morphWeights[0] * a_target_position0;
#endif

#ifdef HAS_TARGET_POSITION_1_VEC4
    pos.xyz += u_morphWeights[1] * a_target_position1;
#endif

#ifdef HAS_TARGET_POSITION_2_VEC4
    pos.xyz += u_morphWeights[2] * a_target_position2;
#endif

#ifdef HAS_TARGET_POSITION_3_VEC4
    pos.xyz += u_morphWeights[3] * a_target_position3;
#endif

#ifdef HAS_TARGET_POSITION_4_VEC4
    pos.xyz += u_morphWeights[4] * a_target_position4;
#endif

#ifdef HAS_TARGET_POSITION_5_VEC4
    pos.xyz += u_morphWeights[4] * a_target_position5;
#endif

#ifdef HAS_TARGET_POSITION_6_VEC4
    pos.xyz += u_morphWeights[4] * a_target_position6;
#endif

#ifdef HAS_TARGET_POSITION_7_VEC4
    pos.xyz += u_morphWeights[4] * a_target_position7;
#endif

    return pos;
}

vec3 getTargetNormal()
{
    vec3 normal = vec3(0);

#ifdef HAS_TARGET_NORMAL_0_VEC4
    normal += u_morphWeights[0] * a_target_normal0;
#endif

#ifdef HAS_TARGET_NORMAL_1_VEC4
    normal += u_morphWeights[1] * a_target_normal1;
#endif

#ifdef HAS_TARGET_NORMAL_2_VEC4
    normal += u_morphWeights[2] * a_target_normal2;
#endif

#ifdef HAS_TARGET_NORMAL_3_VEC4
    normal += u_morphWeights[3] * a_target_normal3;
#endif

#ifdef HAS_TARGET_NORMAL_4_VEC4
    normal += u_morphWeights[4] * a_target_normal4;
#endif

    return normal;
}

vec3 getTargetTangent()
{
    vec3 tangent = vec3(0);

#ifdef HAS_TARGET_TANGENT_0_VEC4
    tangent += u_morphWeights[0] * a_target_tangent0;
#endif

#ifdef HAS_TARGET_TANGENT_1_VEC4
    tangent += u_morphWeights[1] * a_target_tangent1;
#endif

#ifdef HAS_TARGET_TANGENT_2_VEC4
    tangent += u_morphWeights[2] * a_target_tangent2;
#endif

#ifdef HAS_TARGET_TANGENT_3_VEC4
    tangent += u_morphWeights[3] * a_target_tangent3;
#endif

#ifdef HAS_TARGET_TANGENT_4_VEC4
    tangent += u_morphWeights[4] * a_target_tangent4;
#endif

    return tangent;
}

#endif // !USE_MORPHING
