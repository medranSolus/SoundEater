using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum SurfaceType
{
    Metal,
    Wood,
    Concrete
}

public class StepSoundChanger : MonoBehaviour
{
    [SerializeField]
    private AudioSource audioSource;

    [Header("Sound samples")]
    [SerializeField]
    private AudioClip defaultFootstepSound;
    [SerializeField]
    private List<AudioClip> metalFootsteps;
    [SerializeField]
    private List<AudioClip> woodFootsteps;
    [SerializeField]
    private List<AudioClip> concreteFootsteps;

    [Header("Current settings")]
    [SerializeField]
    private SurfaceType surfaceType = SurfaceType.Metal;

    void Start()
    {
        if(audioSource == null)
            audioSource = GetComponent<AudioSource>();
    }

    public void SetSurfaceType(SurfaceType surface)
    {
        surfaceType = surface;
    }

    public void PlayFootstep()
    {
        switch (surfaceType)
        {
            case SurfaceType.Metal:
                audioSource.clip = metalFootsteps.Count > 0 ? metalFootsteps[Random.Range(0, metalFootsteps.Count)] : defaultFootstepSound;
                break;
            case SurfaceType.Wood:
                audioSource.clip = woodFootsteps.Count > 0 ? woodFootsteps[Random.Range(0, woodFootsteps.Count)] : defaultFootstepSound;
                break;
            case SurfaceType.Concrete:
                audioSource.clip = concreteFootsteps.Count > 0 ? concreteFootsteps[Random.Range(0, concreteFootsteps.Count)] : defaultFootstepSound;
                break;
            default:
                audioSource.clip = defaultFootstepSound;
                break;
        }

        audioSource.Play();
    }

    public void PlayFootstep(SurfaceType overrideSurfaceType)
    {
        switch(overrideSurfaceType)
        {
            case SurfaceType.Metal:
                audioSource.clip = metalFootsteps.Count > 0 ? metalFootsteps[Random.Range(0, metalFootsteps.Count)] : defaultFootstepSound;
                break;
            case SurfaceType.Wood:
                audioSource.clip = woodFootsteps.Count > 0 ? woodFootsteps[Random.Range(0, woodFootsteps.Count)] : defaultFootstepSound;
                break;
            case SurfaceType.Concrete:
                audioSource.clip = concreteFootsteps.Count > 0 ? concreteFootsteps[Random.Range(0, concreteFootsteps.Count)] : defaultFootstepSound;
                break;
            default:
                audioSource.clip = defaultFootstepSound;
                break;
        }

        audioSource.Play();
    }
}
