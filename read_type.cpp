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
#include "read_type.h"



// �̃f�[�^�ǂݍ���
void read_type(void)
{
	string buf_line;
	string token;
	SINT32 buf_data[100];    

	char buf_name[100];



	register SINT32 i = 0, j = 0, k = 0;

	sprintf_s(buf_name, "%s/input_type.dat", Fo_INPUT); 	// �ݒ�l�ꏊ�w��

	ifstream ifs(buf_name);									// data�t�@�C���ǂݍ���

															// �G���[�`�F�b�N
	if (ifs.fail()) {
		ifs.close();
		cout << "input_type.dat�t�@�C�������݂��܂���" << endl;
		exit(0);
	}

	// �f�[�^�i�[
	while (getline(ifs, buf_line)) {
		istringstream is(buf_line);
		is >> buf_data[i];
		i++;
	}
	ifs.close();

	// �̐ݒ�l������
	for (i = 0; i < cf.type_a; i++) {
		type_data[i].number = buf_data[i * 8];				// �����̐�
		type_data[i].target = buf_data[i * 8 + 1];			// �ߐH�Ώ�
		type_data[i].diffusion = buf_data[i * 8 + 2];		// �ړ��W��
		type_data[i].try_move = buf_data[i * 8 + 3];		// �ړ����s��
		type_data[i].m_life = buf_data[i * 8 + 4];			// �ő����
		type_data[i].m_breed = buf_data[i * 8 + 5];			// �ő呝�B����
		type_data[i].m_vanish = buf_data[i * 8 + 6];		// �ő���Ŏ���
		type_data[i].m_react = buf_data[i * 8 + 7];			// �ő唽���Ԋu

	}

	//�V�̐����f�[�^������
	for (i = 0; i < cf.type_a; i++) {
		newtype_cell[i].type = i + 1;
		newtype_cell[i].r_life = type_data[i].m_life;
		newtype_cell[i].r_breed = type_data[i].m_breed;
		newtype_cell[i].r_vanish = type_data[i].m_vanish;
		newtype_cell[i].r_react = type_data[i].m_react;
		newtype_cell[i].f_act = 1;        /*�����ύX6/30  ���B�̂͂���step�ł͓����Ȃ����߁@0��1�ɕύX*/
	}

}
