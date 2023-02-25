Shader "Unlit/DoubleCubicSeatShader"
{
    Properties
    {
        _LineColor ("Line Color", Color) = (0.0, 1.0, 0.0, 1.0)
        _LineThickness ("Line Thickness", float) = 0.025
        _MouseHit ("Mouse Hit", Vector) = (0.5, 0.5, 0.0, 0.0)
        _CtrlPointA ("Control Point A", Range(0.0,1.0)) = 0.5
        _CtrlPointB ("Control Point B", Range(0.0,1.0)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            // Pre-defined minimal vertex shader from "UnityCG.cginc"
            #pragma vertex vert_img
            #pragma fragment frag
            #define EPSILON 0.00001
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

            float4 _LineColor;
            float _LineThickness;
            float4 _MouseHit;
            float _CtrlPointA;
            float _CtrlPointB;

            float plot(float2 uv, float y)
            {
               return step(y - _LineThickness, uv.y) -
                      step(y + _LineThickness, uv.y);
            }

            /*
             The double cubic seat is an example followed from
             Golan Levin's tutorial
             http://www.flong.com/archive/texts/code/shapers_poly/
            */
            float doubleCubicSeat(float x, float a, float b)
            {
                // These 'a' min - EPSILON params are used so we
                // don't divide by zero
                float min_param_a = 0.0 + EPSILON;
                float max_param_a = 1.0 - EPSILON;
                float min_param_b = 0.0;
                float max_param_b = 1.0;

                // These equations are used so we don't exceed
                // the range [0.0, 1.0]
                float a_clean = min(max_param_a, max(min_param_a, a));
                float b_clean = min(max_param_b, max(min_param_b, b));

                float y = 0;
                if (x <= a_clean)
                {
                    y = b_clean - b_clean * pow(1-x/a_clean, 3.0);
                } else
                {
                    y = b_clean + (1-b_clean) * pow((x-a_clean)/(1-a_clean), 3.0);
                }

                return y;
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                float y = doubleCubicSeat(i.uv.x, _MouseHit.x, _MouseHit.y);
                float pct = plot(i.uv, y);
                float3 col = float3 (y.xxx);
                col = (1.0 - pct) * col + pct * _LineColor;
                return fixed4 (col, 1.0);
            }
            ENDCG
        }
    }
}
