Shader "Unlit/ExponentialEaseInOutShader"
{
    Properties
    {
        _LineColor ("Line Color", Color) = (0.0, 1.0, 0.0, 1.0)
        _LineThickness ("Line Thickness", float) = 0.025
        _CtrlPoint ("Control Point", Range(0.00001, 1.0)) = 0.5
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
            float4 _LineColor;
            float _LineThickness;
            float _CtrlPoint;

            float plot(float2 uv, float y)
            {
               return step(y - _LineThickness, uv.y) -
                      step(y + _LineThickness, uv.y);
            }

            float exponentialEasing(float x, float ctrlPoint)
            {
                if (ctrlPoint < 0.5)
                {
                    //emphasis or ease-in
                    return pow(x, 2 * ctrlPoint);
                } else
                {
                    //de-emphasis or ease-out
                    return pow(x, 1.0/(1-ctrlPoint));
                }
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                float y = exponentialEasing(i.uv.x, _CtrlPoint);
                float3 col = float3 (y.xxx);
                float pct = plot(i.uv, y);
                col = (1.0 - pct) * col + pct * _LineColor;
                return fixed4 (col, 1.0);
            }
            ENDCG
        }
    }
}
