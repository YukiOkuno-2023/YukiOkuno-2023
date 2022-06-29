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
#include<vector>					//メモリ管理用

#include<direct.h>

#define _USE_MATH_DEFINES			//#include <math.h>の上に記述
#include <math.h>
#include "mt19937ar.h"

using namespace std;

#include "main.h"
#include "calc_prepar.h"


// 計算前処理
void calc_prepar(void)
{
	register SINT32 i, j;


	// 移動順格納配列更新
	for (i = 0; i < cf.cell_a; i++) {
		j = (SINT32)(genrand_real2()*(cf.cell_a - i)) + i;
		swap(array_t[i], array_t[j]);
	}
}
