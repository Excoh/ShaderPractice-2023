Shader "Unlit/DrawnLineShader"
{
    Properties
    {
        [Toggle(ENABLE_SMOOTH_LINE)] _IsSmoothLine ("Is Line Smooth", float) = 0.0
        _LineColor ("Line Color", Color) = (0.0, 1.0, 0.0, 1.0)
        _LineThickness ("Line Thickness", Range(0.0, 1.0)) = 0.02
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma shader_feature ENABLE_SMOOTH_LINE

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            float4 _LineColor;
            float _LineThickness;

            float plot(float2 uv)
            {
            #ifdef ENABLE_SMOOTH_LINE
                return smoothstep(_LineThickness, 0.0, abs(uv.x - uv.y));
            #else
                return step(abs(uv.x - uv.y), _LineThickness);
            #endif
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float pct = plot(i.uv);
                float3 col = float3 (i.uv.xxx);
                col = (1.0 - pct) * col + pct * _LineColor;

                return fixed4(col, 1.0);
            }
            ENDCG
        }
    }
}
