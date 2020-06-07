using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioListener))]
public class VolumeController : MonoBehaviour
{
    void Update()
    {
        AudioListener.volume = PlayerPrefs.GetFloat("MasterVolume", 0.5f);
    }
}
