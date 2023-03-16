using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System;
using System.IO;


public class GA_Individuals : MonoBehaviour
{
    [SerializeField] private GameObject parametersObject;
    [SerializeField] private GameObject rootBone;               // root boneの登録
    [SerializeField] private GameObject[] thisJoints;           // 自身の関節
    [SerializeField] private int thisId;
    [SerializeField] private float[] genes;                     // インスペクターで確認するための変数　多次元配列のままだとインスペクターから確認できない
    private Vector3 rootInitPos, rootInitAng;
    private Vector3[] jointInitPos, jointInitAng;

    private GA_Parameters parameters;
    private GA_Execution execution;
    private ConfigurableJoint[] configurableJoints;
    private JointDrive jointDrive;                              // トルクの性質
    private Transform rootTrans;
    private Transform[] jointTrans;
    Rigidbody rigidBody_root;
    Rigidbody[] rigidBody_joints;
    private Vector3 v0;


    void Start()
    {
        parameters = parametersObject.GetComponent<GA_Parameters>();
        execution = parametersObject.GetComponent<GA_Execution>();
        rootTrans = rootBone.transform;
        v0 = Vector3.zero;

        thisId = parameters.idNumber;                 // 識別番号の割当
        parameters.idNumber++;

        configurableJoints = new ConfigurableJoint[parameters.joints.Length];
        rigidBody_root = rootBone.GetComponent<Rigidbody>();

        rigidBody_joints = new Rigidbody[parameters.joints.Length];
        jointTrans = new Transform[parameters.joints.Length];
        for (int i=0; i<parameters.joints.Length; i++)
        {
            configurableJoints[i] = thisJoints[i].GetComponent<ConfigurableJoint>();
            configurableJoints[i].slerpDrive = parameters.jd[i];                                        // 筋力を初期化
            rigidBody_joints[i] = thisJoints[i].GetComponent<Rigidbody>();
            jointTrans[i] = thisJoints[i].transform;
        }


        genes = new float[4 * parameters.joints.Length * parameters.steps + parameters.steps];
        int locus = 0;
        // 初期遺伝子を決定し自分のインデックスに登録
        if(parameters.handOver == true)
        {
            HandOver();
        }
        else
        {
            for (int i = 0; i < parameters.steps; i++)
            {
                for (int j = 0; j < parameters.joints.Length; j++)
                {
                    parameters.genome[thisId, locus] = UnityEngine.Random.Range(
                        parameters.jointConfig[4 * j + 0], parameters.jointConfig[4 * j + 1]);               // 関節jのX軸方向の可動域
                    genes[locus] = parameters.genome[thisId, locus];
                    locus++;

                    parameters.genome[thisId, locus] = UnityEngine.Random.Range(
                        -1f * parameters.jointConfig[4 * j + 2], parameters.jointConfig[4 * j + 2]);         // 関節jのY軸方向の可動域
                    genes[locus] = parameters.genome[thisId, locus];
                    locus++;

                    parameters.genome[thisId, locus] = UnityEngine.Random.Range(
                        -1f * parameters.jointConfig[4 * j + 3], parameters.jointConfig[4 * j + 3]);         // 関節jのZ軸方向の可動域
                    genes[locus] = parameters.genome[thisId, locus];
                    locus++;

                    parameters.genome[thisId, locus] = UnityEngine.Random.Range(-1f, 1f);                    // 関節jの筋力
                    genes[locus] = parameters.genome[thisId, locus];
                    locus++;
                }
            }
            for (int i = 0; i < parameters.steps; i++)                                                       // 各stepの時間
            {
                parameters.genome[thisId, locus] = UnityEngine.Random.Range(parameters.minStep, parameters.maxStep + 1);
                genes[locus] = parameters.genome[thisId, locus];
                locus++;
            }
        }
        

        jointDrive = new JointDrive
        {
            positionSpring = 40000f,        // 回転力
            positionDamper = 5000f,         // 回転力の減衰
            maximumForce = 0f               // 回転力の限界値　0～2万
        };

        rootInitPos = rootTrans.localPosition;
        rootInitAng = rootTrans.localEulerAngles;
        jointInitPos = new Vector3[thisJoints.Length];
        jointInitAng = new Vector3[thisJoints.Length];

        for (int i = 0; i < parameters.joints.Length; i++)
        {
            jointInitPos[i] = jointTrans[i].localPosition;
            jointInitAng[i] = jointTrans[i].localEulerAngles;
        }
    }

    [SerializeField] private int currentTime = 0;
    [SerializeField] private int currentStep = 0;
    private Vector3 previous, pos;
    private float score = 0f;


    // 遺伝情報について、
    // [0～ジョイント数 * 4 * 1 - 1]までがstep1での関節に関する遺伝子
    // [ジョイント数 * 4 * 0 ～ ジョイント数 * 4 * 1 - 1]　までがstep1での関節に関する遺伝子
    // [ジョイント数 * 4 * 1 ～ ジョイント数 * 4 * 2 - 1]　までがstep2での関節に関する遺伝子
    // [ジョイント数 * 4 * 2 ～ ジョイント数 * 4 * 3 - 1]　までがstep3での関節に関する遺伝子
    // [ジョイント数 * 4 * n ～ ジョイント数 * 4 * (n+1) - 1]　までがstepNでの関節に関する遺伝子
    // [ジョイント数 * 4 * steps + steps]　までが時間に関する遺伝子

    void Update()
    {
        if (execution.elapse == 0)                         // 世代開始
        {
            previous = rootTrans.localPosition;
            score = 0f;
            CopyArr();
        }

        currentTime++;
        // step時間が時間遺伝子と等しくなったらstep時間をリセットして次のステップに移行する
        if (currentTime == parameters.genome[thisId, parameters.joints.Length * 4 * parameters.steps + currentStep])
        {
            currentTime = 0;
            currentStep++;

            if(currentStep == parameters.steps)            // 1サイクル終了
            {
                currentStep = 0;

                // スコア計算
                if (parameters.evaluate == parameters.evaluateFlag)
                {
                    pos = rootTrans.localPosition;
                    score += execution.CalcScore(previous, pos);
                    previous = pos;
                }
            }
        }

        if(execution.elapse == parameters.timeLimit)       // 1世代終了
        {
            // スコア計算
            if (parameters.evaluate != parameters.evaluateFlag)
            {
                pos = rootTrans.position;
                score = execution.CalcScore(previous, pos);
            }

            execution.scoreList[thisId] = score;           // スコアを登録
            Initialize();                                  // すべてのボーンを初期位置、初期角度に戻す
            currentTime = 0;                               // stepを中断して初期化
        }

        Move(currentStep);
    }




    private string[] lines;

    void HandOver()
    {
        lines = File.ReadAllLines(parameters.path, System.Text.Encoding.GetEncoding("shift-jis"));
        int index = 0;
        for (int i=(4 * parameters.joints.Length * parameters.steps + parameters.steps) * thisId; i < (4 * parameters.joints.Length * parameters.steps + parameters.steps) * (thisId + 1); i++)
        {
            parameters.genome[thisId, index] = float.Parse(lines[i]);
            genes[index] = parameters.genome[thisId, index];
            index++;
        }
    }


    void Move(int step)
    {
        for (int i=0; i<parameters.joints.Length; i++)
        {
            // 角速度を設ける
            configurableJoints[i].targetRotation = Quaternion.Euler(
                parameters.genome[thisId, 4 * parameters.joints.Length * step + 4 * i + 0],
                parameters.genome[thisId, 4 * parameters.joints.Length * step + 4 * i + 1],
                parameters.genome[thisId, 4 * parameters.joints.Length * step + 4 * i + 2]);

            // 遺伝子から筋力を発現
            jointDrive.maximumForce = (parameters.genome[thisId, 4 * parameters.joints.Length * step + 4 * i + 3] + 1f) * parameters.powerCoefficient * parameters.muscleStrength;
            configurableJoints[i].slerpDrive = jointDrive;
        }
    }


    void Initialize()
    {
        rigidBody_root.velocity = v0;
        rootTrans.localPosition = rootInitPos;
        rootTrans.localEulerAngles = rootInitAng;

        for (int i=0; i < parameters.joints.Length; i++)
        {
            rigidBody_joints[i].velocity = v0;
            jointTrans[i].localPosition = jointInitPos[i];
            jointTrans[i].localEulerAngles = jointInitAng[i];
        }
    }


    // インスペクタの表示を更新
    void CopyArr()
    {
        for(int i=0; i< 4 * parameters.joints.Length * parameters.steps + parameters.steps; i++)
        {
            genes[i] = parameters.genome[thisId, i];
        }
    }
}
