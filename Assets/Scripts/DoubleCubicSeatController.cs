using UnityEngine;

[AddComponentMenu("Shaping Function/Double Cubic Seat")]
public class DoubleCubicSeatController : MonoBehaviour
{
    public Material material;

    // Update is called once per frame
    void Update()
    {
        Vector2 pt = new Vector2(CameraPointer.Instance.MouseButtonHitPoint.x, CameraPointer.Instance.MouseButtonHitPoint.z);
        Vector2 col = new Vector2(CameraPointer.Instance.HitColliderSize.x, CameraPointer.Instance.HitColliderSize.z);
        float x = ((pt.x * 2f) - col.x) / (2f * col.x);
        float y = ((pt.y * 2f) - col.y) / (2f * col.y);
        Vector2 normalizedPoint = new Vector2(x, y);
        material?.SetVector("_MouseHit", new Vector4(normalizedPoint.x, normalizedPoint.y, 0f, 0f));
    }
}
