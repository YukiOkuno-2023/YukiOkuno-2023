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
#include "mem_manage.h"



// �������Ǘ�
void mem_manage() {

	try {
		cell_data.resize(cf.size, vector<CELLDATA>(cf.size, delete_cell));	// �Z���f�[�^�������m��

		type_data.resize(cf.type_a);										// �̃f�[�^�������m��
		newtype_cell.resize(cf.type_a);										// �V��Cell�f�[�^�������m��

		array_t.resize(cf.cell_a);											// �ړ����i�[�z�񃁃����m��
		array_q.resize(cf.type_a, vector<SINT32>(cf.step_a + 1, 0));		// �����ύX7/19 cf.step_a��cf.step_a+1

	}
	catch (...) {
		// �G���[����
		cout << "�������s���ł��B" << endl;
		exit(0);
	}
}