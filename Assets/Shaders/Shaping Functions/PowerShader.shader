Shader "Unlit/PowerShader"
{
    Properties
    {
        _LineThickness ("Line Thickness", Range(-1.0, 1.0)) = 0.02
        _LogColor ("Log Color", Color) = (0.0, 1.0, 0.0, 1.0)
        _ExpColor ("Exponential (e^x) Color", Color) = (0.0, 1.0, 0.0, 1.0)
        _PowColor ("Power Color", Color) = (0.0, 1.0, 0.0, 1.0)
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
            #define PI 3.1415926535

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _LineThickness;
            float4 _LogColor;
            float4 _ExpColor;
            float4 _PowColor;

            float plot(float2 uv, float y)
            {
               return smoothstep(y - _LineThickness, y, uv.y) -
                      smoothstep(y, y + _LineThickness, uv.y);
               // Makes the line sharper
               //return step(y - _LineThickness, uv.y) -
               //       step(y + _LineThickness, uv.y);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Log
                float y = (log(sin(i.uv.x*PI+_Time.w))+1.0);
                float3 col = float3 (y.xxx);
                float pct = plot (i.uv, y);
                col = (1.0 - pct) * col + pct * _LogColor;
                // Exponential
                float y2 = exp(i.uv.x)-1.0;
                float pct2 = plot(i.uv, y2);
                col = (1.0 - pct2) * col + pct2 * _ExpColor;
                // Power
                float y3 = pow(i.uv.x-0.5, 2.0)+0.2;
                float pct3 = plot(i.uv, y3);
                col = (1.0 - pct3) * col + pct3 * _PowColor;
                return fixed4 (col, 1.0);
            }
            ENDCG
        }
    }
}
