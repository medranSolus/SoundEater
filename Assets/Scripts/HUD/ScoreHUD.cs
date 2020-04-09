using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class ScoreHUD : MonoBehaviour
{
    public GameManager gameManager;
    public Text scoreText;
    // Start is called before the first frame update
    void Start()
    {
        scoreText.text = "Score: " + gameManager.GetScore().ToString();
    }

    // Update is called once per frame
    void Update()
    {
        scoreText.text = "Score: " + gameManager.GetScore().ToString();
    }
}
