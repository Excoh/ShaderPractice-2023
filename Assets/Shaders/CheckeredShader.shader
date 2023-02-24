Shader "Unlit/CheckeredShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Division ("Divisions", float) = 4.0
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Division;

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
                float ux = frac(i.uv.x * _Division);
                float uy = frac(i.uv.y * _Division);
                float uxy = ux + uy;
                float final = smoothstep(0.0,1.5,uxy);
                return fixed4(final.xxx, 1.0);
            }
            ENDCG
        }
    }
}
