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
    private List<GameObject> leftSpawnPoints;
    private float roundTime;

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
            leftSpawnPoints.RemoveAt(randomIndex);
        }

        // Set variables
        roundTime = 0;
    }

    // Update is called once per frame
    void Update()
    {
        roundTime += Time.deltaTime;

        if(roundTime >= RoundTimeInSeconds)
        {
            Debug.Log("End of the round! We loose.");
        }

        // TO-DO
        // Dodac kontrole zjedzonych ofiar
    }
}
