using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainMenuController : MonoBehaviour
{
    public Slider volume;

    public void Start()
    {
        volume.value = PlayerPrefs.GetFloat("MasterVolume", 0.5f);
    }

    public void UpdateVolume()
    {
        PlayerPrefs.SetFloat("MasterVolume", volume.value);
        PlayerPrefs.Save();
    }

    public void PlayGame()
    {
        UpdateVolume();
        SceneManager.LoadScene(1);
    }

    public void QuitGame()
    {
        Debug.Log("Quitting...");
        Application.Quit();
    }
}
