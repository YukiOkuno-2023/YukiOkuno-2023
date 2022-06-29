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
#include "calc_main1.h"
#include "calc_dest.h"				// 移動先計算用
#include "test_debug.h"



// Main
void calc_main1(SINT32 now_x,SINT32 now_y)
{
	register SINT32 buf_type;
	register SINT32 buf_try_move;
	register SINT32 next_x, next_y;									// 移動先座標
	
	if (cell_data[now_x][now_y].type == 0) {
	// 対象Cell個体無し
	// Do Nothing
	} else if (cell_data[now_x][now_y].f_act != 0) {
		// 対象Cell個体移動済み
		// Do Nothing
	} else {
		
		// 対象Cell未行動個体あり
		buf_type = cell_data[now_x][now_y].type - 1;										// 対象個体種類代入
		buf_try_move = type_data[buf_type].try_move;										// 対象個体移動試行回数代入
		
		while (buf_try_move != 0) {
			buf_try_move = buf_try_move - 1;												// 移動試行回数-1
			
			calc_dest_1(&now_x, &now_y, &next_x, &next_y, &buf_type);						// 移動先計算処理

			if (cell_data[next_x][next_y].type == 0) {
				// 移動先が空
				if (cell_data[now_x][now_y].r_breed == 0) {
					// 増殖移動
					cell_data[now_x][now_y].r_breed = type_data[buf_type].m_breed;			// 残増殖時間更新
					cell_data[now_x][now_y].f_act = 1;										// 行動済みフラグON
					cell_data[next_x][next_y] = cell_data[now_x][now_y];					// Cellデータ移動
					cell_data[now_x][now_y] = newtype_cell[buf_type];						// 対象Cell新個体生成
				} else {
					// 非増殖移動
					cell_data[now_x][now_y].f_act = 1;										// 行動済みフラグON
					cell_data[next_x][next_y] = cell_data[now_x][now_y];					// Cellデータ移動
					cell_data[now_x][now_y] = delete_cell;									// 対象Cellデータ削除
				}
				break;
			
			} else if (cell_data[now_x][now_y].r_react < 0) {                               // 奥野7/5 react == 0から react < 0へ変更
				    
			  // 移動対象個体 捕食可能状態
				if (((type_data[buf_type].target) & (0x01u << (cell_data[next_x][next_y].type - 1))) != 0) {
					// 移動先個体 捕食可
					if (cell_data[now_x][now_y].r_breed == 0) {
						// 増殖移動
						cell_data[now_x][now_y].r_breed = type_data[buf_type].m_breed;		// 残増殖時間更新
						cell_data[now_x][now_y].r_vanish = type_data[buf_type].m_vanish;	// 残消滅時間更新
						cell_data[now_x][now_y].r_react = type_data[buf_type].m_react;		// 残反応時間更新
						cell_data[now_x][now_y].f_act = 1;									// 行動済みフラグON
						cell_data[next_x][next_y] = cell_data[now_x][now_y];				// Cellデータ移動
						cell_data[now_x][now_y] = newtype_cell[buf_type];					// 対象Cell新個体生成
					} else {
						// 非増殖移動
						cell_data[now_x][now_y].r_vanish = type_data[buf_type].m_vanish;	// 残消滅時間更新
						cell_data[now_x][now_y].r_react = type_data[buf_type].m_react;		// 残反応時間更新
						cell_data[now_x][now_y].f_act = 1;									// 行動済みフラグON
						cell_data[next_x][next_y] = cell_data[now_x][now_y];				// Cellデータ移動
						cell_data[now_x][now_y] = delete_cell;								// 対象Cellデータ削除
					}
					break;

				} else {
					// 移動先個体 捕食不可
					// Do Nothing
				}

			} else {
				// 移動不可
				// Do Nothing
			}
		}
			/**************追加7/3ここから********************/
		if (buf_try_move == 0 && cell_data[now_x][now_y].r_breed == 0) {
			cell_data[now_x][now_y].r_breed = 1;        /*繰り返し回数に達した場合、次のstep開始時に減算されないよう+1*/
		}
			/**************追加7/3ここまで********************/
	}
	
}
