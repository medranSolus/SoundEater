using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    [Header("Characters")]
    public GameObject PlayerPrefab;
    // TO-DO
    // Zmienic z GameObject na klase ofiary (punkty zycia, czy zjedzony itp.)
    public GameObject PreyPrefab;

    [Header("Game Settings")]
    public int AmountOfPrey;
    public float RoundTimeInSeconds;
    public GameObject PauseMenu;
    public List<GameObject> SpawnPositions;

    [SerializeField]
    KeyCode pauseMenuKey = KeyCode.Tab;

    // Private variables to watch over game progress
    private GameObject spawnedPlayer;
    private List<GameObject> spawnedPrey = new List<GameObject>();
    private List<GameObject> leftSpawnPoints;
    private float roundTime;
    private int currentScore;
    private bool isGame = false;

    // Start is called before the first frame update
    void Start()
    {
        if(SpawnPositions.Count < AmountOfPrey + 1 && SpawnPositions.Count > 1)
        {
            Debug.LogWarning("Not enough spawn points for every prey. Spawning less...");
            AmountOfPrey = SpawnPositions.Count - 1;
        }

        if(SpawnPositions.Count == 1)
        {
            Debug.LogWarning("No spawn points left for prey.");
            AmountOfPrey = 0;
        }

        if(SpawnPositions.Count == 0)
        {
            Debug.LogError("No spawn points!");
            return;
        }

        leftSpawnPoints = SpawnPositions;

        // Spawn player
        int randomIndex = Random.Range(0, leftSpawnPoints.Count);
        spawnedPlayer = Instantiate(PlayerPrefab, leftSpawnPoints[randomIndex].transform);
        leftSpawnPoints.RemoveAt(randomIndex);

        // Spawn prey
        for(int i = 0; i < AmountOfPrey; i++)
        {
            randomIndex = Random.Range(0, leftSpawnPoints.Count);
            GameObject Prey = Instantiate(PreyPrefab, leftSpawnPoints[randomIndex].transform);
            spawnedPrey.Add(Prey);
            Prey.GetComponent<PreyControllerWaypoints>().gameManager = this; // passing reference to this gameManager to the spawned prey
            leftSpawnPoints.RemoveAt(randomIndex);
        }

        // TODO: When main menu is finished remove it from here
        StartGame();

        // Set variables
        roundTime = 0;
        currentScore = 0;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(pauseMenuKey))
        {
            if (isGame)
                PauseGame();
            else
                StartGame();
        }
        if (isGame)
        {
            roundTime += Time.deltaTime;

            if (roundTime >= RoundTimeInSeconds)
            {
                Debug.Log("End of the round! We lost Mr. Stark...");
            }
        }
    }

    // Start game when players clicks on corresponding button in main menu
    public void StartGame()
    {
        PauseMenu.SetActive(false);
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        isGame = true;
        spawnedPlayer.GetComponentInChildren<CameraMovement>().isGame = true;
        Time.timeScale = 1.0f;
    }

    public void PauseGame()
    {
        PauseMenu.SetActive(true);
        isGame = false;
        spawnedPlayer.GetComponentInChildren<CameraMovement>().isGame = false;
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        Time.timeScale = 0.0f;
    }

    // Function is called by destroyed prey to remove it from the list
    // Also checks if that was the last enemy
    public void DeletePreyFromList(GameObject prey)
    {
        // Calculate score on collision
        currentScore += (int)(RoundTimeInSeconds - roundTime);
        spawnedPrey.Remove(prey);
        if (spawnedPrey.Count == 0)
            Debug.Log("All enemies are dead! We win Mr. Stark!");

    }

    public int getScore()
    {
        return currentScore;
    }

    public int getTimeLeft()
    {
        return (int)(RoundTimeInSeconds - roundTime);
    }

    public int getEnemiesCount()
    {
        return spawnedPrey.Count;
    }

}
