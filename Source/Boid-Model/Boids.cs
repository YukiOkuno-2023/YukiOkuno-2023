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

        Refrect(wallTrans);     // �ǂ̔���
        Serch();                // ���������ȓ��̌̂����X�g��
        Separation();           // �����F�Փˉ��
        Alignment();            // ����F���X�g������ӌ̂̕��ϑ��x�����߁A���͂ɍ��킹��悤�ɉ����x�𑝌�������

        // Alignment�ő��x�����킹�Ă��邪�A���ۂ͗^����x�N�g�������킹�Ă���
        // ���̂��߁A�����A����A�����̂������łɌ����͒Ⴂ���x���Ŗ������Ă���
        // ���x�̍��������͕K�v�ɉ����ėp����̂��ǂ�
        Centripetence();           // �����F���S�Ɍ�����

        React(Humanoid.instance.State, Humanoid.instance.trans);     // �L�����N�^�[�̓����ɍ��킹�ċ��Q�����������


        Move();                 // �ړ��̉��Z
    }



    float scale_x, scale_y, scale_z;

    void Refrect(Transform wallTrans)
    {
        scale_x = wallTrans.localScale.x / 2f;  // ��������[�܂ł̋���
        scale_y = wallTrans.localScale.y / 2f;
        scale_z = wallTrans.localScale.z / 2f;

        /************        ����        ************/
        // ���˂̋���������wallRestitution�͒Ⴂ�Ɣ��˂��؂ꂸ�A�ǂ��ђʂ��Ă��܂�
        // �����������Ɣ������J��Ԃ����Ƃɉ������A���x�̍ő�l����������ƍŏI�I�ɔ������؂ꂸ�ǂ��ђʂ���
        // ���̂��߃p�����[�^�[�̏����́A
        // �@ �����W���͒Ⴗ���Ă͂Ȃ�Ȃ�
        // �A �����W���������ݒ肷��Ȃ�ő呬�x�������ݒ肵�Ȃ�
        // ��L�̃p�����[�^�[�ŏ�肭�ǍۂŋȂ����Ă����悤�ɒ�������
        // �����o���Ȃ��ꍇ��power�̒l���グ�邱�Ƃŗ̈�𒴂����ꍇ�����ɖ߂�悤�ɏo����

        acceleration +=
            CalcRefrect(wallTrans.position.x - scale_x - pos.x, Vector3.right)   + CalcRefrect(wallTrans.position.x + scale_x - pos.x, Vector3.left) +
            CalcRefrect(wallTrans.position.y - scale_y - pos.y, Vector3.up)      + CalcRefrect(wallTrans.position.y + scale_y - pos.y, Vector3.down) +
            CalcRefrect(wallTrans.position.z - scale_z - pos.z, Vector3.forward) + CalcRefrect(wallTrans.position.z + scale_z - pos.z, Vector3.back);
        // �����̓t�B�[���h�̈ʒu��␳������ł̕ǂƂ̋����Ɣ�������


        // �̈�O�ɏo���ꍇ�ɂ��ē�d�ɕی���������
        // x�������ɗ̈�𒴉߂����ꍇ
        if(pos.x < wallTrans.position.x - scale_x)
        {
            acceleration += Parameters.instance.power * Vector3.right;
        }
        else if(pos.x >= wallTrans.position.x + scale_x)
        {
            acceleration += Parameters.instance.power * Vector3.left;
        }
        // y�������ɗ̈�𒴉߂����ꍇ
        if (pos.y < wallTrans.position.y - scale_y)
        {
            acceleration += Parameters.instance.power * Vector3.up;
        }
        else if (pos.y >= wallTrans.position.y + scale_y)
        {
            acceleration += Parameters.instance.power * Vector3.down;
        }
        // z�������ɗ̈�𒴉߂����ꍇ
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
        if((0f < distanceW) && (distanceW < Parameters.instance.wallDistance))   // �ǂƂ̋��������ȓ��ł���Δ���
        {
            // �ǂƂ̋������߂��������������A�����Ɣ������ア
            return dir * Parameters.instance.wallRestitution / Mathf.Abs(distanceW / Parameters.instance.wallDistance);
        }

        return Vector3.zero;
    }



    float distance;
    public List<Vector3> neighborPos;
    public List<Vector3> neighborSpeed;     // x�������̑��x�Ay�������̑��x�Az�������̑��x��3�����ł��邽��Vector3���g��

    void Serch()
    {
        neighborPos.RemoveRange(0, neighborPos.Count);        // ���X�g���N���A
        neighborSpeed.RemoveRange(0, neighborSpeed.Count);    // ���X�g���N���A

        // items = GameObject.FindGameObjectsWithTag("clone");

        for (int i=1; i<Parameters.instance.amount; i++)
        {
            distance = (items[i].transform.position - pos).sqrMagnitude;              // ������ԗ��I�ɒT��

            if ((0 < distance) && (distance < Mathf.Pow(Parameters.instance.neighborDistance, 2)))  // ���������ȓ��̂��̂ɂ��āA���̈ʒu�Ƒ��x�����X�g������
            {
                // ���̃I�u�W�F�N�g�̃R���|�[�l���g�̒���pos��velocity������Ă���悤�ɕύX
                neighborPos.Add(items[i].transform.position);                    // �߂��̂̈ʒu�����X�g���Ɋi�[
                neighborSpeed.Add(items[i].GetComponent<Boids>().velocity);      // �߂��̂̊e�������̑��x�����X�g���Ɋi�[
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
            routeChange = Vector3.zero;                             // ������
            for(int i=0; i< neighborPos.Count; i++)
            {
                routeChange += pos - neighborPos[i];   // �߂��̌̂Ǝ����Ƃ̊Ԃ̃x�N�g���̘a
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
                averageV += neighborSpeed[i];   // �߂��̌̂Ǝ����Ƃ̊Ԃ̃x�N�g���̘a
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
                averagePos += neighborPos[i];   // �߂��̌̂̈ʒu�̘a
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

        velocity.y = velocity.y / 1.1f;                 // �㉺�̈ړ��ʂ��͂��ɐ���

        Vector3 direction = velocity.normalized;        // �����������P�ʃx�N�g��

        // ���x���ŏ��l��������Ă���Ȃ�ŏ��l�ɁA�ő�l�������Ă���Ȃ�ő�l�ɂ���
        velocity = Mathf.Clamp(velocity.magnitude, Parameters.instance.minV, Parameters.instance.maxV) * direction;

        pos += velocity * dt;                           // x = v * t
        rot = Quaternion.LookRotation(velocity);    // �ړ������֌�������

        transform.SetPositionAndRotation(pos, rot);     // �ʒu����������

        acceleration = Vector3.zero;
    }
}
