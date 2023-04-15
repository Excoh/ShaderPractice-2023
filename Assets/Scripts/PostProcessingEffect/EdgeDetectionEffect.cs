using UnityEngine;

[ExecuteInEditMode]
public class EdgeDetectionEffect : MonoBehaviour
{
    public Color OutlineColor = Color.white;
    public float Thickness = 1.0f;
    [Range(0.0f, 1.0f)]
    public float Threshold = 0.5f;
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
        material?.SetFloat("_Thickness", Thickness);
        material?.SetFloat("_Threshold", Threshold*0.2f);
        material?.SetVector("_OutlineColor", OutlineColor);
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material?.SetTexture("_CurrentTexture", source);
        Graphics.Blit(source, destination, material, 0);
    }
}
