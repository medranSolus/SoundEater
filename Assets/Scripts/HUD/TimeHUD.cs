using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TimeHUD : MonoBehaviour
{
    public GameManager gameManager;
    public Text timeText;
    // Start is called before the first frame update
    void Start()
    {
        timeText.text = gameManager.getTimeLeft().ToString();
    }

    // Update is called once per frame
    void Update()
    {
        timeText.text = gameManager.getTimeLeft().ToString();
    }
}
