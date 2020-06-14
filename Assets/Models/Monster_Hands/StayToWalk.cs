using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class StayToWalk : MonoBehaviour
{
    public Animator animator;
    public float isWalking;
    // Start is called before the first frame update
    void Start()
    {
        animator = this.gameObject.GetComponent<Animator>();   
    }

    // Update is called once per frame
    void Update()
    {
        isWalking = Math.Abs(Input.GetAxis("Vertical")) + Math.Abs(Input.GetAxis("Horizontal"));
        if (isWalking > 0.6f) isWalking = 0.6f;
        animator.SetFloat("isWalking", isWalking);
    }
}
