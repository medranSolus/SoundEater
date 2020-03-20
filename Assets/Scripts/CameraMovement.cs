using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    [SerializeField]
    float sensitivity = 5.0f;
    [SerializeField]
    [Range(5.0f, 85.0f)]
    float maxLookDown = 80.0f;
    [SerializeField]
    [Range(275.0f, 355.0f)]
    float minLookUp = 280.0f;

    void Update()
    {
        transform.Rotate(new Vector3(
            -Input.GetAxis("Mouse Y") * sensitivity,
            Input.GetAxis("Mouse X") * sensitivity,
            0.0f));
        transform.rotation = Quaternion.Euler(
            transform.rotation.eulerAngles.x <= 90.0f ?
                Mathf.Clamp(transform.rotation.eulerAngles.x, 0.0f, maxLookDown) :
                Mathf.Clamp(transform.rotation.eulerAngles.x, minLookUp, 360.0f),
            transform.rotation.eulerAngles.y,
            0.0f);
    }
}
