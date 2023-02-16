Shader "Unlit/DrawnLineShader"
{
    Properties
    {
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

            float _LineThickness;

            float plot(float2 uv)
            {
                return smoothstep(_LineThickness, 0.0, abs(uv.x - uv.y));
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
                col = (1.0-pct)*col+pct*float3(0.0,1.0,0.0);

                return fixed4(col, 1.0);
            }
            ENDCG
        }
    }
}
