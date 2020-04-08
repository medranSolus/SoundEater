using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TimeHUD : MonoBehaviour
{
    public GameManager gameManager;
    public Text timeText;
    private int time;
    private int minutes, seconds;
    // Start is called before the first frame update
    void Start()
    {
        SetText();
    }

    // Update is called once per frame
    void Update()
    {
        SetText();
    }
    
    // Split time into minutes and seconds
    void SetText()
    {
        time = gameManager.getTimeLeft();
        minutes = (time / 60);
        seconds = time - minutes * 60;
        timeText.text = minutes.ToString() + ":" + (seconds < 10 ? ("0" + seconds.ToString()) : seconds.ToString());
    }
}
