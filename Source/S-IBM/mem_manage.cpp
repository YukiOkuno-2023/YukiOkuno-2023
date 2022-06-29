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
#include "mem_manage.h"



// メモリ管理
void mem_manage() {

	try {
		cell_data.resize(cf.size, vector<CELLDATA>(cf.size, delete_cell));	// セルデータメモリ確保

		type_data.resize(cf.type_a);										// 個体データメモリ確保
		newtype_cell.resize(cf.type_a);										// 新個体Cellデータメモリ確保

		array_t.resize(cf.cell_a);											// 移動順格納配列メモリ確保
		array_q.resize(cf.type_a, vector<SINT32>(cf.step_a + 1, 0));		// 変更7/19 cf.step_a→cf.step_a+1

	}
	catch (...) {
		// エラー処理
		cout << "メモリ不足です。" << endl;
		exit(0);
	}
}
