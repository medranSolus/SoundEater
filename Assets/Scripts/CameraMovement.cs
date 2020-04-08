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
    [SerializeField]
    KeyCode menuCode = KeyCode.Tab;
    bool isGame = true;

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void Update()
    {
        if (Input.GetKeyDown(menuCode))
        {
            if (isGame)
            {
                Cursor.lockState = CursorLockMode.None;
                Cursor.visible = true;
                Time.timeScale = 0.0f;
                isGame = false;
            }
            else
            {
                Cursor.lockState = CursorLockMode.Locked;
                Cursor.visible = false;
                Time.timeScale = 1.0f;
                isGame = true;
            }
        }
        if (isGame)
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
}
