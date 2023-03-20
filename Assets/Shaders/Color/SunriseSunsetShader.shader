Shader "Color/SunriseSunsetShader"
{
    Properties
    {
        _SunriseHorizon ("Sunrise Horizon", Color) = (1.0,0.0,0.0,1.0)
        _SunriseSky ("Sunrise Sky", Color) = (0.0,0.0,1.0,1.0)
        _SunriseGround ("Sunrise Ground", Color) = (0.0,0.0,0.0,1.0)
        _SunsetHorizon ("Sunset Horizon", Color) = (1.0,0.0,0.0,1.0)
        _SunsetSky ("Sunset Sky", Color) = (0.0,0.0,1.0,1.0)
        _SunsetGround ("Sunset Ground", Color) = (0.0,0.0,0.0,1.0)
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
            #define PI 3.14159265358979

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _SunriseHorizon;
            float4 _SunriseSky;
            float4 _SunriseGround;
            float4 _SunsetHorizon;
            float4 _SunsetSky;
            float4 _SunsetGround;
            

            float4 frag (v2f i) : SV_Target
            {
                float time = PI + _Time.y;
                float3 col;
                if (i.uv.y > 0.5)
                {
                    float4 sunrise = lerp(_SunriseHorizon, _SunriseSky, (i.uv.y-0.5)*2);
                    float4 sunset = lerp(_SunsetHorizon, _SunsetSky, (i.uv.y-0.5)*2);
                    col = lerp(sunrise, sunset, sin(time));
                } else
                {
                    float4 sunrise = _SunriseGround;
                    float4 sunset = _SunsetGround;
                    col = lerp (sunrise, sunset, sin(time));
                }
                return float4 (col, 1.0);
            }
            ENDCG
        }
    }
}
