inline float plot(float2 uv, float y, float lineThickness = 0.025)
{
    return step(y - lineThickness, uv.y) -
            step(y + lineThickness, uv.y);
}

inline float3 show(float2 uv, float y, float4 lineColor = float4(0.0,1.0,0.0,1.0), float lineThickness = 0.025)
{
    float pct = plot(uv, y, lineThickness);
    float3 col = float3 (y.xxx);
    col = (1.0 - pct) * col + pct * lineColor;
    return col;
}

inline float3 add_plot(float2 uv, float3 existing_plot, float y, float4 lineColor = float4(0.0,1.0,0.0,1.0), float lineThickness = 0.025)
{
    float pct = plot(uv, y, lineThickness);
    float3 new_plot = (1.0 - pct) * existing_plot + pct * lineColor;
    return new_plot;
}