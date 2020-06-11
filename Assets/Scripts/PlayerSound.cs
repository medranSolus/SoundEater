using UnityEngine;

public class PlayerSound : MonoBehaviour
{
    [SerializeField]
    private AudioSource attackSource = null;

    public void PlayAttack()
    {
        attackSource.Play();
    }
}