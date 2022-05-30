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
#include "make_type.h"


// 個体設定出力関数
void make_type(SINT32 buf_number)
{
	string buf_line;
	SINT32 buf_data[100];
	char buf_name[100];

	register SINT32 i = 0, j = 0, l = 0;
	register SINT64 k = 0;

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
		type_data[i].number = buf_data[i * 8];			        	// 初期個体数
		type_data[i].target = (SINT32)buf_data[i * 8 + 1];			// 捕食対象
		type_data[i].diffusion = (SINT32)buf_data[i * 8 + 2];		// 移動係数
		type_data[i].try_move = (SINT32)buf_data[i * 8 + 3];		// 移動試行回数
		type_data[i].m_life = (SINT32)buf_data[i * 8 + 4];			// 最大寿命
		type_data[i].m_breed = (SINT32)buf_data[i * 8 + 5];			// 最大増殖時間
		type_data[i].m_vanish = (SINT32)buf_data[i * 8 + 6];		// 最大消滅時間
		type_data[i].m_react = (SINT32)buf_data[i * 8 + 7];			// 最大反応間隔
	}


	for (l = 0; l < buf_number; l++) {
		i = (SINT32)(genrand_real2() * cf.type_a);				// genrand_real2()は0以上1未満の乱数　mt19937ar
		j = (SINT32)(genrand_real2() * 7);
		k = genrand_real2();
		switch (j) {
		case 0:
			if (type_data[i].target == 0) {
				type_data[i].target = (SINT32)(k * 255 + 1);			// 捕食対象 1~255
			} else {
				type_data[i].target = 0;
			}

			break;
		case 1:
			type_data[i].diffusion = (SINT32)(k * 30 + 1);	    	// 移動係数 1~30
			break;
		case 2:
			type_data[i].m_life = (SINT32)(k * 200 + 50);			// 最大寿命 50~250
			break;
		case 3:
			type_data[i].m_breed = (SINT32)(k * 200 + 1);			// 最大増殖時間 1~200
			break;
		case 4:
			type_data[i].m_vanish = (SINT32)(k * 200 + 1);		    // 最大消滅時間 1~200
			break;
		case 5:
			type_data[i].m_react = (SINT32)(k * 10 + 1);			// 最大反応間隔 1~10
			break;
		default:
			break;
		}
	}

	ofstream ofs;

	ofs.open(buf_name);							        // ファイル展開
	for (i = 0; i < cf.type_a; i++) {
		ofs << (SINT32)type_data[i].number << endl;		// 初期個体数
		ofs << (SINT32)type_data[i].target << endl;		// 捕食対象
		ofs << (SINT32)type_data[i].diffusion << endl;	// 移動係数
		ofs << (SINT32)type_data[i].try_move << endl;	// 移動試行回数
		ofs << (SINT32)type_data[i].m_life << endl;		// 最大寿命
		ofs << (SINT32)type_data[i].m_breed << endl;	// 最大増殖時間
		ofs << (SINT32)type_data[i].m_vanish << endl;	// 最大消滅時間
		ofs << (SINT32)type_data[i].m_react << endl;	// 最大反応間隔
	}
	ofs.close();
}