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
#include "calc_dest.h"




// 移動先計算処理
void calc_dest_1(SINT32 *now_x, SINT32 *now_y, SINT32 *next_x, SINT32 *next_y, SINT32 *type)
{

	SINT64 rand_a, rand_b;
	SINT64 buf_x_1, buf_y_1;
	SINT32 buf_x_2, buf_y_2;

	rand_a = genrand_real1();									// genrand_real1()は0以上1以下の乱数　mt19937ar
	rand_b = genrand_real1();									// genrand_real1()は0以上1以下の乱数　mt19937ar

																// ボックスミュラー
	buf_x_1 = type_data[*type].diffusion * sqrt(-2 * log(rand_a)) * cos(2 * M_PI*rand_b);	// 変数a,bを使い正規乱数の計算
	buf_y_1 = type_data[*type].diffusion * sqrt(-2 * log(rand_a)) * sin(2 * M_PI*rand_b);	// 変数a,bを使い正規乱数の計算

	if (buf_x_1 >= 0) {
		buf_x_2 = (SINT32)(buf_x_1 + 0.5);
	} else {
		buf_x_2 = (SINT32)(buf_x_1 - 0.5);
	}

	if (buf_y_1 >= 0) {
		buf_y_2 = (SINT32)(buf_y_1 + 0.5);
	} else {
		buf_y_2 = (SINT32)(buf_y_1 - 0.5);
	}

	// 移動先決定
	buf_x_2 = (SINT32)(*now_x + buf_x_2);
	if (buf_x_2 >= 0) {
		*next_x = (SINT32)(buf_x_2 % cf.size);
	} else {
		while (buf_x_2 < 0) {
			buf_x_2 = buf_x_2 + cf.size;
		}
		*next_x = (SINT32)buf_x_2;
	}

	buf_y_2 = (SINT32)(*now_y + buf_y_2);
	if (buf_y_2 >= 0) {
		*next_y = (SINT32)(buf_y_2 % cf.size);
	} else {
		while (buf_y_2 < 0) {
			buf_y_2 = buf_y_2 + cf.size;
		}
		*next_y = (SINT32)buf_y_2;
	}
}
