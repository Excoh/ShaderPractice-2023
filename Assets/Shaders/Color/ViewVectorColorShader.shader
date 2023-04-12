Shader "Unlit/ViewVectorColorShader"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0,0,0,0)
        _ImpulseColor ("Impulse Color", Color) = (1,0,0,1)
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
                float3 normal : NORMAL; // surface normal
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 viewDir : TEXCOORD1;
                float3 normal : TEXCOORD2;
            };

            float4 _BaseColor;
            float4 _ImpulseColor;

            float expImpulse(float x, float k)
            {
                const float h = k*x;
                return h * exp(1.0-h);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float percent = saturate(expImpulse(sin(_Time.y*2*UNITY_PI), UNITY_PI)) * 0.5;
                return dot(i.normal, i.viewDir) * lerp(_BaseColor, _ImpulseColor, percent);
            }
            ENDCG
        }
    }
}
