// 作成者		:奥野
// 作成日時		:2018/08/20

#include<iostream>
#include<ctime>
#include<cstdio>
#include<cstdlib>
#include<ctime>
#include<fstream>
#include<sstream>
#include<string>
#include<windows.h>
#include<vector>					// メモリ管理用

#include<direct.h>

#define _USE_MATH_DEFINES			// #include <math.h>の上に記述
#include <math.h>
#include "mt19937ar.h"

using namespace std;

#include "main.h"
#include "read_type.h"



// 個体データ読み込み
void read_type(void)
{
	string buf_line;
	string token;
	SINT32 buf_data[100];    

	char buf_name[100];



	register SINT32 i = 0, j = 0, k = 0;

	sprintf_s(buf_name, "%s/input_type.dat", Fo_INPUT); 	// 設定値場所指定

	ifstream ifs(buf_name);									// dataファイル読み込み

															// エラーチェック
	if (ifs.fail()) {
		ifs.close();
		cout << "input_type.datファイルが存在しません" << endl;
		exit(0);
	}

	// データ格納
	while (getline(ifs, buf_line)) {
		istringstream is(buf_line);
		is >> buf_data[i];
		i++;
	}
	ifs.close();

	// 個体設定値初期化
	for (i = 0; i < cf.type_a; i++) {
		type_data[i].number = buf_data[i * 8];				// 初期個体数
		type_data[i].target = buf_data[i * 8 + 1];			// 捕食対象
		type_data[i].diffusion = buf_data[i * 8 + 2];		// 移動係数
		type_data[i].try_move = buf_data[i * 8 + 3];		// 移動試行回数
		type_data[i].m_life = buf_data[i * 8 + 4];			// 最大寿命
		type_data[i].m_breed = buf_data[i * 8 + 5];			// 最大増殖時間
		type_data[i].m_vanish = buf_data[i * 8 + 6];		// 最大消滅時間
		type_data[i].m_react = buf_data[i * 8 + 7];			// 最大反応間隔

	}

	//新個体生成データ初期化
	for (i = 0; i < cf.type_a; i++) {
		newtype_cell[i].type = i + 1;
		newtype_cell[i].r_life = type_data[i].m_life;
		newtype_cell[i].r_breed = type_data[i].m_breed;
		newtype_cell[i].r_vanish = type_data[i].m_vanish;
		newtype_cell[i].r_react = type_data[i].m_react;
		newtype_cell[i].f_act = 1;        /*水口変更6/30  増殖個体はそのstepでは動かないため　0→1に変更*/
	}

}
