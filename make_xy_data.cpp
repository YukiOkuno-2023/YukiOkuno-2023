//作成者		:水口
//作成日時		:2017/08/20
//最終更新日	:2017/08/20

#include<iostream>
#include<ctime>
#include<cstdio>
#include<cstdlib>
#include<ctime>
#include<fstream>
#include<sstream>
#include<string>
#include<windows.h>
#include<vector>					//メモリ管理用

#include<direct.h>

#define _USE_MATH_DEFINES			//#include <math.h>の上に記述
#include <math.h>
#include "mt19937ar.h"

using namespace std;				//要検討

#include "main.h"
#include "make_xy_data.h"

/**********************************************************************/
// @ make_xy_data()   移動先データ出力
/**********************************************************************/
void make_xy_data(UINT8 buf_diffusion)
{
	vector<vector<SINT16>> xdata;
	vector<vector<SINT16>> ydata;
	UINT32 i, j;
	SINT64 buf_x, buf_y;

	char buf_name_x[30];
	char buf_name_y[30];

	try {
		xdata.resize(ACCUR, vector<SINT16>(ACCUR, 0));		//メモリ確保
		ydata.resize(ACCUR, vector<SINT16>(ACCUR, 0));		//メモリ確保
	}
	catch (...) {
		//エラー処理
		cout << "メモリ不足です。" << endl;
		exit(0);
	}

	_mkdir(Fo_CASH);										//cashフォルダ作成
	sprintf_s(buf_name_x, "%s/%d_%d_x.txt", Fo_CASH, ACCUR, buf_diffusion);
	sprintf_s(buf_name_y, "%s/%d_%d_y.txt", Fo_CASH, ACCUR, buf_diffusion);

	ifstream ifs(buf_name_x);								//dataファイル読み込み
	if (ifs.fail()) {
		ifs.close();
		cout << "CASHファイルが存在しません" << endl;
		cout << "CASHファイルを作成します" << endl;


		for (i = 0; i < ACCUR; i++) {
			for (j = 0; j < ACCUR; j++) {
				buf_x = buf_diffusion * sqrt(-2 * log(1.0 - i / (ACCUR*1.0 + 1))) * cos(2 * M_PI * (1.0 - j / (ACCUR*1.0 + 1)));	//1.0をかけているのは型変換のため
				buf_y = buf_diffusion * sqrt(-2 * log(1.0 - i / (ACCUR*1.0 + 1))) * sin(2 * M_PI * (1.0 - j / (ACCUR*1.0 + 1)));	//1.0をかけているのは型変換のため


				if (buf_x >= 0) {
					xdata[i][j] = (SINT16)(buf_x + 0.5);
				} else {
					xdata[i][j] = (SINT16)(buf_x - 0.5);
				}

				if (buf_y >= 0) {
					ydata[i][j] = (SINT16)(buf_y + 0.5);
				} else {
					ydata[i][j] = (SINT16)(buf_y - 0.5);
				}
			}
		}

		//ファイル作成
		ofstream ofs;
		ofs.open(buf_name_x, ios::out);								//ファイルを書きだす場所指定
		for (i = 0; i < ACCUR; i++) {
			for (j = 0; j < ACCUR; j++) {
				ofs << xdata[i][j] << ",";
			}
		}
		ofs.close();

		ofs.open(buf_name_y, ios::out);								//ファイルを書きだす場所指定
		for (i = 0; i < ACCUR; i++) {
			for (j = 0; j < ACCUR; j++) {
				ofs << ydata[i][j];
				ofs << ",";
			}
		}
		ofs.close();
	}
}