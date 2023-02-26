using UnityEngine;
public static class MouseButton
{
    public static int Left = 0;
    public static int Right = 1;
    public static int Middle = 2;
}
public class CameraPointer : MonoBehaviour
{
    public static CameraPointer Instance { get; private set; }
    /// <summary>
    /// The world space point where the mouse is hovering when a collider is hit.
    /// </summary>
    public Vector3 MouseHoverHitPoint;
    /// <summary>
    /// The screen space point (in pixels) where the mouse is hovering when a collider is hit.
    /// Bottom-left of the screen is (0,0), the right-top is (pixelWidth, pixelHeight).
    /// </summary>
    public Vector3 MouseHoverScreenPoint;
    /// <summary>
    /// The world space point where the left mouse button is being held down.
    /// </summary>
    public Vector3 MouseButtonHitPoint;
    public Vector3 HitColliderSize;

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
    }

    private void FixedUpdate()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        RaycastHit hit;
        if (Physics.Raycast(ray, out hit))
        {
            Debug.DrawRay(ray.origin, ray.direction * 15, Color.red);
            MouseHoverHitPoint = hit.point;
            HitColliderSize = hit.collider.bounds.size;
            //Debug.Log(hit.point);
            MouseHoverScreenPoint = Camera.main.WorldToScreenPoint(hit.point);

            if (Input.GetMouseButton(MouseButton.Left))
            {
                MouseButtonHitPoint = hit.point;
            }
        } else
        {
            MouseHoverScreenPoint = Vector2.one * -1f;
        }
    }
}
