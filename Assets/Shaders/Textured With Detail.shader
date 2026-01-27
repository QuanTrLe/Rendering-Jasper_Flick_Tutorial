// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Textured With Detail" {
    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _DetailTex ("Detail Texture", 2D) = "gray" {}
    }

    SubShader {
        Pass {
            CGPROGRAM

                // set what is our vertex and fragment program
                // pragma is basically for issuing special compiler directives
                #pragma vertex MyVertexProgram
			    #pragma fragment MyFragmentProgram

                // the boilerplate code: common vars, funcs, and other things
                // also make it so you dont have to worry about platform specific stuffs
                #include "UnityCG.cginc"

                float4 _Tint;
                sampler2D _MainTex, _DetailTex;
                float4 _MainTex_ST, _DetailTex_ST;

                struct Interpolators {
                    float4 position: SV_POSITION;
                    float2 uv: TEXCOORD0;
                    float2 uvDetail: TEXCOORD1;
                };

                struct VertexData {
                    float4 position: POSITION;
                    float2 uv: TEXCOORD0;
                };

                // indicating what we're outputing (System Val Position) 
                Interpolators MyVertexProgram (VertexData v){
                    Interpolators i;
                    i.position = UnityObjectToClipPos(v.position); // this is the vertex's position * UNITY_MATRIX_MVP;
                    i.uv = TRANSFORM_TEX(v.uv, _MainTex); // uv coordinates applied after material tilling and offset
                    i.uvDetail = TRANSFORM_TEX(v.uv, _DetailTex); // for the detailed texture
                    return i;
                }


                // output rgba color val for one pixel
                // SV_TARGET is default shader target, indicating where final color is written to
                float4 MyFragmentProgram (Interpolators i): SV_TARGET {
                    // given a texture sample and uv coord return color
                    float4 fragmentColor = tex2D(_MainTex, i.uv) * _Tint;
                    fragmentColor *= tex2D(_DetailTex, i.uv * 10) * 2;
                    return fragmentColor;
                }

            ENDCG
        }
    }
}