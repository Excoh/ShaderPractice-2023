using UnityEngine;

public class CameraPointer : MonoBehaviour
{
    public Material mouseMaterial;

    private void Start()
    {
        mouseMaterial.SetVector("_ScreenSize", new Vector4(Screen.width, Screen.height));
    }
    private void FixedUpdate()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        Debug.DrawRay(ray.origin, ray.direction * 15, Color.red);

        RaycastHit hit;
        if (Physics.Raycast(ray, out hit))
        {
            //Debug.Log(hit.point);
            Vector3 screenPoint = Camera.main.WorldToScreenPoint(hit.point);
            mouseMaterial.SetVector("_MouseHit", new Vector4(screenPoint.x, screenPoint.y, 0, 0));
        }
    }
}
