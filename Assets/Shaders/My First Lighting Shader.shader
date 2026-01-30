// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Lighting Shader" {
    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
    }

    SubShader {
        Pass {
            Tags {
                // forward base is the first pass used when rendering something via forward rendering path
				"LightMode" = "ForwardBase"
			}

            CGPROGRAM

                // set what is our vertex and fragment program
                // pragma is basically for issuing special compiler directives
                #pragma vertex MyVertexProgram
			    #pragma fragment MyFragmentProgram

                // the boilerplate code: common vars, funcs, and other things
                // also make it so you dont have to worry about platform specific stuffs
                #include "UnityStandardBRDF.cginc"

                float4 _Tint;
                sampler2D _MainTex;
                float4 _MainTex_ST;
                float4 _SpecularTint;
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


                // output rgba color val for one pixel
                // SV_TARGET is default shader target, indicating where final color is written to
                float4 MyFragmentProgram (Interpolators i): SV_TARGET {
                    i.normal = normalize(i.normal);
                    float3 lightDir = _WorldSpaceLightPos0.xyz;
                    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                    //float3 reflectionDir = reflect(-lightDir, i.normal); // phong model
                    float3 halfVector = normalize(lightDir + viewDir); // blinn - phong model

                    float3 lightColor = _LightColor0.rgb;
                    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
                    // so that specular + albedo doesnt go over the original light strength
                    albedo *= 1 - 
                        max(_SpecularTint.r, max(_SpecularTint.g, _SpecularTint.b)); // so we dont get weird whole albedo tint from specular
                    
                    float3 diffuse = 
                        albedo * lightColor * DotClamped(lightDir, i.normal);
                    float3 specular = _SpecularTint.rgb * lightColor * pow(
                        DotClamped(halfVector, i.normal),
                        _Smoothness * 100
                    );
                    return float4(diffuse + specular, 1); // specular with color 
                }

            ENDCG
        }
    }
}