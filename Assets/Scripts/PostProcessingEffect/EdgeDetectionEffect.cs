using UnityEngine;

[ExecuteInEditMode]
public class EdgeDetectionEffect : MonoBehaviour
{
    private Material material;
    private Camera cam;

    private void Awake()
    {
        material = new Material(Shader.Find("PostProcessing/EdgeDetectionShader"));
        cam = GetComponent<Camera>();
        cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.DepthNormals;
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}
