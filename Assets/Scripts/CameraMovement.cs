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

    GameObject playerAvatar;

    void Start()
    {
        playerAvatar = GameObject.Find("Player Avatar");
    }

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

    void LateUpdate()
    {
        transform.position = Vector3.MoveTowards(transform.position,
            playerAvatar.transform.position + Vector3.up,
            100.0f * Time.deltaTime);
    }
}
