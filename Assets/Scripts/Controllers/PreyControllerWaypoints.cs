using UnityEngine;
using UnityEngine.AI;

public class PreyControllerWaypoints : MonoBehaviour
{
    private NavMeshAgent _agent;

    [SerializeField]
    AudioSource monsterFootstepSource;

    Vector3 lastPosition;

    public Transform[] points;
    private int destPoint = 0;

    private void Start()
    {
        _agent = GetComponent<NavMeshAgent>();
        lastPosition = transform.position;
        _agent.autoBraking = false;
        GotoNextPoint();

    }

    private void Update()
    {
        if (!_agent.pathPending && _agent.remainingDistance < 0.5f)
        {
            GotoNextPoint();
            //Debug.Log("Going to the next point");
        }

        if (monsterFootstepSource && (transform.position - lastPosition).magnitude > 3)
        {
            monsterFootstepSource.Play();
            lastPosition = transform.position;
        }
    }

    void GotoNextPoint()
    {
        // Returns if no points have been set up
        if (points.Length == 0)
        {
            //Debug.Log("No points ");
        }
        // Set the agent to go to the currently selected destination.
        _agent.destination = points[destPoint].position;
        //Debug.Log("Going to " + points[destPoint].name);

        // Choose the next point in the array as the destination,
        // cycling to the start if necessary.
        destPoint = (destPoint + 1) % points.Length;
    }

}
