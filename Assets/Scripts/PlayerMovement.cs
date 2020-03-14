using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    float moveSpeed = 5.0f;

    GameObject playerCamera;

    void Start()
    {
        playerCamera = GameObject.Find("Player Camera");
    }

    void Update()
    {
        Vector3 forward = playerCamera.transform.forward;
        forward.y = 0.0f;
        forward.Normalize();
        transform.position += moveSpeed * Time.deltaTime * (Input.GetAxis("Vertical") * forward + Input.GetAxis("Horizontal") * (Quaternion.AngleAxis(90, Vector3.up) * forward));
    }
}
