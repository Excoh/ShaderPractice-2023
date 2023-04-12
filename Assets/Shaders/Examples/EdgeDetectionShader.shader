Shader "PostProcessing/EdgeDetectionShader"
{
    Properties
    {
        _Thickness ("Thickness", float) = 1.0
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

            float _Thickness;
            sampler2D _CameraDepthNormalsTexture;

            v2f vert (appdata v)
            {
                float2 TOP_RIGHT = float2 (1.0, 1.0) * _Thickness;
                float2 BOT_RIGHT = float2 (1.0, -1.0) * _Thickness;
                float2 BOT_LEFT = float2 (-1.0, -1.0) * _Thickness;
                float2 TOP_LEFT = float2 (-1.0, 1.0) * _Thickness;
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 depthNormal = tex2D(_CameraDepthNormalsTexture, i.uv);
                return depthNormal;
            }
            ENDCG
        }
    }
}
