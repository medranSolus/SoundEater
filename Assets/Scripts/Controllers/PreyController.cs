using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class PreyController : MonoBehaviour
{
    private NavMeshAgent _agent;
    public GameObject Player;
    public float EnemyDistanceRun = 4.0f;

    private void Start()
    {
        _agent = GetComponent<NavMeshAgent>();

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
    }
    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, EnemyDistanceRun);
    }
}
