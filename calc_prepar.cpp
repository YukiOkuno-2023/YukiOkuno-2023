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
#include<vector>					//�������Ǘ��p

#include<direct.h>

#define _USE_MATH_DEFINES			//#include <math.h>�̏�ɋL�q
#include <math.h>
#include "mt19937ar.h"

using namespace std;

#include "main.h"
#include "calc_prepar.h"


// �v�Z�O����
void calc_prepar(void)
{
	register SINT32 i, j;


	// �ړ����i�[�z��X�V
	for (i = 0; i < cf.cell_a; i++) {
		j = (SINT32)(genrand_real2()*(cf.cell_a - i)) + i;
		swap(array_t[i], array_t[j]);
	}
}