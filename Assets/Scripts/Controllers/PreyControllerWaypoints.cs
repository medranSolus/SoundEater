using UnityEngine;
using UnityEngine.AI;

public class PreyControllerWaypoints : MonoBehaviour
{
    private NavMeshAgent _agent;
    private GameObject Player;
    bool runningAway; // if 0 - go to the waypoint, 1 - run from the player
    public float EnemyDistanceRun = 4.0f; // distance describing when to run from the player
    [SerializeField]
    AudioSource monsterFootstepSource;

    Vector3 lastPosition;

    public Transform[] waypoints;
    private int destPoint = 0;

    private void Start()
    {
        _agent = GetComponent<NavMeshAgent>();
        lastPosition = transform.position;
        _agent.autoBraking = false;
        runningAway = false;
        // search player object by tag
        if (Player == null)
            Player = GameObject.FindGameObjectWithTag("Player");
        GotoNextPoint();

    }

    private void Update()
    {
        float distance = Vector3.Distance(transform.position, Player.transform.position);
        // check if the player is too close
        if (distance < EnemyDistanceRun)
        {
            runningAway = true;
            Debug.Log("Player too close");
        }
        else
        {
            runningAway = false;
        }

        if (!_agent.pathPending && _agent.remainingDistance < 0.5f && runningAway == false)
        {
            GotoNextPoint();
            Debug.Log("Going to the next point");
        }
        else if(runningAway == true)
        {
            Debug.Log("Running away");
            Vector3 dirToPlayer = transform.position - Player.transform.position;
            Vector3 newPos = transform.position + dirToPlayer;
            _agent.SetDestination(newPos);

        }

        // footsteps
        if (monsterFootstepSource && (transform.position - lastPosition).magnitude > 3)
        {
            monsterFootstepSource.Play();
            lastPosition = transform.position;
        }
    }

    void GotoNextPoint()
    {
        // Returns if no points have been set up
        if (waypoints.Length == 0)
        {
            //Debug.Log("No points ");
        }
        // Set the agent to go to the currently selected destination.
        _agent.destination = waypoints[destPoint].position;
        Debug.Log("Going to " + waypoints[destPoint].name);

        // Choose the next point in the array as the destination,
        // cycling to the start if necessary.
        destPoint = (destPoint + 1) % waypoints.Length;
    }

}
