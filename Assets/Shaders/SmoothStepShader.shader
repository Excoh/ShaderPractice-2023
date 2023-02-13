Shader "Unlit/SmoothStepShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BottomThreshold ("Bottom Threshold", Range(0, 1)) = 0.25
        _TopThreshold ("Top Threshold", Range(0, 1)) = 0.75
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
            float _BottomThreshold;
            float _TopThreshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 col = smoothstep(_BottomThreshold, _TopThreshold, i.uv.x);
                return float4(col, 1.0);
            }
            ENDCG
        }
    }
}
