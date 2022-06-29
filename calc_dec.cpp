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
#include "calc_dec.h"
#include "test_debug.h"


// 減算処理
int calc_dec(int i,int *now_x,int *now_y)
{
	// 対象Cell決定
	*now_x = array_t[i] % cf.size;
	*now_y = array_t[i] / cf.size;

	if (cell_data[*now_x][*now_y].type == 0) {
		// 対象Cell個体無し
		// Do Nothing
	} 
	else if (cell_data[*now_x][*now_y].f_act != 0) {
		// 対象Cell個体移動済み
		// Do Nothing
	}
	
	else {
		// 対象Cell個体あり

		// 残寿命経過処理
		if (type_data[cell_data[*now_x][*now_y].type - 1].target != 0) {
			// 捕食対象ありTypeは残寿命経過による消滅は無し
			// Do Nothing
		}
		else {
			// 捕食対象無しType
			cell_data[*now_x][*now_y].r_life = cell_data[*now_x][*now_y].r_life - 1;			// 寿命減算
			if (cell_data[*now_x][*now_y].r_life == 0) {
				cell_data[*now_x][*now_y] = delete_cell;								// 残寿命が0なら削除
			}
		}

		// 残消滅時間経過処理
		if (cell_data[*now_x][*now_y].type != 0 && type_data[cell_data[*now_x][*now_y].type - 1].target != 0) { // 奥野 9/26デリートされてないかどうか追加
			// 捕食対象ありTYPE
			cell_data[*now_x][*now_y].r_vanish = cell_data[*now_x][*now_y].r_vanish - 1;	// 飢餓時間減算
			if (cell_data[*now_x][*now_y].r_vanish == 0) {
				cell_data[*now_x][*now_y] = delete_cell;							// 飢餓時間0で削除
			}
		}
		else {
			// 捕食対象無しTypeは残消滅時間による消滅は無し
			// Do Nothing
		}

		// 増殖時間処理
		if (cell_data[*now_x][*now_y].type != 0 && cell_data[*now_x][*now_y].r_breed != 0) { // 奥野9/26 デリートされてないかどうか追加
			cell_data[*now_x][*now_y].r_breed = cell_data[*now_x][*now_y].r_breed - 1;		// 増殖時間-1
		}

		if (cell_data[*now_x][*now_y].type != 0) {
			cell_data[*now_x][*now_y].r_react = cell_data[*now_x][*now_y].r_react - 1; // 奥野9/26 捕食対象ありTypeのみ残反応時間をへらす
		}

	}
	return 0;
}
