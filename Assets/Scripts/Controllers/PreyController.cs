using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class PreyController : MonoBehaviour
{
    private NavMeshAgent _agent;
    public GameObject Player;
    public float EnemyDistanceRun = 4.0f;
    [SerializeField]
    AudioSource monsterFootstepSource;
    Vector3 lastPosition;

    private void Start()
    {
        _agent = GetComponent<NavMeshAgent>();
        lastPosition = transform.position;

    }

    private void Update()
    {
        float distance = Vector3.Distance(transform.position, Player.transform.position);
        Debug.Log("Distance: " + distance);


        if(distance < EnemyDistanceRun)
        {
            Vector3 dirToPlayer = transform.position - Player.transform.position;
            Vector3 newPos = transform.position + dirToPlayer;
            _agent.SetDestination(newPos);
        }
        if (monsterFootstepSource && (transform.position - lastPosition).magnitude > 3)
        {
            monsterFootstepSource.Play();
            lastPosition = transform.position;
        }
    }
    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, EnemyDistanceRun);
    }
}
