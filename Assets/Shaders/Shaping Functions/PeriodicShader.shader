Shader "Shaping Function/Periodic Shader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Period ("Period", float) = 0.025
        _BarSize ("Bar Size", float) = 0.85
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
            #define PI 3.141592653589793238462643383279

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float _Period;
            uniform float _BarSize;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float test = step(_BarSize, sin(i.uv.y * PI +  _Time.y * _Period));
                return fixed4(test.xxx, 1.0);
            }
            ENDCG
        }
    }
}
