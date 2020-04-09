using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    float moveSpeed = 5.0f;
    [SerializeField]
    AudioSource monsterFootstepSource = null;
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
    [SerializeField]
    float dashInterval = 5.0f;
    [SerializeField]
    float dashTime = 0.7f;
    [SerializeField]
    float dashVelocity = 13.0f;
    [SerializeField]
    KeyCode dashKey = KeyCode.LeftShift;

    GameObject playerCamera;
    Rigidbody playerBody;
    Vector3 lastPosition;
    bool dashEnable = false;
    bool isDashPossible = true;
    float timeSinceDash = 0.0f;
    
    void Start()
    {
        playerCamera = GameObject.Find("Player Camera");
        playerBody = GetComponent<Rigidbody>();
        lastPosition = transform.position;
    }

    void Update()
    {
        if (!isDashPossible)
        {
            timeSinceDash += Time.deltaTime;
            if (timeSinceDash >= dashInterval)
            {
                timeSinceDash = 0.0f;
                isDashPossible = true;
            }
        }
        if (Physics.Raycast(transform.position, Vector3.down, 1.5f))
        {
            Vector3 forward = playerCamera.transform.forward;
            forward.y = 0.0f;
            forward.Normalize();
            if (dashEnable)
            {
                timeSinceDash += Time.deltaTime;
                if (timeSinceDash >= dashTime)
                {
                    timeSinceDash = 0.0f;
                    dashEnable = false;
                    isDashPossible = false;
                    Move(ref forward);
                }
            }
            else if (isDashPossible && Input.GetKeyDown(dashKey))
            {
                playerBody.velocity += dashVelocity * forward;
                dashEnable = true;
            }
            else
                Move(ref forward);

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

    void Move(ref Vector3 forward)
    {
        float velocityForward = Input.GetAxis("Vertical");
        float velocitySide = Input.GetAxis("Horizontal") * 0.9999998f;
        if ((Mathf.Abs(velocityForward) + Mathf.Abs(velocitySide)) != 0.0f)
            velocitySide /= strafeScale;
        playerBody.velocity = moveSpeed * (velocityForward * forward + velocitySide * (Quaternion.AngleAxis(90, Vector3.up) * forward));
    }
}