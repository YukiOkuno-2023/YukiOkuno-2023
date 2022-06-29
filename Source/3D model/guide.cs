using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A1RushSctipt : MonoBehaviour
{
    public float MperSec;
    public float GuidancePerformance;
    public float Range;
    public float Vx0;
    public float Vz0;

    private GameObject Character;
    Ability AbilityScript;
    private GameObject Target;
    private Vector3 WorldAngle;
    private Vector3 Initialize;
    private float Distance0;
    private float EstimatedTime;
    private float VxZero;
    private float VzZero;
    private bool XConst;
    private bool ZConst;
    private float Alpha;
    private float constant;
    private float DeltaTime;
    private float Amount;
    private float DiffX;
    private float Beta;
    private Vector3 Diff;
    private Vector3 Axis;
    private float Angle;
    private float Limit;
    private float Distance;
    private float Variant;
    private float TimeCount;
    private Vector3 Previous;
    private Vector3 Direction;

    Transform ThisTrans;
    Transform TargetTrans;

    void OnEnable()
    {
        Character = GameObject.Find("Gareth");
        AbilityScript = Character.GetComponent<Ability>();
        this.transform.position = Character.transform.position;

        Target = GameObject.FindGameObjectWithTag("Enemy1");
        ThisTrans = this.transform;
        TargetTrans = Target.transform;

        this.transform.LookAt(TargetTrans);
        WorldAngle = ThisTrans.eulerAngles;
        WorldAngle.x = 0f;
        WorldAngle.z = 0f;
        this.transform.eulerAngles = WorldAngle;

        Initialize = ThisTrans.position;
        Distance0 = Vector3.Distance(Initialize, TargetTrans.position);
        EstimatedTime = Distance0 / MperSec;
        Distance0 = 1 / Distance0;

        // Initialization
        VxZero = Vx0;
        VzZero = Vz0;
        Amount = 0f;
        Limit = 0f;
        TimeCount = 0f;
        Direction = Vector3.zero;

        if (Initialize.x == TargetTrans.position.x)
        {
            XConst = true;
        }
        else if (Initialize.z == Target.transform.position.z)
        {
            ZConst = true;
        }
        else
        {
            XConst = false;
            ZConst = false;
            Alpha = (Initialize.z - TargetTrans.position.z) / (Initialize.x - TargetTrans.position.x);
            constant = 1 / Mathf.Sqrt((Alpha * Alpha) + 1f);
        }
    }

    
    void Update()
    {
        ThisTrans = this.transform;
        TargetTrans = Target.transform;
        DeltaTime = Time.deltaTime;
        if (Amount < Range)
        {
            if (XConst == true && ZConst == false)
            {
                // 最初に2点を通る直線がx = 定数となる場合
                DiffX = TargetTrans.position.x - ThisTrans.position.x;
            }
            else if (ZConst == true && XConst == false)
            {
                // 最初に2点を通る直線がz = 定数となる場合
                DiffX = TargetTrans.position.z - ThisTrans.position.z;
            }
            else if (ZConst == true && XConst == true)
            {
                DiffX = 0f;
            }
            else
            {
                // 毎フレーム切片だけ変更して点と直線の距離を計算
                Beta = this.transform.position.z - Alpha * this.transform.position.x;
                DiffX = (Alpha * TargetTrans.position.x - TargetTrans.position.z + Beta) * constant;
            }
            DiffX = (DiffX > 0 ? DiffX : -DiffX);   // 絶対値

            // 自身から見たターゲットの方向を割り出し　向いている方向を0度、左側をマイナスとして-180～180°で表示
            Diff = TargetTrans.position - ThisTrans.position;
            Axis = Vector3.Cross(ThisTrans.forward, Diff);
            Angle = Vector3.Angle(ThisTrans.forward, Diff) * (Axis.y < 0 ? -1 : 1);
            if (Angle < 0f)
            {
                // 自分から見て左にあるならローカルx軸方向の加速度をマイナスに反転
                DiffX = -DiffX;
            }

            if (Limit >= 1)
            {
                // 自分から見て後ろにあるなら直前の誘導を引き継ぐ
                Direction.x = Previous.x;
                Direction.z = Previous.z;
            }
            else
            {
                Distance = Vector3.Distance(Initialize, TargetTrans.position);
                Variant = 1.1f * Distance * Distance0;       // 発射後の到達予定時刻の強引な補正によって誤差が生じ、多くの場合敵に到達する前に時間が0になる　これを防ぐために補正を掛ける

                TimeCount += DeltaTime;
                Limit = TimeCount / (EstimatedTime * Variant);    // 敵との距離を計算し最初の何倍であるかを計算してEstimatedTimeに掛ける

                // 座標の変化量を加える
                // 正規化するのでZ方向の成分を1と定義すると誘導成分は1に対する相対量となる
                Direction.x = VxZero + DiffX * GuidancePerformance * DeltaTime * Limit * Limit;
                Direction.z = VzZero + 1f;

                Direction = Direction.normalized * MperSec * DeltaTime;

                Previous.x = Direction.x;
                Previous.z = Direction.z;
            }

            this.transform.Translate(Direction);
            Amount += MperSec * DeltaTime;

            if (Vx0 > 0f)
            {
                if (VxZero <= 0.2f)
                {
                    VxZero = 0f;
                }
                else
                {
                    VxZero -= VxZero * DeltaTime;
                }
            }
            else if (Vx0 < 0f)
            {
                if (VxZero >= -0.2f)
                {
                    VxZero = 0f;
                }
                else
                {
                    VxZero -= VxZero * DeltaTime;
                }
            }

            if (Vz0 > 0f)
            {
                if (VzZero <= 0.2f)
                {
                    VzZero = 0f;
                }
                else
                {
                    VzZero -= VzZero * DeltaTime;
                }
            }
            else if (Vz0 < 0f)
            {
                if (VzZero >= -0.2f)
                {
                    VzZero = 0f;
                }
                else
                {
                    VzZero -= VzZero * DeltaTime;
                }
            }
        }
        else
        {
            AbilityScript.FightAnimation();
        }
        Character.transform.position = this.transform.position;
    }

    // コリジョンでこのオブジェクトをfalseに変更 + 攻撃に発生するためのトリガーをセット
    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Enemy1"){
            AbilityScript.FightAnimation();
        }
    }
}
