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
#include "make_type.h"


// �̐ݒ�o�͊֐�
void make_type(SINT32 buf_number)
{
	string buf_line;
	SINT32 buf_data[100];
	char buf_name[100];

	register SINT32 i = 0, j = 0, l = 0;
	register SINT64 k = 0;

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
		type_data[i].number = buf_data[i * 8];			        	// �����̐�
		type_data[i].target = (SINT32)buf_data[i * 8 + 1];			// �ߐH�Ώ�
		type_data[i].diffusion = (SINT32)buf_data[i * 8 + 2];		// �ړ��W��
		type_data[i].try_move = (SINT32)buf_data[i * 8 + 3];		// �ړ����s��
		type_data[i].m_life = (SINT32)buf_data[i * 8 + 4];			// �ő����
		type_data[i].m_breed = (SINT32)buf_data[i * 8 + 5];			// �ő呝�B����
		type_data[i].m_vanish = (SINT32)buf_data[i * 8 + 6];		// �ő���Ŏ���
		type_data[i].m_react = (SINT32)buf_data[i * 8 + 7];			// �ő唽���Ԋu
	}


	for (l = 0; l < buf_number; l++) {
		i = (SINT32)(genrand_real2() * cf.type_a);				// genrand_real2()��0�ȏ�1�����̗����@mt19937ar
		j = (SINT32)(genrand_real2() * 7);
		k = genrand_real2();
		switch (j) {
		case 0:
			if (type_data[i].target == 0) {
				type_data[i].target = (SINT32)(k * 255 + 1);			// �ߐH�Ώ� 1~255
			} else {
				type_data[i].target = 0;
			}

			break;
		case 1:
			type_data[i].diffusion = (SINT32)(k * 30 + 1);	    	// �ړ��W�� 1~30
			break;
		case 2:
			type_data[i].m_life = (SINT32)(k * 200 + 50);			// �ő���� 50~250
			break;
		case 3:
			type_data[i].m_breed = (SINT32)(k * 200 + 1);			// �ő呝�B���� 1~200
			break;
		case 4:
			type_data[i].m_vanish = (SINT32)(k * 200 + 1);		    // �ő���Ŏ��� 1~200
			break;
		case 5:
			type_data[i].m_react = (SINT32)(k * 10 + 1);			// �ő唽���Ԋu 1~10
			break;
		default:
			break;
		}
	}

	ofstream ofs;

	ofs.open(buf_name);							        // �t�@�C���W�J
	for (i = 0; i < cf.type_a; i++) {
		ofs << (SINT32)type_data[i].number << endl;		// �����̐�
		ofs << (SINT32)type_data[i].target << endl;		// �ߐH�Ώ�
		ofs << (SINT32)type_data[i].diffusion << endl;	// �ړ��W��
		ofs << (SINT32)type_data[i].try_move << endl;	// �ړ����s��
		ofs << (SINT32)type_data[i].m_life << endl;		// �ő����
		ofs << (SINT32)type_data[i].m_breed << endl;	// �ő呝�B����
		ofs << (SINT32)type_data[i].m_vanish << endl;	// �ő���Ŏ���
		ofs << (SINT32)type_data[i].m_react << endl;	// �ő唽���Ԋu
	}
	ofs.close();
}