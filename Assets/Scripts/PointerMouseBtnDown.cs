using UnityEngine;

public class PointerMouseBtnDown : MonoBehaviour
{
    [SerializeField]
    private Material material;
    private Collider col;

    private void Awake()
    {
        col = GetComponent<Collider>();
    }
    private void FixedUpdate()
    {
        if (Input.GetMouseButton(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            Debug.DrawRay(ray.origin, ray.direction * 15, Color.red);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                //Debug.Log(hit.point);
                float x = ((hit.point.x * 2f) - hit.collider.bounds.size.x) / (2f * hit.collider.bounds.size.x);
                // we're in the X-Z plane
                float y = ((hit.point.z * 2f) - hit.collider.bounds.size.z) / (2f * hit.collider.bounds.size.z);
                Vector2 normalizedPoint = new Vector2(x, y);
                //Debug.Log(normalizedPoint);
                material?.SetVector("_MouseHit", new Vector4(normalizedPoint.x, normalizedPoint.y, 0f, 0f));
            }
        }
    }
}
