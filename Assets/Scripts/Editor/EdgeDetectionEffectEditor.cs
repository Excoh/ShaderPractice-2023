using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(EdgeDetectionEffect))]
public class EdgeDetectionEffectEditor : Editor
{
    private EdgeDetectionEffect effect;
    private GUILayoutOption[] layoutOptions;
    private const float SLIDER_PADDING = 5f;
    private void OnEnable()
    {
        effect = (EdgeDetectionEffect)target;
        layoutOptions = new GUILayoutOption[] { GUILayout.MaxWidth(50) };
    }
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        EditorGUI.BeginChangeCheck();
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("MinMax Threshold", new GUILayoutOption[] { GUILayout.MaxWidth(EditorGUIUtility.labelWidth) });
        effect.MinThreshold = EditorGUILayout.FloatField(effect.MinThreshold, layoutOptions);
        GUILayout.Space(SLIDER_PADDING);
        EditorGUILayout.MinMaxSlider(ref effect.MinThreshold, ref effect.MaxThreshold, 0, 1);
        GUILayout.Space(SLIDER_PADDING);
        effect.MaxThreshold = EditorGUILayout.FloatField(effect.MaxThreshold, layoutOptions);
        if (EditorGUI.EndChangeCheck())
        {
            EditorUtility.SetDirty(effect);
        }
        EditorGUILayout.EndHorizontal();
    }
}
