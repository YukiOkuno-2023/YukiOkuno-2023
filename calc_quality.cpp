// ì¬Ò		:‰œ–ì
// ì¬“ú		:2018/09/21

#include<iostream>
#include<ctime>
#include<cstdio>
#include<cstdlib>
#include<ctime>
#include<fstream>
#include<sstream>
#include<string>
#include<windows.h>
#include<vector>					// ƒƒ‚ƒŠŠÇ——p

#include<direct.h>

#define _USE_MATH_DEFINES			// #include <math.h>‚Ìã‚É‹Lq
#include <math.h>
#include "mt19937ar.h"

using namespace std;

#include "main.h"
#include "calc_quality.h"

void calc_quality(void)   // ŒÂ‘Ì”‘ª’è
{
	register SINT32 x, y;

	for (x = 0; x < cf.size; x++) {
		for (y = 0; y < cf.size; y++) {

			// ŒÂ‘Ì”‘ª’è
			if (cell_data[x][y].type == 0) {
				// Do Nothing
			}
			else {
				array_q[cell_data[x][y].type - 1][step] += 1;
			}
		}
	}
}