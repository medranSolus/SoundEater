using UnityEngine;

[ExecuteInEditMode]
public class PostProcess : MonoBehaviour
{
    public bool useCustomShader = true;
    public Shader shader;

    public void Start()
    {
        if (shader && useCustomShader)
            GetComponent<Camera>().SetReplacementShader(shader, "");
    }
}