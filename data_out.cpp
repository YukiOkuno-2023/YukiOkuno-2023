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
#include "data_out.h"



// �v�Z���ʏo�͏���
void data_out(SINT32 buf_n)
{
	register SINT32 x, y;
	char buf_name[100];

	ofstream ofs;

	switch (buf_n) {
	case 0:
		// ��ރf�[�^�����o��
		sprintf_s(buf_name, "%s/output.dat", calc_folder);		// �t�@�C�������������ꏊ�w��
		ofs.open(buf_name, ios::app);							// �ǋL���[�h�Ńt�@�C���W�J

		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].type << ",";		// ��ރf�[�^�����o��
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 1:
		// �̐��f�[�^�����o��
		sprintf_s(buf_name, "%s/population.dat", calc_folder);	// �t�@�C�������������ꏊ�w��
		ofs.open(buf_name, ios::app);							// �ǋL���[�h�Ńt�@�C���W�J

		ofs << "step type1 type2 type3 type4 type5 type6 type7" << endl;

		for (y = 0; y < cf.step_a + 1; y++) {
			ofs << y;
			for (x = 0; x < cf.type_a; x++) {
				ofs << " " << (SINT32)array_q[x][y];
			}
			ofs << endl;
		}

		ofs.close();
		break;

	default:
		// Do Nothing
		break;
	}
}