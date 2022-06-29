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

using namespace std;				// 要検討

#include "main.h"
#include "calc_init.h"



// 初期化処理
void calc_init(void)
{
	register SINT32  buf_type;
	register SINT32 x, y;
	register SINT32 buf_number;
	register SINT32 i;

	// 移動順格納配列初期化
	for (i = 0; i < cf.cell_a; i++) {
		array_t[i] = i;
	}

	for (x = 0; x < cf.size; x++) {
		for (y = 0; y < cf.size; y++) {
			cell_data[x][y] = delete_cell;
		}
	}

	for (x = 0; x < cf.type_a; x++) {
		for (y = 0; y < cf.step_a + 1; y++) {
			array_q[x][y] = 0;
		}
	}


	// Cellデータ初期化
	for (buf_type = 0; buf_type < cf.type_a; buf_type++) {

		buf_number = type_data[buf_type].number;		// 初期個体数代入

		while (buf_number != 0) {
			// ランダムで個体代入対象Cell決定
			x = (SINT32)(genrand_real2()*cf.size);		// genrand_real2()は0以上1未満の乱数　mt19937ar
			y = (SINT32)(genrand_real2()*cf.size);		// genrand_real2()は0以上1未満の乱数　mt19937ar

			if (cell_data[x][y].type == 0) {
				// 対象Cellに個体代入
				cell_data[x][y].type = buf_type + 1;													// 種類代入
				cell_data[x][y].r_life = (SINT32)(genrand_real2()*type_data[buf_type].m_life) + 1;		// 残寿命代入
				cell_data[x][y].r_breed = (SINT32)(genrand_real2()*type_data[buf_type].m_breed) + 1;	// 残増殖時間代入
				cell_data[x][y].r_vanish = (SINT32)(genrand_real2()*type_data[buf_type].m_vanish) + 1;	// 残消滅時間代入
				cell_data[x][y].r_react = (SINT32)(genrand_real2()*type_data[buf_type].m_react) + 1;	// 残反応間隔代入

				buf_number = buf_number - 1;
			}
		}
	}
}
