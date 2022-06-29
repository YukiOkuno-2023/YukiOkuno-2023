//作成者		:奥野
//作成日時		:2018/08/20

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
#include "test_debug.h"


// デバッグ用書き出し
//	buf_n == 0 :       種類データ 書き出し
//	buf_n == 1 :     残寿命データ 書き出し
//	buf_n == 2 : 残増殖時間データ 書き出し
//	buf_n == 3 : 残消滅時間データ 書き出し
//	buf_n == 4 : 残反応間隔データ 書き出し
void test_output(SINT32 buf_n)
{
	register SINT32 x, y;
	char buf_name[100];

	ofstream ofs;

	switch (buf_n) {
	case 0:

		sprintf_s(buf_name, "%s/debug_type.txt", calc_folder);		// ファイルを書きだす場所指定
		ofs.open(buf_name, ios::app);							    // 追記モードでファイル展開

		// 種類データ 書き出し
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].type << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 1:

		sprintf_s(buf_name, "%s/debug_life.txt", calc_folder);		// ファイルを書きだす場所指定
		ofs.open(buf_name, ios::app);							    // 追記モードでファイル展開

		// 残寿命データ 書き出し
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].r_life << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 2:

		sprintf_s(buf_name, "%s/debug_breed.txt", calc_folder);		// ファイルを書きだす場所指定
		ofs.open(buf_name, ios::app);							    // 追記モードでファイル展開

		// 残増殖時間データ 書き出し
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].r_breed << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 3:

		sprintf_s(buf_name, "%s/debug_vanish.txt", calc_folder);		// ファイルを書きだす場所指定
		ofs.open(buf_name, ios::app);							        // 追記モードでファイル展開

		// 残消滅時間データ 書き出し
		for (x = 0; x < cf.size; x++) {
			for (y = 0; y < cf.size; y++) {
				ofs << (SINT32)cell_data[x][y].r_vanish << ",";
			}
			ofs << endl;
		}
		ofs.close();
		break;

	case 4:

		sprintf_s(buf_name, "%s/debug_react.txt", calc_folder);		// ファイルを書きだす場所指定
		ofs.open(buf_name, ios::app);							    // 追記モードでファイル展開

		// 残反応間隔データ 書き出し
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

// 対象座標、移動先座標の書き出し
void ransu(SINT32 nowx, SINT32 nowy, SINT32 nextx, SINT32 nexty)
{
	char buf_name[100];

	ofstream ofs;

	sprintf_s(buf_name, "%s/debug_now.txt", calc_folder);		// ファイルを書きだす場所指定
	ofs.open(buf_name, ios::app);							    // 追記モードでファイル展開
	
	ofs << "(" << nowx << "," << nowy << ")";
	ofs.close();


	sprintf_s(buf_name, "%s/debug_next.txt", calc_folder);		// ファイルを書きだす場所指定
	ofs.open(buf_name, ios::app);							    // 追記モードでファイル展開

	ofs << "(" << nextx << "," << nexty << ")";
	ofs.close();


}
