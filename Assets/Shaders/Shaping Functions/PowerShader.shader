Shader "Unlit/PowerShader"
{
    Properties
    {
        _LineThickness ("Line Thickness", Range(0.0, 1.0)) = 0.02
        _LineColor ("Line Color", Color) = (0.0, 1.0, 0.0, 1.0)
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
            float4 _LineColor;

            float plot(float2 uv, float y)
            {
               //return smoothstep(y - _LineThickness, y, uv.y) -
               //       smoothstep(y, y + _LineThickness, uv.y);
               return step(y - _LineThickness, uv.y) -
                      step(y + _LineThickness, uv.y);
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
                float y = pow(i.uv.x, 5.0);
                float3 col = float3 (y.xxx);
                float pct = plot (i.uv, y);
                col = (1.0 - pct) * col + pct * _LineColor;
                return fixed4 (col, 1.0);
            }
            ENDCG
        }
    }
}
