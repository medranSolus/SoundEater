using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Audio;

public class PreyControllerWaypoints : MonoBehaviour
{
    // animations
    Animator _animator;
    const float locAnSmoothTime = .1f;

    private NavMeshAgent _agent;
    private GameObject Player;
    private GameObject[] waypoints; // array of waypoints
    private int destPoint = 0;
    private bool runningAway; // if 0 - go to the waypoint, 1 - run from the player
    public GameManager gameManager;
    
    public float EnemyDistanceRun = 4.0f; // distance describing when to run from the player
    [SerializeField]
    AudioSource monsterFootstepSource = null;
    private StepSoundChanger soundChanger = null;
    private AudioLowPassFilter audioLowPassFilter;
    Vector3 lastPosition;
    private void Start()
    {
        audioLowPassFilter = monsterFootstepSource.GetComponent(typeof(AudioLowPassFilter)) as AudioLowPassFilter;
        audioLowPassFilter.cutoffFrequency = 2000;
        audioLowPassFilter.enabled = false;
        soundChanger = GetComponent<StepSoundChanger>();

        _agent = GetComponent<NavMeshAgent>();
        _agent.autoBraking = false;
        runningAway = false; // default state - the mob is not running away
        lastPosition = transform.position;

        // animations
        _animator = GetComponentInChildren<Animator>();

        // search player object by tag
        if (Player == null)
            Player = GameObject.FindGameObjectWithTag("Player");

        // search waypoints by tag
        waypoints = GameObject.FindGameObjectsWithTag("Waypoint");
        Debug.Log("Loaded waypoints:");
        foreach (var waypoint in waypoints)
        {
            Debug.Log(waypoint.name);
        }
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
        }
        else
        {
            runningAway = false;
        }

        if (!_agent.pathPending && _agent.remainingDistance < 0.5f && runningAway == false)
        {
            GotoNextPoint();
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

            float verticalDistance = System.Math.Abs(Player.transform.position.y - transform.position.y);
            // if the agent is above the Player, muffle it
            if (verticalDistance >= 2)
                audioLowPassFilter.enabled = true;
            else
                audioLowPassFilter.enabled = false;

            //monsterFootstepSource.Play();
            soundChanger.PlayFootstep();
            lastPosition = transform.position;
        }
    }

    // On collision the object this script is attached to
    // is removed from the gameManager's list and destroyed
    private void OnCollisionEnter(Collision collision)
    {
        if(collision.collider.gameObject.CompareTag("Player"))
        {
            Debug.Log("Collided with Player");
            gameManager.DeletePreyFromList(gameObject);
            Destroy(gameObject);
            
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
        _agent.destination = waypoints[destPoint].transform.position;
        Debug.Log("Going to " + waypoints[destPoint].name);

        // Get a new destination randomized
        destPoint = Random.Range(0, waypoints.Length);
        //destPoint = (destPoint + 1) % waypoints.Length;
    }

}
