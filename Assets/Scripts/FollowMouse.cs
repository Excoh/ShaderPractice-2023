using UnityEngine;

public class FollowMouse : MonoBehaviour
{
    public bool showCursor = false;
    public GameObject objectToFollowMouse;
    private void Start()
    {
        Cursor.visible = showCursor;
    }
    void LateUpdate()
    {
        Vector3 worldPos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, objectToFollowMouse.transform.position.z));
        objectToFollowMouse.transform.position = new Vector3(worldPos.x, worldPos.y, objectToFollowMouse.transform.position.z);
    }
}
