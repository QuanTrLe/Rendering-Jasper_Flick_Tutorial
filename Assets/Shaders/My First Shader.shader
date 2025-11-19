// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Shader" {
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


                // indicating what we're outputing (System Val Position) 
                float4 MyVertexProgram (float4 position: POSITION): SV_POSITION {
                    return UnityObjectToClipPos(position); // this is the vertex position * UNITY_MATRIX_MVP;
                }


                // output rgba color val for one pixel
                // SV_TARGET is default shader target, windicating where final color is written to
                float4 MyFragmentProgram (
                    float4 position: SV_POSITION // input var to read from specific semantic
                ): SV_TARGET {
                    return float4(1, 0.5, 1, 1);
                }

            ENDCG
        }
    }
}