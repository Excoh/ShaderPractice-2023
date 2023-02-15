Shader "Unlit/MouseShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MouseHit ("Mouse Hit", Vector) = (0.0, 0.0, 0.0, 0.0)
        _ScreenSize ("Screen Size", Vector) = (0.0, 0.0, 0.0, 0.0)
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
            float4 _MouseHit;
            float4 _ScreenSize;

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
                // from GLSL
                // i.uv == gl_FragCoord.xy / u_resolution
                float2 cameraUV = _MouseHit / _ScreenSize;
                return float4 (cameraUV.xy, 0.0, 1.0);
            }
            ENDCG
        }
    }
}
