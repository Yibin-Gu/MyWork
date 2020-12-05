using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boid : MonoBehaviour
{
    //静态的list用于存放所有Boid实例, 因此只需要一个
    static public List<Boid> boids;

    #region 需要用到的变量
    //此对象并没有添加刚体, 速度由自定义脚本处理
    public Vector3 velocity; //速度是有方向性的 所有使用Vector
    public Vector3 newVelocity; //下一帧中的速度
    public Vector3 newPosition; //下一帧中的位置

    public List<Boid> neighbors; //使用list储存附近所有的Boid
    public List<Boid> collisionRisks; //使用另一个list储存附近距离太近的Boid
    public Boid closest;              //最近的一只Boid
    #endregion

    //在Awake()中初始化Boid
    private void Awake()
    {
        //如果 boids没有被定义, 则定义一次boids
        if (boids == null)
            boids = new List<Boid>();


        //向boids list中添加自身产生的boid对象
        boids.Add(this);

        //为自身这个对象提供一个随机的位置
        Vector3 randPos = Random.insideUnitSphere * BoidSpawner.S.spawnRadius;
        randPos.y = 0; //让所有生成的Boid只在2d平面上移动, 忽略y轴
        this.transform.position = randPos;
        //提供一个随机速度
        velocity = Random.onUnitSphere;
        velocity *= BoidSpawner.S.spawnVelocity;

        //初始化两个list, 使其仅在这个对象中调用
        neighbors = new List<Boid>();
        collisionRisks = new List<Boid>();

        //让此对象的transform成为Boids(Boid的集合)的子对象
        this.transform.parent = GameObject.Find("Boids").transform;

        //给此Boid一个随机颜色, 为了颜色不要过暗让他们的rgb总值加起来不大于1
        Color randColor = Color.black;
        while(randColor.r + randColor.g + randColor.b < 1.0f)
        {
            randColor = new Color(Random.value, Random.value, Random.value);
        }
        //一个Boid对象含有不同的结构, 这里统一上色成一样的颜色
        Renderer[] rends = gameObject.GetComponentsInChildren<Renderer>();
        foreach(Renderer r in rends)
        {
            r.material.color = randColor;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // 在Update()中确认新的速度和位置, 但是还没发生移动, 等待其他Boid全部确认完后在LateUpdate()中统一移动
    void Update()
    {
        //获取附近所有的Boids
        List<Boid> neighbors = GetNeighbors(this);

        //使用当前位置和速度来初始化位置和速度
        newVelocity = velocity;
        newPosition = this.transform.position;

        //使当前Boid的速度与周围Boid的速度匹配
        Vector3 neighBorVel = GetAverageVelocity(neighbors);
        //使用BoidSpawner.S中的参数
        newVelocity += neighBorVel * BoidSpawner.S.velocityMatchingAmt;

        //凝聚向心性: 向领巾的Boid对象的中心移动
        Vector3 neighborCenterOffset = GetAveragePosition(neighbors) - this.transform.position;
        newVelocity += neighborCenterOffset * BoidSpawner.S.flockCenteringAmt;

        //排斥性: Boid会避免撞上其他的Boids
        Vector3 dist;
        if (collisionRisks.Count > 0)//如果有即将相撞的Boid,则
        {
            Vector3 collisionAveragePos = GetAveragePosition(collisionRisks);
            dist = collisionAveragePos - this.transform.position;
            newVelocity += dist * BoidSpawner.S.collisionAvoidanceAmt;
        }

        //跟随鼠标的指针移动: 无论多远都会尝试向着鼠标指针移动
        dist = BoidSpawner.S.mousePos - this.transform.position;
        if (dist.magnitude > BoidSpawner.S.mouseAvoidanceDist)
        {
            newVelocity += dist * BoidSpawner.S.mouseAttractionAmt;
        }
        else //如果鼠标光标过近, 则远离鼠标光标
        {
            newVelocity -= dist.normalized * BoidSpawner.S.mouseAvoidanceDist * BoidSpawner.S.mouseAvoidanceAmt;
        }

        
    }

    // 在所有Boid获取了新速度和位置后移动以避免竞态条件的发生
    void LateUpdate()
    {
        //线性插值法来随机化一下基于(新速度和当前速度)算出的当前速度
        velocity = (1 - BoidSpawner.S.velocityLerpAmt) * velocity + BoidSpawner.S.velocityLerpAmt * newVelocity;

        //确保速度值合适
        if (velocity.magnitude > BoidSpawner.S.maxVelocity)
            velocity = velocity.normalized * BoidSpawner.S.maxVelocity; //超出上限则保持上限速度
        if (velocity.magnitude < BoidSpawner.S.minVelocity)
            velocity = velocity.normalized * BoidSpawner.S.minVelocity;


        //基于新的速度算出位置
        newPosition = this.transform.position + velocity * Time.deltaTime;
        newPosition.y = 0;
        //确认新的朝向
        this.transform.LookAt(newPosition);
        //移动到新位置
        this.transform.position = newPosition;

    }

    //差早那些Boid距离当前的Boid足够近以当做附近对象加入列表
    public List<Boid> GetNeighbors(Boid boi)
    {
        float closestDist = float.MaxValue; //最大float的值
        Vector3 delta;
        float dist;
        neighbors.Clear();
        collisionRisks.Clear();

        foreach(Boid b in boids)
        {
            if (b == boi) continue; //找到自己跳过进入下一轮循环

            delta = b.transform.position - boi.transform.position;//寻找目标Boid和自身的坐标差
            dist = delta.magnitude; //通过坐标差获得距离

            //找到最近的那一只
            if(dist < closestDist)
            {
                closestDist = dist;
                closest = b;
            }

            //如果距离小于预设的[邻居值], 则加入邻居列表
            if(dist<BoidSpawner.S.nearDist)
            {
                neighbors.Add(b);
            }

            //如果距离小于预设的[碰撞值], 则加入碰撞列表
            if(dist < BoidSpawner.S.collisionDist)
            {
                collisionRisks.Add(b);
            }

        }

        //如果没有相邻的Boid, 则将最近的那一只视为相邻的
        if (neighbors.Count == 0) neighbors.Add(closest);

        return neighbors;
    }


    //获取一个所有Boid的平均位置
    public Vector3 GetAveragePosition(List<Boid> someBoids)
    {
        //初始化坐标加值为0
        Vector3 sum = Vector3.zero;

        foreach (Boid b in someBoids)
        {
            sum += b.transform.position;
        }

        Vector3 center = sum / someBoids.Count;
        return center;
    }

    //获取一个所有Boid的平均速度
    public Vector3 GetAverageVelocity(List<Boid> someBoids)
    {
        Vector3 sum = Vector3.zero;

        foreach (Boid b in someBoids)
        {
            sum += b.velocity;
        }

        Vector3 avg = sum / someBoids.Count;
        return avg;
    }

}
