using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    float moveSpeed = 5.0f;
    [SerializeField]
    AudioSource monsterFootstepSource;

    GameObject playerCamera;

    Vector3 lastPosition;
    
    void Start()
    {
        playerCamera = GameObject.Find("Player Camera");
        lastPosition = transform.position;
    }

    void Update()
    {
        Vector3 forward = playerCamera.transform.forward;
        forward.y = 0.0f;
        forward.Normalize();
        transform.position += moveSpeed * Time.deltaTime * (Input.GetAxis("Vertical") * forward + Input.GetAxis("Horizontal") * (Quaternion.AngleAxis(90, Vector3.up) * forward));

        if(monsterFootstepSource && (transform.position - lastPosition).magnitude > 3)
        {
            monsterFootstepSource.Play();
            lastPosition = transform.position;
        }
    }
}
