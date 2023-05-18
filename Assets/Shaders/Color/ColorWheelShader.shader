Shader "Color/ColorWheelShader"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            // Pre-defined minimal vertex shader from "UnityCG.cginc"
            #pragma vertex vert_img
            #pragma fragment frag
            #define TWO_PI 6.28318530718
            #include "UnityCG.cginc"

            //struct appdata_img
            //{
            //    float4 vertex : POSITION;
            //    half2 texcoord : TEXCOORD0;
            //    UNITY_VERTEX_INPUT_INSTANCE_ID
            //};

            //v2f_img vert_img( appdata_img v )
            //{
            //    v2f_img o;
            //    UNITY_INITIALIZE_OUTPUT(v2f_img, o);
            //    UNITY_SETUP_INSTANCE_ID(v);
            //    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            //
            //    o.pos = UnityObjectToClipPos (v.vertex);
            //    o.uv = v.texcoord;
            //    return o;
            //}

            //struct v2f_img
            //{
            //    float4 pos : SV_POSITION;
            //    half2 uv : TEXCOORD0;
            //    UNITY_VERTEX_INPUT_INSTANCE_ID
            //    UNITY_VERTEX_OUTPUT_STEREO
            //};

            sampler2D _MainTex;

            //  Function from Iñigo Quiles
            //  https://www.shadertoy.com/view/MsS3Wc
            float3 hsb2rgb( float3 c ) {
                float3 rgb = clamp(abs(fmod(c.x*6.0+float3(0.0,4.0,2.0),
                                         6.0)-3.0)-1.0,0.0,1.0);
                rgb = rgb*rgb*(3.0-2.0*rgb);
                return c.z * lerp( float3(1.0,1.0,1.0), rgb, c.y);
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                //// Use polar coordinates instead of cartesian
                //vec2 toCenter = vec2(0.5)-st;
                //float angle = atan(toCenter.y,toCenter.x);
                //float radius = length(toCenter)*2.0;

                //// Map the angle (-PI to PI) to the Hue (from 0 to 1)
                //// and the Saturation to the radius
                //color = hsb2rgb(vec3((angle/TWO_PI)+0.5,radius,1.0));

                //gl_FragColor = vec4(color,1.0);
                float2 toCenter = float2(0.5,0.5)-i.uv;
                float angle = atan2(toCenter.y, toCenter.x);
                float radius = length(toCenter)*2.0;
                // Map the angle (-PI to PI) to the Hue (from 0 to 1)
                // and the Saturation to the radius
                // Spin around the unit circle by adding _Time.z to the angle
                float3 color = hsb2rgb(float3(((angle+_Time.z)/TWO_PI)+0.5,radius,1.0));
                
                // Create a circle mask
                if (abs(distance(float2(0.5,0.5), i.uv)) < 0.5) {
                    return float4 (color.xyz, 1.0);
                }
                else {
                    return float4 (0,0,0,0);
                }
            }
            ENDCG
        }
    }
}
