using UnityEngine;

namespace FreeLookCamera
{
    public struct MouseButton
    {
        public static int Left = 0;
        public static int Right = 1;
        public static int Middle = 2;
    }
}
[RequireComponent(typeof(Camera))]
public class FreelookCamera : MonoBehaviour
{
    // Update is called once per frame
    public float cameraSpeed = 15.0f;
    public float rotateCameraSpeed = 45.0f;

    private Vector3 prevMousePos;
    private Vector3 currentMousePos;

    private void Start()
    {
        prevMousePos = Input.mousePosition;
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(1))
        {
            prevMousePos = Input.mousePosition;
        }
        if (IsRightClickPressed() && Input.GetKey(KeyCode.W))
        {
            Camera.main.transform.position += transform.forward * Time.deltaTime * cameraSpeed;
        }
        else if (IsRightClickPressed() && Input.GetKey(KeyCode.S))
        {
            Camera.main.transform.position += transform.forward * -1 * Time.deltaTime * cameraSpeed;
        }

        if (IsRightClickPressed() && Input.GetKey(KeyCode.A))
        {
            Camera.main.transform.Translate(Camera.main.transform.right * -1 * Time.deltaTime * cameraSpeed, Space.World);
        }
        else if (IsRightClickPressed() && Input.GetKey(KeyCode.D))
        {
            Camera.main.transform.Translate(Camera.main.transform.right * Time.deltaTime * cameraSpeed, Space.World);
        }

        if (IsRightClickPressed() && Input.GetKey(KeyCode.Q))
        {
            Camera.main.transform.position += Vector3.down * Time.deltaTime * cameraSpeed;
        }
        else if (IsRightClickPressed() && Input.GetKey(KeyCode.E))
        {
            Camera.main.transform.position += Vector3.up * Time.deltaTime * cameraSpeed;
        }

        if (IsRightClickPressed())
        {
            currentMousePos = Input.mousePosition;
            Vector3 direction = currentMousePos - prevMousePos;
            if (Mathf.Abs(Vector3.Magnitude(direction)) > 0.0f)
            {
                Camera.main.transform.Rotate(0, direction.x * Time.deltaTime * rotateCameraSpeed, 0f, Space.World);
                Camera.main.transform.Rotate(transform.right, -direction.y * Time.deltaTime * rotateCameraSpeed, Space.World);
            }
            prevMousePos = currentMousePos;
        }
        

    }

    private bool IsRightClickPressed()
    {
        return Input.GetMouseButton(FreeLookCamera.MouseButton.Right);
    }
}
