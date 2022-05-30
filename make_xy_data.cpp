//�쐬��		:����
//�쐬����		:2017/08/20
//�ŏI�X�V��	:2017/08/20

#include<iostream>
#include<ctime>
#include<cstdio>
#include<cstdlib>
#include<ctime>
#include<fstream>
#include<sstream>
#include<string>
#include<windows.h>
#include<vector>					//�������Ǘ��p

#include<direct.h>

#define _USE_MATH_DEFINES			//#include <math.h>�̏�ɋL�q
#include <math.h>
#include "mt19937ar.h"

using namespace std;				//�v����

#include "main.h"
#include "make_xy_data.h"

/**********************************************************************/
// @ make_xy_data()   �ړ���f�[�^�o��
/**********************************************************************/
void make_xy_data(UINT8 buf_diffusion)
{
	vector<vector<SINT16>> xdata;
	vector<vector<SINT16>> ydata;
	UINT32 i, j;
	SINT64 buf_x, buf_y;

	char buf_name_x[30];
	char buf_name_y[30];

	try {
		xdata.resize(ACCUR, vector<SINT16>(ACCUR, 0));		//�������m��
		ydata.resize(ACCUR, vector<SINT16>(ACCUR, 0));		//�������m��
	}
	catch (...) {
		//�G���[����
		cout << "�������s���ł��B" << endl;
		exit(0);
	}

	_mkdir(Fo_CASH);										//cash�t�H���_�쐬
	sprintf_s(buf_name_x, "%s/%d_%d_x.txt", Fo_CASH, ACCUR, buf_diffusion);
	sprintf_s(buf_name_y, "%s/%d_%d_y.txt", Fo_CASH, ACCUR, buf_diffusion);

	ifstream ifs(buf_name_x);								//data�t�@�C���ǂݍ���
	if (ifs.fail()) {
		ifs.close();
		cout << "CASH�t�@�C�������݂��܂���" << endl;
		cout << "CASH�t�@�C�����쐬���܂�" << endl;


		for (i = 0; i < ACCUR; i++) {
			for (j = 0; j < ACCUR; j++) {
				buf_x = buf_diffusion * sqrt(-2 * log(1.0 - i / (ACCUR*1.0 + 1))) * cos(2 * M_PI * (1.0 - j / (ACCUR*1.0 + 1)));	//1.0�������Ă���̂͌^�ϊ��̂���
				buf_y = buf_diffusion * sqrt(-2 * log(1.0 - i / (ACCUR*1.0 + 1))) * sin(2 * M_PI * (1.0 - j / (ACCUR*1.0 + 1)));	//1.0�������Ă���̂͌^�ϊ��̂���


				if (buf_x >= 0) {
					xdata[i][j] = (SINT16)(buf_x + 0.5);
				} else {
					xdata[i][j] = (SINT16)(buf_x - 0.5);
				}

				if (buf_y >= 0) {
					ydata[i][j] = (SINT16)(buf_y + 0.5);
				} else {
					ydata[i][j] = (SINT16)(buf_y - 0.5);
				}
			}
		}

		//�t�@�C���쐬
		ofstream ofs;
		ofs.open(buf_name_x, ios::out);								//�t�@�C�������������ꏊ�w��
		for (i = 0; i < ACCUR; i++) {
			for (j = 0; j < ACCUR; j++) {
				ofs << xdata[i][j] << ",";
			}
		}
		ofs.close();

		ofs.open(buf_name_y, ios::out);								//�t�@�C�������������ꏊ�w��
		for (i = 0; i < ACCUR; i++) {
			for (j = 0; j < ACCUR; j++) {
				ofs << ydata[i][j];
				ofs << ",";
			}
		}
		ofs.close();
	}
}