using System.Collections;
using UnityEngine;

public class BoidSpawner : MonoBehaviour
{

    //只允许存在一个实例, 所以使用static
    static public BoidSpawner S;


    #region 使用前可修改变量
    //变量用于调整全体boid对象的行为
    public int numBoids = 100;
    public GameObject boidPrefab;
    public float spawnRadius = 100f;
    public float spawnVelocity = 10f;
    public float minVelocity = 0f;
    public float maxVelocity = 30f;
    public float nearDist = 30f;
    public float collisionDist = 5f;
    public float velocityMatchingAmt = 0.01f;
    public float flockCenteringAmt = 0.15f;
    public float collisionAvoidanceAmt = -0.5f;
    public float mouseAttractionAmt = 0.01f;
    public float mouseAvoidanceAmt = 0.75f;
    public float mouseAvoidanceDist = 15f;
    public float velocityLerpAmt = 0.25f;
    #endregion

    //用于分割可改量和不可改变量
    public bool ______________________;

    public Vector3 mousePos;

    // Start is called before the first frame update
    void Start()
    {
        S = this;
        for (int i = 0; i < numBoids; i++)
        {
            Instantiate(boidPrefab);
        }
    }

    void LateUpdate()
    {
        //追踪鼠标的位置, 用于所有Boid对象
        Vector3 mousePos2d = new Vector3(Input.mousePosition.x, Input.mousePosition.y, this.transform.position.y);
        mousePos = this.GetComponent<Camera>().ScreenToWorldPoint(mousePos2d);
    }
}
