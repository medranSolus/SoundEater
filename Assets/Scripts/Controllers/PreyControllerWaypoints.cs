using UnityEngine;
using UnityEngine.AI;

public class PreyControllerWaypoints : MonoBehaviour
{
    // animations
    private Animator _animator;

    private const float locAnSmoothTime = .1f;

    private NavMeshAgent _agent;
    private GameObject Player;
    private GameObject[] waypoints; // array of waypoints
    private int destPoint = 0;
    private bool runningAway; // if 0 - go to the waypoint, 1 - run from the player
    public GameManager gameManager;

    public float EnemyDistanceRun = 5.0f;

    private StepSoundChanger soundChanger = null;
    private Vector3 lastPosition;

    private void Start()
    {
        soundChanger = GetComponent<StepSoundChanger>();

        _agent = GetComponent<NavMeshAgent>();
        _agent.autoBraking = false;
        runningAway = false; // default state - the mob is not running away
        lastPosition = transform.position;

        // animations
        _animator = GetComponentInChildren<Animator>();

        // search player object by tag
        Player = GameObject.FindGameObjectWithTag("Player");

        // search waypoints by tag
        waypoints = GameObject.FindGameObjectsWithTag("Waypoint");
        Debug.Log("Loaded waypoints:");
        foreach (var waypoint in waypoints)
            Debug.Log(waypoint.name);
        GotoNextPoint();
    }

    private void Update()
    {
        // animations
        float speedPercent = _agent.velocity.magnitude / _agent.speed;
        _animator.SetFloat("speedPercent", speedPercent, locAnSmoothTime, Time.deltaTime);

        float distance = Vector3.Distance(transform.position, Player.transform.position);
        // check if the player is too close
        if (distance < EnemyDistanceRun)
        {
            runningAway = true;
            Debug.Log("Player too close");
            Debug.Log("Running away");
            Vector3 dirToPlayer = transform.position - Player.transform.position;
            Vector3 newPos = transform.position + 5*dirToPlayer;
            _agent.SetDestination(newPos);
        }

        if (!_agent.pathPending && _agent.remainingDistance < 0.5f && runningAway == false)
            GotoNextPoint();
        if (runningAway == true)
        {
            _agent.speed = 6;
            if (!_agent.hasPath)
                runningAway = false;
            // footsteps
            if ((transform.position - lastPosition).magnitude > 1)
            {
                soundChanger.PlayFootstep();
                lastPosition = transform.position;
            }

        }
        if(runningAway == false)
        {
            _agent.speed = 2;
            // footsteps
            if ((transform.position - lastPosition).magnitude > 2)
            {
                soundChanger.PlayFootstep();
                lastPosition = transform.position;
            }
        }

        
    }

    // On collision the object this script is attached to
    // is removed from the gameManager's list and destroyed
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.gameObject.CompareTag("Player"))
        {
            Debug.Log("Collided with Player");
            Player.GetComponent<PlayerSound>().PlayAttack();
            gameManager.DeletePreyFromList(gameObject);
            Destroy(gameObject);
        }
    }

    private void GotoNextPoint()
    {
        // Returns if no points have been set up
        if (waypoints.Length == 0)
        {
            Debug.Log("No points");
            return;
        }
        // Set the agent to go to the currently selected destination.
        _agent.destination = waypoints[destPoint].transform.position;
        Debug.Log("Going to " + waypoints[destPoint].name);

        // Get a new destination randomized
        destPoint = Random.Range(0, waypoints.Length);
    }
}