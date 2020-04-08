using System.Collections;
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

    public List<GameObject> SpawnPositions;

    // Private variables to watch over game progress
    private GameObject spawnedPlayer;
    private List<GameObject> spawnedPrey = new List<GameObject>();
    private List<GameObject> leftSpawnPoints = new List<GameObject>();
    private float roundTime = 0;
    private int currentScore = 0;
    private bool gameEnded = false;

    // Start is called before the first frame update
    void Start()
    {
        RestartGame();
    }

    // Update is called once per frame
    void Update()
    {
        if (!gameEnded)
        {
            roundTime += Time.deltaTime;

            if (roundTime >= RoundTimeInSeconds)
            {
                Debug.Log("End of the round! We lost.");
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

        SpawnPlayer();
        SpawnPrey();
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
            leftSpawnPoints.RemoveAt(randomIndex);
        }
    }

    // Go through a procedure of stopping the game
    public void EndGame()
    {
        gameEnded = true;
        Debug.Log("- - GAME OVER - -");
        Destroy(spawnedPlayer);
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
