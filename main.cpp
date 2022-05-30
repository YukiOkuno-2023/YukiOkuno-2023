// 作成者		:奥野
// 作成日時		:2018/08/19

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
#include "mem_manage.h"				// メモリ管理
#include "file_manage.h"			// File管理
#include "data_out.h"				// 結果File出力
#include "make_type.h"				// 個体設定出力
#include "read_config.h"			// 設定値読込み
#include "read_type.h"				// 個体データ読込み
#include "calc_dest.h"				// 移動先計算用
#include "test_debug.h"				// Test Debug出力

#include "calc_init.h"				// 計算初期化処理

#include "calc_prepar.h"			// 計算前処理
#include "calc_quality.h"           // 個体数計算処理
#include "calc_main1.h"				// 計算MAIN処理
#include "calc_main2.h"             // ロバスト処理
#include "calc_dec.h"				// 計算後処理




// 関数定義
static void time_out(void);			// 時間測定処理


// 変数定義
SINT32 step = 0;								// 現在Step数定義
clock_t start_t, end_t;							// 時間計測変数定義
char calc_folder[255];							// 計算結果フォルダ名
vector<SINT32> array_t;							// 移動順格納配列定義
vector<vector<SINT32>> array_q;					// 個体数格納配列定義

CONFIGDATA cf;									// 設定データ定義
CELLDATA delete_cell = {};						// 空白Cellデータ定義

vector<vector<CELLDATA>> cell_data;				// Cellデータ定義
vector<TYPEDATA> type_data;						// 個体データ定義
vector<CELLDATA> newtype_cell;					// 新個体Cellデータ定義




// main関数
int main()
{
	int i,x,y;
	int nowx, nowy;                             // 移動対象の座標

	start_t = clock();							// 実行時間測定開始
	srand((UINT32)time(NULL));
	init_genrand((UINT32)time(NULL));			// メルセンヌツイスター初期化
	read_config();								// 計算設定値読み込み
	mem_manage();								// メモリ確保


//	while (1) {

		start_t = clock();							// 実行時間測定開始
//		make_type(15);								// データ変更
		read_type();								// 個体設定値読み込み

		fol_manage();								// BUF RESULT フォルダ作成 設定データコピー

		calc_init();								// 計算初期化処理
		//calc_quality();                           // 個体数の計算(初期値確認)
		data_out(0);								// 計算結果書き出し(初期状態)
		
		time_out();									// 経過時間出力


		// 計算開始
		for (step = 0; step < cf.step_a; step++) {
			calc_quality();
			calc_prepar();							// 計算前処理	

			if (cf.robust == 1) {
				// ロバスト処理有の時
				if (step == cf.rob_step - 1) {
					for (i = 0; i < cf.cell_a; i++) {       // 一個体ずつ処理

						calc_dec(i, &nowx, &nowy);          // 対象セル決定＆減算処理

						calc_main1(nowx, nowy);
						calc_main2();                       // 指定範囲を破壊

					}
				}
				else {
					for (i = 0; i < cf.cell_a; i++) {       // 一個体ずつ処理

						calc_dec(i, &nowx, &nowy);          // 対象セル決定＆減算処理

						calc_main1(nowx, nowy);

					}
				}
			}
			else {
				// ロバスト処理無しの時
				for (i = 0; i < cf.cell_a; i++) {         // 一個体ずつ処理

					calc_dec(i, &nowx, &nowy);            // 対象セル決定＆減算処理

					calc_main1(nowx, nowy);

				}
			}
		
			for (x = 0; x < cf.size; x++) {            // 全個体移動後に行動済みフラグを削除
				for (y = 0; y < cf.size; y++) {
					cell_data[x][y].f_act = 0;
				}
			}
			

			if (step % 10 == 0) {
				time_out();							// 経過時間出力
			}

			if (((step + 1) % cf.step_i) == 0) {
				data_out(0);						// 計算結果書き出し
			}

		}

		calc_quality();                             // 個体数の計算

		data_out(1);								// 個体数書き出し

		data_update();								// データ更新

//		compare_data();								// データ比較

		time_out();									// 経過時間出力
//	}
	return 0;
}

// 時間測定処理
static void time_out() {

	end_t = clock();
	cout << "進行状況 : " << step * 100.0 / cf.step_a << "％" << endl;
	cout << "処理時間 : " << (end_t - start_t) / 1000.0 << "秒" << endl;
	cout << endl;
}