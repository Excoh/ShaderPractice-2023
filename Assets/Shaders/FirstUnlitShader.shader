// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/FirstUnlitShader"
{
    Properties
    {
        _OutlineWidth ("Outline Width", Float) = 1.0
        _OutlineSoftness ("Outline Softness", Float) = 1.0
        _OutlinePower ("Outline Power", Float) = 2.0
        [HideInInspector] _MainTex ("", 2D) = "white" {}
        [HideInInspector] _TestColor ("LMAO COLOR", Color) = (0.5, 0.5, 0.5, 1)
        [HideInInspector] _TestVector ("LMAO VECTOR", Vector) = (1, 1, 1, 1)
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
            // fragment could be consider an atomic single unit that is rendered, like a pixel

            #include "UnityCG.cginc"
            #define DIV_SQRT_2 0.70710678118

            struct appdata
            {
                // These values come from the vertex buffer
                // If the vertex declaration and the vertex buffer do not contain all elements specified by the semantics,
                // the corresponding variables are set to 0
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                fixed4 color : COLOR;
            };

            struct VertexShaderOutput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float _OutlineWidth;
            float _OutlineSoftness;
            float _OutlinePower;
            fixed4 _TestColor;
            float4 _MainTex_ST;

            VertexShaderOutput vert (appdata v)
            {
                VertexShaderOutput o;
                //o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.vertex = float4(UnityObjectToViewPos(v.vertex), 0);
                //o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.color = v.color;
                return o;
            }

            fixed4 frag (VertexShaderOutput i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _TestColor;
                col *= i.color;
                //return col;
                //half4 color = 0;
                //color = i.uv * 0.5 + 0.5;

                //sample directions
                float2 directions[8] = {float2(1, 0), float2(0, 1), float2(-1, 0), float2(0, -1),
                float2(DIV_SQRT_2, DIV_SQRT_2), float2(-DIV_SQRT_2, DIV_SQRT_2),
                float2(-DIV_SQRT_2, -DIV_SQRT_2), float2(DIV_SQRT_2, -DIV_SQRT_2)};

                //generate border
                float maxAlpha = 0;
                for(uint index = 0; index < 8; index++){
                    float2 sampleUV = i.uv + directions[index] * 0.01;
                    maxAlpha = max(maxAlpha, tex2D(_MainTex, sampleUV).a);
                }

                //apply border
                col.rgb = lerp(float3(1, 0, 0), col.rgb, col.a);
                col.a = max(col.a, maxAlpha);

                return col;
                //float edge1 = 1 - _OutlineWidth;
                //float edge2 = edge1 + _OutlineSoftness;
                //float fresnel = pow(1.0 - saturate(dot(i.normal, float3(0,1,0)), _OutlinePower);
                //return lerp(1, smoothstep(edge1, edge2, fresnel), step(0, edge1)) * _OutlineColor;
            }
            ENDCG
        }
    }
}
