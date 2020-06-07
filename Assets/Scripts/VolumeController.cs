using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioListener))]
public class VolumeController : MonoBehaviour
{
    float lastVolume = -1;

    void Update()
    {
        float vol = PlayerPrefs.GetFloat("MasterVolume", 0.5f);

        if (vol != lastVolume)
        {
            AudioListener.volume = vol;
            lastVolume = vol;
        }
    }
}
