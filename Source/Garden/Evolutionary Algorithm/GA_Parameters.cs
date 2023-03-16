using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System;


public class GA_Parameters : MonoBehaviour
{
    [HideInInspector] public int idNumber;              // 個体ごとに識別番号を割り振る
    [HideInInspector] public float[] jointConfig;
    [HideInInspector] public JointDrive[] jd;           // トルクの性質
    [HideInInspector] public float[,] genome;           // 全個体の遺伝子リスト　[個体番号、遺伝子座]
    public string path;                                 // ファイルの絶対パス
    public bool handOver;                               // 遺伝子の持ち越し

    public int population;                              // シミュレーションに用いる個体数
    public enum Evaluate
    {
        Cycle,
        Generation
    }
    public Evaluate evaluate;                                             // 評価タイミングをステップを一周する毎か、世代終了毎かを選択する
    [HideInInspector] public Evaluate evaluateFlag = Evaluate.Cycle;
    [SerializeField] private GameObject root;
    public GameObject[] joints;                                           // 駆動させる関節のモデルケース　ここに格納した関節の可動域を全個体に適用する
    
    public int steps;                                                     // ループを構成する構成単位の数　テストケースでは4を採用
    public int timeLimit;                                                 // 1世代の制限時間
    public int minStep;                                                   // 各ステップの最小値
    public int maxStep;                                                   // 各ステップの最大値
    public int mutationEvent;                                             // 突然変異確率の分母 0以下で突然変異しなくなる
    [HideInInspector] public float powerCoefficient = 0.5f * 20000f;      // 筋力の係数
    public float muscleStrength;                                          // 筋力の係数


    void Awake()
    {
        idNumber = 0;

        // 鋳型個体の関節可動域を取得する
        // 取得するのはLowAngularXのLimit、HighAngularXのLimit、AngularYのLimit、AngularZのLimit、slerpDriveのPositionSpringとPositionDamperとMaximumForce
        for (int i = 0; i < joints.Length; i++)
        {
            Array.Resize(ref jointConfig, jointConfig.Length + 4);
            jointConfig[4 * i + 0] = joints[i].GetComponent<ConfigurableJoint>().lowAngularXLimit.limit;
            jointConfig[4 * i + 1] = joints[i].GetComponent<ConfigurableJoint>().highAngularXLimit.limit;
            jointConfig[4 * i + 2] = joints[i].GetComponent<ConfigurableJoint>().angularYLimit.limit;
            jointConfig[4 * i + 3] = joints[i].GetComponent<ConfigurableJoint>().angularZLimit.limit;
            // jointConfigの0～3はbone1の可動域、4～7にはbone2の可動域が入っている

            Array.Resize(ref jd, i + 1);
            jd[i] = new JointDrive
            {
                positionSpring = joints[i].GetComponent<ConfigurableJoint>().slerpDrive.positionSpring,      // 回転力  40000f
                positionDamper = joints[i].GetComponent<ConfigurableJoint>().slerpDrive.positionDamper,      // 回転力の減衰  5000f
                maximumForce = joints[i].GetComponent<ConfigurableJoint>().slerpDrive.maximumForce           // 回転力の限界値　0～2万
            };
        }

        // 遺伝子を格納する場所を用意する
        genome = new float[population, 4 * joints.Length * steps + steps];             // [個体数, X, Y, Z, Powerの4成分 * 骨数 * step構成数 + step構成数]
    }
}
