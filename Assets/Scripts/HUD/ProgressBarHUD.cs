using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;



public class ProgressBarHUD : MonoBehaviour
{
#if UNITY_EDITOR
    [MenuItem("GameObject/UI/Linear Progress Bar")]
    public static void AddLinearProgressBar()
    {
        GameObject obj = Instantiate(Resources.Load<GameObject>("UI/Linear Progress Bar"));
        obj.transform.SetParent(Selection.activeGameObject.transform, false);
    }
#endif
    public int minimum;
    private int maximum;
    public int current;
    public Image mask;
    public GameManager gameManager;
    private const int multiplier = 100; // used to multiply dashInterval and timeSinceDash to make it smoother
    
    // Start is called before the first frame update
    void Start()
    {
        maximum = (int)(gameManager.GetDashInterval()*multiplier);
    }

    // Update is called once per frame
    void Update()
    {
        if(maximum == 0)
        {
            maximum = (int)(gameManager.GetDashInterval() * multiplier);
        }
        
        current = (int)(gameManager.GetTimeSinceDash()*multiplier);
        GetCurrentFill();
    }

    void GetCurrentFill()
    {
        float currentOffset = current - minimum;
        float maximumOffset = maximum - minimum;
        float fillAmount = (float)currentOffset / maximumOffset;
        mask.fillAmount = fillAmount;
    }
}
