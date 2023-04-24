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
    public float cameraSpeed = 1.0f;
    public float rotateCameraSpeed = 1.0f;

    private Vector3 prevMousePos;
    private Vector3 currentMousePos;

    private void Start()
    {
        prevMousePos = Input.mousePosition;
    }

    void Update()
    {
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
            Camera.main.transform.position += transform.right * -1 * Time.deltaTime * cameraSpeed;
        }
        else if (IsRightClickPressed() && Input.GetKey(KeyCode.D))
        {
            Camera.main.transform.position += transform.right * Time.deltaTime * cameraSpeed;
        }

        if (IsRightClickPressed() && Input.GetKey(KeyCode.Q))
        {
            Camera.main.transform.position += transform.up * -1 * Time.deltaTime * cameraSpeed;
        }
        else if (IsRightClickPressed() && Input.GetKey(KeyCode.E))
        {
            Camera.main.transform.position += transform.up * Time.deltaTime * cameraSpeed;
        }

        if (IsRightClickPressed())
        {
            currentMousePos = Input.mousePosition;
            Vector3 direction = currentMousePos - prevMousePos;
            //transform.RotateAround(transform.position, transform.forward, direction.x * Time.deltaTime * rotateCameraSpeed);
            //transform.RotateAround(transform.position, transform.right, -direction.y * Time.deltaTime * rotateCameraSpeed);

        }
        prevMousePos = Input.mousePosition;
        

    }

    private bool IsRightClickPressed()
    {
        return Input.GetMouseButton(FreeLookCamera.MouseButton.Right);
    }
}
