﻿using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

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
    public GameObject UserInterface;
    public List<GameObject> SpawnPositions;

    [SerializeField]
    KeyCode pauseMenuKey = KeyCode.Tab;

    // Private variables to watch over game progress
    private GameObject spawnedPlayer;
    private List<GameObject> spawnedPrey = new List<GameObject>();

    private List<GameObject> leftSpawnPoints = new List<GameObject>();
    private float roundTime = 0;
    private int currentScore = 0;
    private bool isGame = false;
    private bool gameEnded = false;
    private GameObject PauseMenu;
    private GameObject HUD;

    // Start is called before the first frame update
    void Start()
    {
        RestartGame();
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
        if (!gameEnded)
        {
            roundTime += Time.deltaTime;

            if (roundTime >= RoundTimeInSeconds)
            {
                Debug.Log("End of the round! We lost Mr. Stark...");
                EndGame();
            }
        }
    }

    // Go through a procedure of restaring the game
    public void RestartGame()
    {
        if (!VailidateSpawnPoints())
            return;

        leftSpawnPoints = new List<GameObject>(SpawnPositions);
        roundTime = 0;
        currentScore = 0;
        gameEnded = false;
        isGame = true;

        SpawnPlayer();
        SpawnPrey();

        // TODO: When main menu is finished remove it from here
        StartGame();
    }

    // Validate amount of spawn points
    bool VailidateSpawnPoints()
    {
        if (SpawnPositions.Count < AmountOfPrey + 1 && SpawnPositions.Count > 1)
        {
            Debug.LogWarning("Not enough spawn points for every prey. Spawning less...");
            AmountOfPrey = SpawnPositions.Count - 1;
        }

        if (SpawnPositions.Count == 1)
        {
            Debug.LogWarning("No spawn points left for prey. Spawning just a player...");
            AmountOfPrey = 0;
        }

        if (SpawnPositions.Count == 0)
        {
            Debug.LogError("No spawn points!");
            return false;
        }

        return true;
    }

    // Spawn player
    void SpawnPlayer()
    {
        int randomIndex = Random.Range(0, leftSpawnPoints.Count);
        spawnedPlayer = Instantiate(PlayerPrefab, leftSpawnPoints[randomIndex].transform);
        leftSpawnPoints.RemoveAt(randomIndex);
    }

    // Spawn prey
    void SpawnPrey()
    {
        for (int i = 0; i < AmountOfPrey; i++)
        {
            int randomIndex = Random.Range(0, leftSpawnPoints.Count);
            GameObject Prey = Instantiate(PreyPrefab, leftSpawnPoints[randomIndex].transform);
            spawnedPrey.Add(Prey);
            Prey.GetComponent<PreyControllerWaypoints>().gameManager = this; // passing reference to this gameManager to the spawned prey
            leftSpawnPoints.RemoveAt(randomIndex);
        }
    }

    // Start game when players clicks on corresponding button in main menu
    public void StartGame()
    {
        // Search for HUD and PauseMenu in UserInterface
        for(int i = 0; i< UserInterface.transform.childCount; i++)
        {
            if(UserInterface.transform.GetChild(i).gameObject.name == "HUD")
                HUD = UserInterface.transform.GetChild(i).gameObject;
            if (UserInterface.transform.GetChild(i).gameObject.name == "PauseMenu")
                PauseMenu = UserInterface.transform.GetChild(i).gameObject;
        }
        // Disable PauseMenu and enable HUD
        PauseMenu.SetActive(false);
        HUD.SetActive(true);
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        isGame = true;
        spawnedPlayer.GetComponentInChildren<CameraMovement>().isGame = true;
        Time.timeScale = 1.0f;
    }

    public void PauseGame()
    {
        // Disable HUD and enable PauseMenu
        HUD.SetActive(false);
        PauseMenu.SetActive(true);
        isGame = false;
        spawnedPlayer.GetComponentInChildren<CameraMovement>().isGame = false;
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        Time.timeScale = 0.0f;
    }

    // Go through a procedure of stopping the game
    public void EndGame()
    {
        gameEnded = true;
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        Debug.Log("- - GAME OVER - -");
        Destroy(spawnedPlayer);

        SceneManager.LoadScene(3);
    }

    public void QuitGame()
    {
        Application.Quit();
    }

    // Function is called by destroyed prey to remove it from the list
    // Also checks if that was the last enemy
    public void DeletePreyFromList(GameObject prey)
    {
        // Calculate score on collision
        currentScore += (int)(RoundTimeInSeconds - roundTime);
        spawnedPrey.Remove(prey);
        if (spawnedPrey.Count == 0)
        {
            Debug.Log("All enemies are dead! We win.");
            EndGame();
        }
    }

    public int GetScore()
    {
        return currentScore;
    }

    public int GetTimeLeft()
    {
        return (int)(RoundTimeInSeconds - roundTime);
    }

    public int GetEnemiesCount()
    {
        return spawnedPrey.Count;
    }

    public bool GetIsDashPossible()
    {
        if(isGame == false)
        {
            return true;
        }
        return spawnedPlayer.GetComponentInChildren<PlayerMovement>().isDashPossible;
    }
}
