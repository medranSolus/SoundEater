﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class EnemiesCountHUD: MonoBehaviour
{
    public GameManager gameManager;
    public Text scoreText;
    // Start is called before the first frame update
    void Start()
    {
        scoreText.text = "Enemies left: " + gameManager.getEnemiesCount().ToString();
    }

    // Update is called once per frame
    void Update()
    {
        scoreText.text = "Enemies left: " + gameManager.getEnemiesCount().ToString();
    }
}
