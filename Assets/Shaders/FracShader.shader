Shader "Unlit/FracShader"
{
    Properties
    {
        _FracCount ("Frac Count", Range(0, 50)) = 2
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

            float _FracCount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //float fx4 = frac(i.uv.x * 2);
                //fixed4 xfirst = fixed4 (fx4.x, fx4.x, fx4.x, 1.0);
                //return xfirst;
                float fxy4 = frac(i.uv.x * i.uv.y * _FracCount);
                return fixed4 (fxy4.xxx, 1.0);
            }
            ENDCG
        }
    }
}
