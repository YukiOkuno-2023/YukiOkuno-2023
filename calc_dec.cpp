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
#include "calc_dec.h"
#include "test_debug.h"


// ���Z����
int calc_dec(int i,int *now_x,int *now_y)
{
	// �Ώ�Cell����
	*now_x = array_t[i] % cf.size;
	*now_y = array_t[i] / cf.size;

	if (cell_data[*now_x][*now_y].type == 0) {
		// �Ώ�Cell�̖���
		// Do Nothing
	} 
	else if (cell_data[*now_x][*now_y].f_act != 0) {
		// �Ώ�Cell�̈ړ��ς�
		// Do Nothing
	}
	
	else {
		// �Ώ�Cell�̂���

		// �c�����o�ߏ���
		if (type_data[cell_data[*now_x][*now_y].type - 1].target != 0) {
			// �ߐH�Ώۂ���Type�͎c�����o�߂ɂ����ł͖���
			// Do Nothing
		}
		else {
			// �ߐH�Ώۖ���Type
			cell_data[*now_x][*now_y].r_life = cell_data[*now_x][*now_y].r_life - 1;			// �������Z
			if (cell_data[*now_x][*now_y].r_life == 0) {
				cell_data[*now_x][*now_y] = delete_cell;								// �c������0�Ȃ�폜
			}
		}

		// �c���Ŏ��Ԍo�ߏ���
		if (cell_data[*now_x][*now_y].type != 0 && type_data[cell_data[*now_x][*now_y].type - 1].target != 0) { // ���� 9/26�f���[�g����ĂȂ����ǂ����ǉ�
			// �ߐH�Ώۂ���TYPE
			cell_data[*now_x][*now_y].r_vanish = cell_data[*now_x][*now_y].r_vanish - 1;	// �Q�쎞�Ԍ��Z
			if (cell_data[*now_x][*now_y].r_vanish == 0) {
				cell_data[*now_x][*now_y] = delete_cell;							// �Q�쎞��0�ō폜
			}
		}
		else {
			// �ߐH�Ώۖ���Type�͎c���Ŏ��Ԃɂ����ł͖���
			// Do Nothing
		}

		// ���B���ԏ���
		if (cell_data[*now_x][*now_y].type != 0 && cell_data[*now_x][*now_y].r_breed != 0) { // ����9/26 �f���[�g����ĂȂ����ǂ����ǉ�
			cell_data[*now_x][*now_y].r_breed = cell_data[*now_x][*now_y].r_breed - 1;		// ���B����-1
		}

		if (cell_data[*now_x][*now_y].type != 0) {
			cell_data[*now_x][*now_y].r_react = cell_data[*now_x][*now_y].r_react - 1; // ����9/26 �ߐH�Ώۂ���Type�̂ݎc�������Ԃ��ւ炷
		}

	}
	return 0;
}
