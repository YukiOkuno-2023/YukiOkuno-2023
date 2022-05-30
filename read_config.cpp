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
#include "read_config.h"



// 設定値読み込み
void read_config(void)
{
	string buf_line;
	SINT32 buf_data[10];

	char buf_name[100];

	SINT32 i = 0;

	sprintf_s(buf_name, "%s/input_main.dat", Fo_INPUT);	// 設定値場所指定

	ifstream ifs(buf_name);									// dataファイル読み込み
	if (ifs.fail()) {
		cout << "input_main.datファイルが存在しません" << endl;
		exit(0);
	}

	while (getline(ifs, buf_line)) {
		istringstream is(buf_line);
		is >> buf_data[i];
		i++;
	}

	// 設定値初期化
	cf.size = buf_data[0];								// 一辺の長さ
	cf.step_a = buf_data[1];							//  全ステップ数
	cf.step_i = buf_data[2];							//書き出しステップ間隔
	cf.type_a = buf_data[3];							// 個体種類数
	cf.robust = buf_data[4];                            // ロバストチェックフラグ
	cf.rob_step = buf_data[5];                          // 部分破壊するstep
	cf.breakL = buf_data[6];                            // 破壊する領域の一辺の大きさ

	cf.cell_a = cf.size * cf.size;						// 全セル数
}