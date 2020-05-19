using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SurfaceZone : MonoBehaviour
{
    [SerializeField]
    private SurfaceType surfaceType;

    private void OnTriggerEnter(Collider other)
    {
        StepSoundChanger soundChanger = other.gameObject.GetComponent<StepSoundChanger>();
        if(soundChanger) soundChanger.SetSurfaceType(surfaceType);
    }
}
