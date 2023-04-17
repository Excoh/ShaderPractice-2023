using System;
using UnityEngine;

public class MousePlaneController : MonoBehaviour
{
    public Material material;
    public Texture2D texture;

    private void OnGUI()
    {
        GUILayout.BeginHorizontal();
        GUILayout.Box(NormalizedScreenCoordinates());
        GUILayout.EndHorizontal();
    }

    private string NormalizedScreenCoordinates()
    {
        float x = (float)Math.Round(CameraPointer.Instance.MouseHoverScreenPoint.x / Camera.main.scaledPixelWidth,2);
        float y = (float)Math.Round(CameraPointer.Instance.MouseHoverScreenPoint.y / Camera.main.scaledPixelHeight,2);
        return string.Format("({0}, {1})", x, y);
    }

    private void Update()
    {
        material?.SetVector("_MouseHit", CameraPointer.Instance.MouseHoverScreenPoint);
    }
}
