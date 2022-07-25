using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateClone : MonoBehaviour
{
    public GameObject FishOrigin;
    int roop;



    void Start()
    {
        roop = Parameters.instance.amount;     // 他のオブジェクトのコンポーネントの値を取ってくる

        for(int i=0; i<=roop; i++)
        {
            Make(i);              // 1フレーム内で生成する乱数は全て同じであるため、個体の生成はフレームを分けて行う
            if(i == roop)
            {
                FishOrigin.gameObject.SetActive(false);
            }
        }
    }



    void Update()
    {
        if (Input.GetKey(KeyCode.C))
        {
            Debug.Log("+100");
            Parameters.instance.amount += 100;
            FishOrigin.gameObject.SetActive(true);
            for(int i=0; i<=100; i++)
            {
                Make(i);
                if(i == 100)
                {
                    FishOrigin.gameObject.SetActive(false);
                }
            }
        }
    }



    float app_x, app_y, app_z;
    Vector3 appearance;

    void Make(int number)
    {
        Transform thisTrans = transform;

        app_x = Random.Range((thisTrans.position.x - thisTrans.localScale.x / 2f) * 0.9f, (thisTrans.position.x + thisTrans.localScale.x / 2f) * 0.9f);
        app_y = Random.Range((thisTrans.position.y - thisTrans.localScale.y / 2f) * 0.9f, (thisTrans.position.y + thisTrans.localScale.y / 2f) * 0.9f);
        app_z = Random.Range((thisTrans.position.z - thisTrans.localScale.z / 2f) * 0.9f, (thisTrans.position.z + thisTrans.localScale.z / 2f) * 0.9f);
        appearance.x = app_x;
        appearance.y = app_y;
        appearance.z = app_z;

        GameObject obj = Instantiate(FishOrigin, appearance, Random.rotation);    // 指定した個数だけ物体を複製
        // obj.name = number.ToString();
        obj.tag = "clone";
    }



    // シミュレーションエリアを表示する
    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;         // ギズモの色を赤色にする
        Gizmos.DrawWireCube(this.transform.position, this.transform.localScale * 1.2f);    // 表示するギズモの位置と大きさ
    }
}
