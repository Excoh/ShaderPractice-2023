using UnityEngine;

[ExecuteInEditMode]
public class EdgeDetectionEffect : MonoBehaviour
{
    public Color OutlineColor = Color.white;
    public float Thickness = 1.0f;
    [HideInInspector]
    public float DepthMinThreshold = 0.5f;
    [HideInInspector]
    public float DepthMaxThreshold = 0.0f;
    [HideInInspector]
    public float NormalMaxThreshold = 1.0f;
    [HideInInspector]
    public float NormalMinThreshold = 0f;
    private Material material;
    private Camera cam;

    private void Awake()
    {
        material = new Material(Shader.Find("PostProcessing/EdgeDetectionShader"));
        cam = GetComponent<Camera>();
        cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.DepthNormals;
    }

    private void Update()
    {
        ReboundThresholds();
        material?.SetFloat("_Thickness", Thickness);
        material?.SetFloat("_DepthMinThreshold", DepthMinThreshold);
        material?.SetFloat("_DepthMaxThreshold", DepthMaxThreshold);
        material?.SetFloat("_NormalMinThreshold", NormalMinThreshold);
        material?.SetFloat("_NormalMaxThreshold", NormalMaxThreshold);
        material?.SetVector("_OutlineColor", OutlineColor);
    }

    private void ReboundThresholds()
    {
        DepthMaxThreshold = Mathf.Max(DepthMaxThreshold, DepthMinThreshold);
        DepthMinThreshold = Mathf.Max(DepthMinThreshold, 0);
        NormalMaxThreshold = Mathf.Max(NormalMaxThreshold, NormalMinThreshold);
        NormalMinThreshold = Mathf.Max(NormalMinThreshold, 0);
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material?.SetTexture("_CurrentTexture", source);
        Graphics.Blit(source, destination, material, 0);
    }
}
