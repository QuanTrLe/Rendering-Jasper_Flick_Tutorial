// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Shader" {
    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
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

                struct Interpolators {
                    float4 position: SV_POSITION;
                    float3 localPosition: TEXCOORD0;
                };

                // indicating what we're outputing (System Val Position) 
                Interpolators MyVertexProgram (float4 position: POSITION){
                    Interpolators i;
                    i.localPosition = position.xyz;
                    i.position = UnityObjectToClipPos(position); // this is the vertex's position * UNITY_MATRIX_MVP;
                    return i;
                }


                // output rgba color val for one pixel
                // SV_TARGET is default shader target, indicating where final color is written to
                float4 MyFragmentProgram (Interpolators i): SV_TARGET {
                    return float4(i.localPosition + 0.5, 1) * _Tint;
                }

            ENDCG
        }
    }
}