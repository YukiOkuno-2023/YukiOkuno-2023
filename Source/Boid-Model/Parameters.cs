using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Parameters : MonoBehaviour
{
    public static Parameters instance;

    // 注意事項
    // 速度を速める場合はwallRestitutionも高く設定する

    public int amount;                    // 個体数                サンプル数500

    public float initVelocity;            // 出現させたときの初速  サンプル値50
    public float minV;                    // 最低速度              サンプル値60
    public float maxV;                    // 最高速度              サンプル値80
    public float neighborDistance;        // 個体間距離            サンプル値25
    public float separationWeigh;         // 衝突回避の強さ        サンプル値25
    public float wallDistance;            // 壁との距離            サンプル値10
    public float wallRestitution;         // 反射の強さ            サンプル値 5
    public float power;                   // 領域外に出た場合の修正　値が高い程領域を厳密に守るが低いほど進路を自然に決定する
    public float alignmentWeight;         // 速度同期の強度        サンプル値 1
    public float CentripetalWeight;       // 結合の強度            サンプル値 1
    public float characterReact;          // 人を認識する距離      サンプル値100
    public float reactWeight;             // 人を回避する強度      サンプル値350
    public float astonish;                // 驚かせたとき          サンプル値3


    public void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }
    }
}