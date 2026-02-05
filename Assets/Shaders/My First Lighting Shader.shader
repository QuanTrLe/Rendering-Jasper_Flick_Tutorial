// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Lighting Shader" {
    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
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
            #pragma target 3.0 // so that Unity selects the best BRDF functions, at least 3.0
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            // all the base lighting default we made with Unity's BRDF
            #include "My Lighting.cginc"
                
            ENDCG
        }

        Pass { // pass it forward and add the next guy to it
            Tags {
                "LightMode" = "ForwardAdd"
            }
            Blend One One // meaning additive blending between old and new pixel data 

            CGPROGRAM
            #pragma target 3.0
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "My Lighting.cginc"
            ENDCG
        }
    }
}