// 作成者		:奥野
// 作成日時		:2018/08/29

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
#include "calc_main2.h"
#include "calc_dest.h"				// 移動先計算用


// ロバスト処理
void calc_main2(void)
{
	int i, j;
	int startp, endp;                 // 破壊する領域の始点と終点の配列番号
	
	startp = (cf.size - cf.breakL) / 2 - 1;
	endp = startp + cf.breakL;

	for (i = startp; i < endp; i++) {
		for (j = startp; j < endp; j++) {
			cell_data[i][j] = delete_cell;
		}
	}
}
