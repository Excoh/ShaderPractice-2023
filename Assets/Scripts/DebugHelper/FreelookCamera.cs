using System;
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
    public float cameraPanSpeed = 15.0f;
    public float rotationStartDeadZone = 0.5f;
    [Range(0.0f, 1.0f)]
    public float cameraRotateSpeed = 0.85f;

    private Vector3 initialRotation;
    private Vector3 prevMousePos;
    private Vector3 currentMousePos;

    private void Start()
    {
        prevMousePos = Input.mousePosition;
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(FreeLookCamera.MouseButton.Right))
        {
            prevMousePos = Input.mousePosition;
            initialRotation = transform.rotation.eulerAngles;
        }
        if (IsRightClickHeld() && Input.GetKey(KeyCode.W))
        {
            Camera.main.transform.position += transform.forward * Time.deltaTime * cameraPanSpeed;
        }
        else if (IsRightClickHeld() && Input.GetKey(KeyCode.S))
        {
            Camera.main.transform.position += transform.forward * -1 * Time.deltaTime * cameraPanSpeed;
        }

        if (IsRightClickHeld() && Input.GetKey(KeyCode.A))
        {
            Camera.main.transform.Translate(Camera.main.transform.right * -1 * Time.deltaTime * cameraPanSpeed, Space.World);
        }
        else if (IsRightClickHeld() && Input.GetKey(KeyCode.D))
        {
            Camera.main.transform.Translate(Camera.main.transform.right * Time.deltaTime * cameraPanSpeed, Space.World);
        }

        if (IsRightClickHeld() && Input.GetKey(KeyCode.Q))
        {
            Camera.main.transform.position += -Camera.main.transform.up * Time.deltaTime * cameraPanSpeed;
        }
        else if (IsRightClickHeld() && Input.GetKey(KeyCode.E))
        {
            Camera.main.transform.position += Camera.main.transform.up * Time.deltaTime * cameraPanSpeed;
        }

        if (IsRightClickHeld())
        {
            currentMousePos = Input.mousePosition;
            Vector3 direction = currentMousePos - prevMousePos;
            float magnitude = Vector3.Magnitude(direction);
            if (Mathf.Abs(magnitude) > rotationStartDeadZone)
            {
                Vector3 newRotation = initialRotation + new Vector3(-direction.y, direction.x, 0) * cameraRotateSpeed;
                transform.rotation = Quaternion.Euler(newRotation);
            }
        }
    }

    private bool IsRightClickHeld()
    {
        return Input.GetMouseButton(FreeLookCamera.MouseButton.Right);
    }
}
