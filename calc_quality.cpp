// �쐬��		:����
// �쐬����		:2018/09/21

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
#include "calc_quality.h"

void calc_quality(void)   // �̐�����
{
	register SINT32 x, y;

	for (x = 0; x < cf.size; x++) {
		for (y = 0; y < cf.size; y++) {

			// �̐�����
			if (cell_data[x][y].type == 0) {
				// Do Nothing
			}
			else {
				array_q[cell_data[x][y].type - 1][step] += 1;
			}
		}
	}
}