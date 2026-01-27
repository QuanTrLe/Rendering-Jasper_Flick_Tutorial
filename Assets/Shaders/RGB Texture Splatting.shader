// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RGB Texture Splatting" {
    Properties {
        _MainTex ("Splat Map", 2D) = "white" {}
        [NoScaleOffset] _Texture1 ("Texture 1", 2D) = "white" {}
		[NoScaleOffset] _Texture2 ("Texture 2", 2D) = "white" {}
        [NoScaleOffset] _Texture3 ("Texture 1", 2D) = "white" {}
		[NoScaleOffset] _Texture4 ("Texture 2", 2D) = "white" {}
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

                sampler2D _MainTex;
                float4 _MainTex_ST;

                sampler2D _Texture1, _Texture2, _Texture3, _Texture4;

                struct Interpolators {
                    float4 position: SV_POSITION;
                    float2 uv: TEXCOORD0;
                    float2 uvSplat : TEXCOORD1;
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
                    i.uvSplat = v.uv;
                    return i;
                }


                // output rgba color val for one pixel
                // SV_TARGET is default shader target, indicating where final color is written to
                float4 MyFragmentProgram (Interpolators i): SV_TARGET {
                    float4 splat = tex2D(_MainTex, i.uvSplat);
                    return
					tex2D(_Texture1, i.uv) * splat.r +
					tex2D(_Texture2, i.uv) * splat.g +
					tex2D(_Texture3, i.uv) * splat.b +
					tex2D(_Texture4, i.uv) * (1 - splat.r - splat.g - splat.b);
                }

            ENDCG
        }
    }
}