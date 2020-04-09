using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class DashHUD : MonoBehaviour
{
    public GameManager gameManager;
    public Text dashText;
    // Start is called before the first frame update
    void Start()
    {
        dashText.text = "Dash: " + gameManager.GetIsDashPossible().ToString();
    }

    // Update is called once per frame
    void Update()
    {
        dashText.text = "Dash: " + (gameManager.GetIsDashPossible() ? "ready" : "not ready");
    }
}
