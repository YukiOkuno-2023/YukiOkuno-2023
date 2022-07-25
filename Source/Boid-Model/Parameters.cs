using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Parameters : MonoBehaviour
{
    public static Parameters instance;

    // ���ӎ���
    // ���x�𑬂߂�ꍇ��wallRestitution�������ݒ肷��

    public int amount;                    // �̐�                �T���v����500

    public float initVelocity;            // �o���������Ƃ��̏���  �T���v���l50
    public float minV;                    // �Œᑬ�x              �T���v���l60
    public float maxV;                    // �ō����x              �T���v���l80
    public float neighborDistance;        // �̊ԋ���            �T���v���l25
    public float separationWeigh;         // �Փˉ���̋���        �T���v���l25
    public float wallDistance;            // �ǂƂ̋���            �T���v���l10
    public float wallRestitution;         // ���˂̋���            �T���v���l 5
    public float power;                   // �̈�O�ɏo���ꍇ�̏C���@�l���������̈�������Ɏ�邪�Ⴂ�قǐi�H�����R�Ɍ��肷��
    public float alignmentWeight;         // ���x�����̋��x        �T���v���l 1
    public float CentripetalWeight;       // �����̋��x            �T���v���l 1
    public float characterReact;          // �l��F�����鋗��      �T���v���l100
    public float reactWeight;             // �l��������鋭�x      �T���v���l350
    public float astonish;                // ���������Ƃ�          �T���v���l3


    public void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }
    }
}