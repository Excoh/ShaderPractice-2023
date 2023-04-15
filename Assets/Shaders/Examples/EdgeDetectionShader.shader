Shader "PostProcessing/EdgeDetectionShader"
{
    Properties
    {
        _CurrentTexture ("Current Texture", 2D) = "white" {}
        _Thickness ("Thickness", float) = 1.0
        _OutlineColor ("Outline Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        //GrabPass {
        //    "_GrabTexture"
        //}

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
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                //float4 grabPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            float _Thickness;
            float _Threshold = 0.5;
            float4 _OutlineColor;
            sampler2D _CameraDepthNormalsTexture;
            //sampler2D _GrabTexture;
            sampler2D _CurrentTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                //o.grabPos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 TOP_RIGHT = (float2 (1.0, 1.0) * _Thickness) / _ScreenParams.xy;
                float2 BOT_RIGHT = (float2 (1.0, -1.0) * _Thickness) / _ScreenParams.xy;
                float2 BOT_LEFT = (float2 (-1.0, -1.0) * _Thickness) / _ScreenParams.xy;
                float2 TOP_LEFT = (float2 (-1.0, 1.0) * _Thickness) / _ScreenParams.xy;
                float4 depthNormal = tex2D(_CameraDepthNormalsTexture, i.uv);
                float3 normal;
                float depth;
                DecodeDepthNormal(depthNormal, depth, normal);
                float4 depthNormal_TOP_RIGHT = tex2D(_CameraDepthNormalsTexture, i.uv + TOP_RIGHT);
                float4 depthNormal_BOT_RIGHT = tex2D(_CameraDepthNormalsTexture, i.uv + BOT_RIGHT);
                float4 depthNormal_BOT_LEFT = tex2D(_CameraDepthNormalsTexture, i.uv + BOT_LEFT);
                float4 depthNormal_TOP_LEFT = tex2D(_CameraDepthNormalsTexture, i.uv + TOP_LEFT);
                float3 normal_TOP_RIGHT;
                float3 normal_BOT_RIGHT;
                float3 normal_BOT_LEFT;
                float3 normal_TOP_LEFT;
                float depth_TOP_RIGHT;
                float depth_BOT_RIGHT;
                float depth_BOT_LEFT;
                float depth_TOP_LEFT;
                DecodeDepthNormal(depthNormal_TOP_RIGHT, depth_TOP_RIGHT, normal_TOP_RIGHT);
                DecodeDepthNormal(depthNormal_BOT_RIGHT, depth_BOT_RIGHT, normal_BOT_RIGHT);
                DecodeDepthNormal(depthNormal_BOT_LEFT, depth_BOT_LEFT, normal_BOT_LEFT);
                DecodeDepthNormal(depthNormal_TOP_LEFT, depth_TOP_LEFT, normal_TOP_LEFT);
                depth = depth * _ProjectionParams.z;
                normal = normal * 0.5 + 0.5;
                normal_TOP_RIGHT = normal_TOP_RIGHT * 0.5 + 0.5;
                normal_BOT_RIGHT = normal_BOT_RIGHT * 0.5 + 0.5;
                normal_BOT_LEFT = normal_BOT_LEFT * 0.5 + 0.5;
                normal_TOP_LEFT = normal_TOP_LEFT * 0.5 + 0.5;
                float3 diffTRBL = abs(normal_TOP_RIGHT - normal_BOT_LEFT);
                float3 diffTLBR = abs(normal_TOP_LEFT - normal_BOT_RIGHT);
                float3 diff = diffTLBR + diffTRBL;
                float maxVal = max(max(diff.r,diff.g),diff.b);
                maxVal = smoothstep(0.2, 0.7, maxVal);
                return lerp(tex2D(_CurrentTexture, i.uv), maxVal * _OutlineColor, maxVal);
            }
            ENDCG
        }
    }
}
