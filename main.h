#pragma once

#include<vector>					// �������Ǘ��p

// ��`
#define ON			1u 
#define OFF			0u

#define ACCUR		512			    // �v�Z���x

#define Fo_MAIN		"CELL_MODEL"	// �ŏ��folder
#define Fo_INPUT	"INPUT"		    // �ݒ�lfolder
#define Fo_CASH		"CASH"			// �ꎞfolder
#define Fo_OUTPUT	"OUTPUT"		// �v�Z����folder


// typedef��`
typedef unsigned char	UINT8;
typedef signed char		SINT8;
typedef unsigned short	UINT16;
typedef signed short	SINT16;
typedef unsigned int	UINT32;
typedef signed int		SINT32;
typedef double			SINT64;

typedef struct {						// �ݒ���\����
	SINT32 size;		// ��ӂ̒���
	SINT32 cell_a;		// �S�Z����
	SINT32 step_a;		// �S�X�e�b�v��
	SINT32 step_i;		// �X�e�b�v�Ԋu
	SINT32 type_a;		// �̎�ސ�
	SINT32 robust;      // ���o�X�g�`�F�b�N�t���O
	SINT32 rob_step;    // �����j�󂷂�step
	SINT32 breakL;      // �j�󂷂�̈�̈�ӂ̑傫��
}CONFIGDATA;
typedef struct {							// �̏��\����
	SINT32 number;		// �����̐�
	SINT32  target;		// �ߐH�Ώ�
	SINT32  diffusion;	// �ړ��W��
	SINT32  try_move;	// �ړ����s��
	SINT32  m_life;		// �ő����
	SINT32  m_breed;	// �ő呝�B����
	SINT32  m_vanish;	// �ő���Ŏ���
	SINT32  m_react;	// �ő唽���Ԋu      
}TYPEDATA;
typedef struct {						// �Z�����\����
	SINT32 type;		// ���
	SINT32 r_life;		// �c����
	SINT32 r_breed;		// �c���B����
	SINT32 r_vanish;	// �c���Ŏ���
	SINT32 r_react;		// �c�����Ԋu
	SINT32 f_act;		// �s���ς݃t���O
}CELLDATA;



// �ϐ���`

extern SINT32 step;										// ����Step����`
extern char calc_folder[255];							// �v�Z���ʃt�H���_��

extern vector<SINT32> array_t;							// �ړ����i�[�z���`
extern vector<vector<SINT32>> array_q;					// �̐��i�[�z���`

extern CONFIGDATA cf;									// �ݒ�f�[�^��`
extern CELLDATA delete_cell;							// ��Cell�f�[�^��`

extern vector<vector<CELLDATA>> cell_data;				// Cell�f�[�^��`
extern vector<TYPEDATA> type_data;						// �̃f�[�^��`
extern vector<CELLDATA> newtype_cell;					// �V��Cell�f�[�^��`

extern vector<vector<vector<SINT32>>> d_array_x;		// �ړ���i�[�z���`
extern vector<vector<vector<SINT32>>> d_array_y;		// �ړ���i�[�z���`