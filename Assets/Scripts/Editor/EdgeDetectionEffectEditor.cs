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
        EditorGUILayout.LabelField("Depth MinMax Threshold", new GUILayoutOption[] { GUILayout.MaxWidth(EditorGUIUtility.labelWidth) });
        effect.DepthMinThreshold = EditorGUILayout.FloatField(effect.DepthMinThreshold, layoutOptions);
        GUILayout.Space(SLIDER_PADDING);
        EditorGUILayout.MinMaxSlider(ref effect.DepthMinThreshold, ref effect.DepthMaxThreshold, 0, 1);
        GUILayout.Space(SLIDER_PADDING);
        effect.DepthMaxThreshold = EditorGUILayout.FloatField(effect.DepthMaxThreshold, layoutOptions);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Normal MinMax Threshold", new GUILayoutOption[] { GUILayout.MaxWidth(EditorGUIUtility.labelWidth) });
        effect.NormalMinThreshold = EditorGUILayout.FloatField(effect.NormalMinThreshold, layoutOptions);
        GUILayout.Space(SLIDER_PADDING);
        EditorGUILayout.MinMaxSlider(ref effect.NormalMinThreshold, ref effect.NormalMaxThreshold, 0, 1);
        GUILayout.Space(SLIDER_PADDING);
        effect.NormalMaxThreshold = EditorGUILayout.FloatField(effect.NormalMaxThreshold, layoutOptions);
        EditorGUILayout.EndHorizontal();
        
        if (EditorGUI.EndChangeCheck())
        {
            EditorUtility.SetDirty(effect);
        }
    }
}
