// �쐬��		:����
// �쐬����		:2018/08/20

#include<iostream>
#include<ctime>
#include<cstdio>
#include<cstdlib>
#include<ctime>
#include<fstream>
#include<sstream>
#include<string>
#include<windows.h>
#include<vector>					// �������Ǘ��p

#include<direct.h>

#define _USE_MATH_DEFINES			// #include <math.h>�̏�ɋL�q
#include <math.h>
#include "mt19937ar.h"

using namespace std;

#include "main.h"
#include "read_config.h"



// �ݒ�l�ǂݍ���
void read_config(void)
{
	string buf_line;
	SINT32 buf_data[10];

	char buf_name[100];

	SINT32 i = 0;

	sprintf_s(buf_name, "%s/input_main.dat", Fo_INPUT);	// �ݒ�l�ꏊ�w��

	ifstream ifs(buf_name);									// data�t�@�C���ǂݍ���
	if (ifs.fail()) {
		cout << "input_main.dat�t�@�C�������݂��܂���" << endl;
		exit(0);
	}

	while (getline(ifs, buf_line)) {
		istringstream is(buf_line);
		is >> buf_data[i];
		i++;
	}

	// �ݒ�l������
	cf.size = buf_data[0];								// ��ӂ̒���
	cf.step_a = buf_data[1];							//  �S�X�e�b�v��
	cf.step_i = buf_data[2];							//�����o���X�e�b�v�Ԋu
	cf.type_a = buf_data[3];							// �̎�ސ�
	cf.robust = buf_data[4];                            // ���o�X�g�`�F�b�N�t���O
	cf.rob_step = buf_data[5];                          // �����j�󂷂�step
	cf.breakL = buf_data[6];                            // �j�󂷂�̈�̈�ӂ̑傫��

	cf.cell_a = cf.size * cf.size;						// �S�Z����
}