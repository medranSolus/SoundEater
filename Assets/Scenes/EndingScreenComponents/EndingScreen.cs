using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class EndingScreen : MonoBehaviour
{
    public Text YourScore;

    private void Start()
    {
        int score = PlayerPrefs.GetInt("LastScore");
        YourScore.text = "Your score: " + score;
    }

    public void PlayAgain()
    {
        Debug.Log("Changing scene to id = 2");
        SceneManager.LoadScene(1);
    }

    public void MainMenu()
    {
        SceneManager.LoadScene(0);
    }

    public void QuitGame()
    {
        Debug.Log("Quitting...");
        Application.Quit();
    }
}
