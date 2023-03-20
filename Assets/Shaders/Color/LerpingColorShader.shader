Shader "Color/LerpingColorShader"
{
    Properties
    {
        _TransitionSpeed ("Transition Speed", float) = 1.0
        _ColorA ("Color A", Color) = (1.0, 0.0, 0.0, 1.0)
        _ColorB ("Color B", Color) = (0.0, 1.0, 0.0, 1.0)
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
            #define PI 3.14159265358979323

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
            vector <float, 4> _ColorA;
            vector <float, 4> _ColorB;
            float _TransitionSpeed;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float pct = abs(sin(PI + _Time.x * _TransitionSpeed));
                col = lerp(_ColorA, _ColorB, pct);
                return col;
            }
            ENDCG
        }
    }
}
