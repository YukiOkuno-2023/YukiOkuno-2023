using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boids : MonoBehaviour
{
    public Vector3 pos;
    public Vector3 velocity;
    private Vector3 acceleration = Vector3.zero;
    public GameObject wall;
    float dt = 0f;
    GameObject[] items;



    void Start()
    {
        pos = this.transform.position;
        velocity = this.transform.forward * Parameters.instance.initVelocity * Random.Range(0.5f, 1.5f);
    }



    void Update()
    {
        if(dt == 0f)
        {
            items = GameObject.FindGameObjectsWithTag("clone");
        }

        Transform wallTrans = wall.transform;

        Refrect(wallTrans);     // 壁の反射
        Serch();                // 距離が一定以内の個体をリスト化
        Separation();           // 分離：衝突回避
        Alignment();            // 整列：リストから周辺個体の平均速度を求め、周囲に合わせるように加速度を増減させる

        // Alignmentで速度を合わせているが、実際は与えるベクトルを合わせている
        // そのため、分離、整列、結合のうちすでに結合は低いレベルで満たしている
        // 強度の高い結合は必要に応じて用いるのが良い
        Centripetence();           // 結合：中心に向かう

        React(Humanoid.instance.State, Humanoid.instance.trans);     // キャラクターの動きに合わせて魚群を回避させる


        Move();                 // 移動の加算
    }



    float scale_x, scale_y, scale_z;

    void Refrect(Transform wallTrans)
    {
        scale_x = wallTrans.localScale.x / 2f;  // 中央から端までの距離
        scale_y = wallTrans.localScale.y / 2f;
        scale_z = wallTrans.localScale.z / 2f;

        /************        注意        ************/
        // 反射の強さを示すwallRestitutionは低いと反射し切れず、壁を貫通してしまう
        // しかし高いと反発を繰り返すごとに加速し、速度の最大値が高すぎると最終的に反発し切れず壁を貫通する
        // そのためパラメーターの条件は、
        // ① 反発係数は低すぎてはならない
        // ② 反発係数を高く設定するなら最大速度を高く設定しない
        // 上記のパラメーターで上手く壁際で曲がってくれるように調整する
        // 調整出来ない場合はpowerの値を上げることで領域を超えた場合強引に戻るように出来る

        acceleration +=
            CalcRefrect(wallTrans.position.x - scale_x - pos.x, Vector3.right)   + CalcRefrect(wallTrans.position.x + scale_x - pos.x, Vector3.left) +
            CalcRefrect(wallTrans.position.y - scale_y - pos.y, Vector3.up)      + CalcRefrect(wallTrans.position.y + scale_y - pos.y, Vector3.down) +
            CalcRefrect(wallTrans.position.z - scale_z - pos.z, Vector3.forward) + CalcRefrect(wallTrans.position.z + scale_z - pos.z, Vector3.back);
        // 引数はフィールドの位置を補正した上での壁との距離と反発方向


        // 領域外に出た場合について二重に保険をかける
        // x軸方向に領域を超過した場合
        if(pos.x < wallTrans.position.x - scale_x)
        {
            acceleration += Parameters.instance.power * Vector3.right;
        }
        else if(pos.x >= wallTrans.position.x + scale_x)
        {
            acceleration += Parameters.instance.power * Vector3.left;
        }
        // y軸方向に領域を超過した場合
        if (pos.y < wallTrans.position.y - scale_y)
        {
            acceleration += Parameters.instance.power * Vector3.up;
        }
        else if (pos.y >= wallTrans.position.y + scale_y)
        {
            acceleration += Parameters.instance.power * Vector3.down;
        }
        // z軸方向に領域を超過した場合
        if (pos.z < wallTrans.position.z - scale_z)
        {
            acceleration += Parameters.instance.power * Vector3.forward;
        }
        else if (pos.z >= wallTrans.position.z + scale_z)
        {
            acceleration += Parameters.instance.power * Vector3.back;
        }
    }



    Vector3 CalcRefrect(float distanceW, Vector3 dir)
    {
        if((0f < distanceW) && (distanceW < Parameters.instance.wallDistance))   // 壁との距離が一定以内であれば反発
        {
            // 壁との距離が近い程強く反発し、遠いと反発が弱い
            return dir * Parameters.instance.wallRestitution / Mathf.Abs(distanceW / Parameters.instance.wallDistance);
        }

        return Vector3.zero;
    }



    float distance;
    public List<Vector3> neighborPos;
    public List<Vector3> neighborSpeed;     // x軸方向の速度、y軸方向の速度、z軸方向の速度の3成分であるためVector3を使う

    void Serch()
    {
        neighborPos.RemoveRange(0, neighborPos.Count);        // リストをクリア
        neighborSpeed.RemoveRange(0, neighborSpeed.Count);    // リストをクリア

        // items = GameObject.FindGameObjectsWithTag("clone");

        for (int i=1; i<Parameters.instance.amount; i++)
        {
            distance = (items[i].transform.position - pos).sqrMagnitude;              // 距離を網羅的に探査

            if ((0 < distance) && (distance < Mathf.Pow(Parameters.instance.neighborDistance, 2)))  // 距離が一定以内のものについて、その位置と速度をリスト化する
            {
                // そのオブジェクトのコンポーネントの中のposとvelocityを取ってくるように変更
                neighborPos.Add(items[i].transform.position);                    // 近い個体の位置をリスト内に格納
                neighborSpeed.Add(items[i].GetComponent<Boids>().velocity);      // 近い個体の各軸方向の速度をリスト内に格納
            }
        }
    }



    Vector3 routeChange;    

    void Separation()
    {
        if(neighborPos.Count <= 1)
        {
            // Nothing
        }
        else
        {
            routeChange = Vector3.zero;                             // 初期化
            for(int i=0; i< neighborPos.Count; i++)
            {
                routeChange += pos - neighborPos[i];   // 近くの個体と自分との間のベクトルの和
            }
            
            routeChange = routeChange.normalized;

            acceleration += Parameters.instance.separationWeigh * routeChange;
        }
    }



    Vector3 averageV;

    void Alignment()
    {
        if (neighborPos.Count <= 1)
        {
            // Nothing
        }
        else
        {
            averageV = Vector3.zero;
            for (int i = 0; i < neighborSpeed.Count; i++)
            {
                averageV += neighborSpeed[i];   // 近くの個体と自分との間のベクトルの和
            }

            averageV /= neighborSpeed.Count;

            acceleration += Parameters.instance.alignmentWeight * (averageV - velocity);
        }
    }



    Vector3 averagePos;

    void Centripetence()
    {
        if (neighborPos.Count <= 1)
        {
            // Nothing
        }
        else
        {
            averagePos = Vector3.zero;
            for (int i = 0; i < neighborPos.Count; i++)
            {
                averagePos += neighborPos[i];   // 近くの個体の位置の和
            }

            averagePos /= neighborPos.Count;

            acceleration += Parameters.instance.CentripetalWeight * (averagePos - pos);
        }
    }



    float dist;

    void React(bool state, Vector3 charcterPos)
    {
        dist = (charcterPos - pos).sqrMagnitude;

        if (state)
        {
            if ((0f < dist) && (dist < Mathf.Pow(Parameters.instance.characterReact * Parameters.instance.astonish, 2)))
            {
                acceleration += -1f * Parameters.instance.reactWeight * Parameters.instance.astonish * (charcterPos - pos).normalized;
            }
        }
        else
        {
            if ((0f < dist) && (dist < Mathf.Pow(Parameters.instance.characterReact, 2)))
            {
                acceleration += -1f * Parameters.instance.reactWeight * (charcterPos - pos).normalized;
            }
        }
    }



    Quaternion rot;

    void Move()
    {
        dt = Time.deltaTime;
        velocity += acceleration * dt;                  // v = a * t

        velocity.y = velocity.y / 1.1f;                 // 上下の移動量を僅かに制限

        Vector3 direction = velocity.normalized;        // 方向を示す単位ベクトル

        // 速度が最小値を下回っているなら最小値に、最大値を上回っているなら最大値にする
        velocity = Mathf.Clamp(velocity.magnitude, Parameters.instance.minV, Parameters.instance.maxV) * direction;

        pos += velocity * dt;                           // x = v * t
        rot = Quaternion.LookRotation(velocity);    // 移動方向へ向き直す

        transform.SetPositionAndRotation(pos, rot);     // 位置を向きを代入

        acceleration = Vector3.zero;
    }
}
