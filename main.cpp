// �쐬��		:����
// �쐬����		:2018/08/19

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
#include "mem_manage.h"				// �������Ǘ�
#include "file_manage.h"			// File�Ǘ�
#include "data_out.h"				// ����File�o��
#include "make_type.h"				// �̐ݒ�o��
#include "read_config.h"			// �ݒ�l�Ǎ���
#include "read_type.h"				// �̃f�[�^�Ǎ���
#include "calc_dest.h"				// �ړ���v�Z�p
#include "test_debug.h"				// Test Debug�o��

#include "calc_init.h"				// �v�Z����������

#include "calc_prepar.h"			// �v�Z�O����
#include "calc_quality.h"           // �̐��v�Z����
#include "calc_main1.h"				// �v�ZMAIN����
#include "calc_main2.h"             // ���o�X�g����
#include "calc_dec.h"				// �v�Z�㏈��




// �֐���`
static void time_out(void);			// ���ԑ��菈��


// �ϐ���`
SINT32 step = 0;								// ����Step����`
clock_t start_t, end_t;							// ���Ԍv���ϐ���`
char calc_folder[255];							// �v�Z���ʃt�H���_��
vector<SINT32> array_t;							// �ړ����i�[�z���`
vector<vector<SINT32>> array_q;					// �̐��i�[�z���`

CONFIGDATA cf;									// �ݒ�f�[�^��`
CELLDATA delete_cell = {};						// ��Cell�f�[�^��`

vector<vector<CELLDATA>> cell_data;				// Cell�f�[�^��`
vector<TYPEDATA> type_data;						// �̃f�[�^��`
vector<CELLDATA> newtype_cell;					// �V��Cell�f�[�^��`




// main�֐�
int main()
{
	int i,x,y;
	int nowx, nowy;                             // �ړ��Ώۂ̍��W

	start_t = clock();							// ���s���ԑ���J�n
	srand((UINT32)time(NULL));
	init_genrand((UINT32)time(NULL));			// �����Z���k�c�C�X�^�[������
	read_config();								// �v�Z�ݒ�l�ǂݍ���
	mem_manage();								// �������m��


//	while (1) {

		start_t = clock();							// ���s���ԑ���J�n
//		make_type(15);								// �f�[�^�ύX
		read_type();								// �̐ݒ�l�ǂݍ���

		fol_manage();								// BUF RESULT �t�H���_�쐬 �ݒ�f�[�^�R�s�[

		calc_init();								// �v�Z����������
		//calc_quality();                           // �̐��̌v�Z(�����l�m�F)
		data_out(0);								// �v�Z���ʏ����o��(�������)
		
		time_out();									// �o�ߎ��ԏo��


		// �v�Z�J�n
		for (step = 0; step < cf.step_a; step++) {
			calc_quality();
			calc_prepar();							// �v�Z�O����	

			if (cf.robust == 1) {
				// ���o�X�g�����L�̎�
				if (step == cf.rob_step - 1) {
					for (i = 0; i < cf.cell_a; i++) {       // ��̂�����

						calc_dec(i, &nowx, &nowy);          // �ΏۃZ�����聕���Z����

						calc_main1(nowx, nowy);
						calc_main2();                       // �w��͈͂�j��

					}
				}
				else {
					for (i = 0; i < cf.cell_a; i++) {       // ��̂�����

						calc_dec(i, &nowx, &nowy);          // �ΏۃZ�����聕���Z����

						calc_main1(nowx, nowy);

					}
				}
			}
			else {
				// ���o�X�g���������̎�
				for (i = 0; i < cf.cell_a; i++) {         // ��̂�����

					calc_dec(i, &nowx, &nowy);            // �ΏۃZ�����聕���Z����

					calc_main1(nowx, nowy);

				}
			}
		
			for (x = 0; x < cf.size; x++) {            // �S�̈ړ���ɍs���ς݃t���O���폜
				for (y = 0; y < cf.size; y++) {
					cell_data[x][y].f_act = 0;
				}
			}
			

			if (step % 10 == 0) {
				time_out();							// �o�ߎ��ԏo��
			}

			if (((step + 1) % cf.step_i) == 0) {
				data_out(0);						// �v�Z���ʏ����o��
			}

		}

		calc_quality();                             // �̐��̌v�Z

		data_out(1);								// �̐������o��

		data_update();								// �f�[�^�X�V

//		compare_data();								// �f�[�^��r

		time_out();									// �o�ߎ��ԏo��
//	}
	return 0;
}

// ���ԑ��菈��
static void time_out() {

	end_t = clock();
	cout << "�i�s�� : " << step * 100.0 / cf.step_a << "��" << endl;
	cout << "�������� : " << (end_t - start_t) / 1000.0 << "�b" << endl;
	cout << endl;
}