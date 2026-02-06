// guard to prevent redefinition
#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED

// the boilerplate code: common vars, funcs, and other things
// also make it so you dont have to worry about platform specific stuffs
#include "UnityPBSLighting.cginc"

float4 _Tint;
sampler2D _MainTex;
float4 _MainTex_ST;
float _Metallic;
float _Smoothness;

struct Interpolators {
    float4 position: SV_POSITION;
    float2 uv: TEXCOORD0;
    float3 normal: TEXCOORD1;
    float3 worldPos: TEXCOORD2;
};

struct VertexData {
    float4 position: POSITION;
    float3 normal: NORMAL;
    float2 uv: TEXCOORD0;
};

// indicating what we're outputing (System Val Position) 
Interpolators MyVertexProgram (VertexData v){
    Interpolators i;
    i.position = UnityObjectToClipPos(v.position); // this is the vertex's position * UNITY_MATRIX_MVP;
    i.worldPos = mul(unity_ObjectToWorld, v.position);
    i.uv = TRANSFORM_TEX(v.uv, _MainTex); // uv coordinates applied after material tilling and offset
    // can also do i.normal = mul(transpose((float3x3)unity_WorldToObject), float4(v.normal, 0));
    i.normal = UnityObjectToWorldNormal(v.normal);
    return i;
}


// a general part of handling light, to make sure we can deal with both directional and dot light 
UnityLight CreateLight (Interpolators i) {
	UnityLight light;
	light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
    float3 lightVec = _WorldSpaceLightPos0.xyz - i.worldPos; // to determine how bright is the spot light when its distance far away
    float attenuation = 1 / (1 + dot (lightVec, lightVec));
	light.color = _LightColor0.rgb * attenuation;
	light.ndotl = DotClamped(i.normal, light.dir);
	return light;
}


// output rgba color val for one pixel
// SV_TARGET is default shader target, indicating where final color is written to
float4 MyFragmentProgram (Interpolators i): SV_TARGET {
    i.normal = normalize(i.normal);
    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
    float3 specularTint; // if its metal then we have specular tint

    // so that specular + albedo doesnt go over the original light strength
    // also so we dont get weird whole albedo tint from specular
    float oneMinusReflectivity;
    albedo = DiffuseAndSpecularFromMetallic( // from the util func
        albedo, _Metallic, specularTint, oneMinusReflectivity
    );

    UnityIndirect indirectLight; // this one for indirect lighting
    indirectLight.diffuse = 0; // ambient light
    indirectLight.specular = 0; // env reflections

    return UNITY_BRDF_PBS(
        albedo, specularTint,
        oneMinusReflectivity, _Smoothness,
        i.normal, viewDir,
        CreateLight(i), indirectLight
    ); // specular with color 
}

#endif