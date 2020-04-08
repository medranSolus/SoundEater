using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    float moveSpeed = 5.0f;
    [SerializeField]
    AudioSource monsterFootstepSource;
    [Range(1.0f, 10.0f)]
    [SerializeField]
    float fallSpeed = 5.5f;
    [Range(1.0f, 10.0f)]
    [SerializeField]
    float lowJumpFallSpeed = 3.0f;
    [SerializeField]
    float jumpSpeed = 5.0f;
    [SerializeField]
    float strafeScale = Mathf.Sqrt(3.0f);

    GameObject playerCamera;
    Rigidbody playerBody;
    Vector3 lastPosition;
    
    void Start()
    {
        playerCamera = GameObject.Find("Player Camera");
        playerBody = GetComponent<Rigidbody>();
        lastPosition = transform.position;
    }

    void Update()
    {
        if (Physics.Raycast(transform.position, Vector3.down, 1.5f))
        {
            Vector3 forward = playerCamera.transform.forward;
            forward.y = 0.0f;
            forward.Normalize();
            float velocityForward = Input.GetAxis("Vertical");
            float velocitySide = Input.GetAxis("Horizontal");
            float velocityScale = Mathf.Abs(velocityForward) + Mathf.Abs(velocitySide);
            if (velocityScale == 0.0f)
                velocityScale = 1.0f;
            else
                velocityScale /= strafeScale;
            playerBody.velocity = moveSpeed * (velocityForward * forward + velocitySide / velocityScale * (Quaternion.AngleAxis(90, Vector3.up) * forward));

            if (Input.GetAxis("Jump") > 0.0f)
                playerBody.velocity += Vector3.up * jumpSpeed;

            if (monsterFootstepSource && (transform.position - lastPosition).magnitude > 3)
            {
                monsterFootstepSource.Play();
                lastPosition = transform.position;
            }
        }
        if (playerBody.velocity.y < 0.0f)
            playerBody.velocity += Vector3.up * Physics.gravity.y * (fallSpeed - 1.0f) * Time.deltaTime;
        else if (playerBody.velocity.y > 0.0f && Input.GetAxis("Jump") <= 0.0f)
            playerBody.velocity += Vector3.up * Physics.gravity.y * (lowJumpFallSpeed - 1.0f) * Time.deltaTime;
    }
}
