Shader "Unlit/InverseLerpShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FirstVal ("Start Val", float) = 0
        _SecondVal ("End Val", float) = 100
        _RangeVal ("Range Val", float) = 0
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
            float _FirstVal;
            float _SecondVal;
            float _RangeVal;

            // Returns a percentage value between 0-1
            // If the number "between" is at start return 0
            // If the number "between" is at end return 1
            float invLerp(float start, float end, float between)
            {
                return (between - start) / (end - start);
            }

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
                return fixed4 (invLerp(_FirstVal, _SecondVal, _RangeVal), 1, 1, 1);
            }
            ENDCG
        }
    }
}
