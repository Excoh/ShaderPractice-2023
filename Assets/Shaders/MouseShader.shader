Shader "Unlit/MouseShader"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float4 _MouseHit;

            fixed4 frag (v2f_img i) : SV_Target
            {
                // from GLSL
                // i.uv == gl_FragCoord.xy / u_resolution
                float2 cameraUV = _MouseHit / float4(_ScreenParams.x,_ScreenParams.y, 1.0, 1.0);
                return float4 (cameraUV.xy, 0.0, 1.0);
            }
            ENDCG
        }
    }
}
