//�쐬��		:����
//�쐬����		:2018/08/20

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
#include "test_debug.h"


// �f�o�b�O�p�����o��
//	buf_n == 0 :       ��ރf�[�^ �����o��
//	buf_n == 1 :     �c�����f�[�^ �����o��
//	buf_n == 2 : �c���B���ԃf�[�^ �����o��
//	buf_n == 3 : �c���Ŏ��ԃf�[�^ �����o��
//	buf_n == 4 : �c�����Ԋu�f�[�^ �����o��
void test_output(SINT32 buf_n)
{
	register SINT32 x, y;
	char buf_name[100];

	ofstream ofs;

	switch (buf_n) {
	case 0:

		sprintf_s(buf_name, "%s/debug_type.txt", calc_folder);		// �t�@�C�������������ꏊ�w��
		ofs.open(buf_name, ios::app);							    // �ǋL���[�h�Ńt�@�C���W�J

		// ��ރf�[�^ �����o��
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].type << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 1:

		sprintf_s(buf_name, "%s/debug_life.txt", calc_folder);		// �t�@�C�������������ꏊ�w��
		ofs.open(buf_name, ios::app);							    // �ǋL���[�h�Ńt�@�C���W�J

		// �c�����f�[�^ �����o��
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].r_life << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 2:

		sprintf_s(buf_name, "%s/debug_breed.txt", calc_folder);		// �t�@�C�������������ꏊ�w��
		ofs.open(buf_name, ios::app);							    // �ǋL���[�h�Ńt�@�C���W�J

		// �c���B���ԃf�[�^ �����o��
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].r_breed << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 3:

		sprintf_s(buf_name, "%s/debug_vanish.txt", calc_folder);		// �t�@�C�������������ꏊ�w��
		ofs.open(buf_name, ios::app);							        // �ǋL���[�h�Ńt�@�C���W�J

		// �c���Ŏ��ԃf�[�^ �����o��
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].r_vanish << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 4:

		sprintf_s(buf_name, "%s/debug_react.txt", calc_folder);		// �t�@�C�������������ꏊ�w��
		ofs.open(buf_name, ios::app);							    // �ǋL���[�h�Ńt�@�C���W�J

		// �c�����Ԋu�f�[�^ �����o��
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].r_react << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	default:
		break;
	}
}

// �Ώۍ��W�A�ړ�����W�̏����o��
void ransu(SINT32 nowx, SINT32 nowy, SINT32 nextx, SINT32 nexty)
{
	char buf_name[100];

	ofstream ofs;

	sprintf_s(buf_name, "%s/debug_now.txt", calc_folder);		// �t�@�C�������������ꏊ�w��
	ofs.open(buf_name, ios::app);							    // �ǋL���[�h�Ńt�@�C���W�J
	
	ofs << "(" << nowx << "," << nowy << ")";
	ofs.close();


	sprintf_s(buf_name, "%s/debug_next.txt", calc_folder);		// �t�@�C�������������ꏊ�w��
	ofs.open(buf_name, ios::app);							    // �ǋL���[�h�Ńt�@�C���W�J

	ofs << "(" << nextx << "," << nexty << ")";
	ofs.close();


}
