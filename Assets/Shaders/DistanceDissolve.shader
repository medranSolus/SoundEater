﻿Shader "DeadlineCoders/DistanceDissolve"
{
    Properties
    {
        _MainTex( "Base (RGB)", 2D ) = "white" {}
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature YELLOW_COL // Shader keyword
            #pragma shader_feature RED_COL // Shader keyword
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert( appdata v )
            {
                v2f o;
                o.vertex = UnityObjectToClipPos( v.vertex );
                return o;
            }

            fixed4 frag( v2f i ) : SV_Target
            {
                /*#if RED_COL
                return fixed4( 1,0,0,1 ); // Red if keyword enabled
                #endif
                #if YELLOW_COL
                return fixed4( 1,1,0,1 ); // Yellow if keyword enabled
                #endif
                return fixed4( 1,1,1,1 ); // White if no keyword enabled*/

                return fixed4( 1,0,0,1 );
            }
            ENDCG
        }
    }
}