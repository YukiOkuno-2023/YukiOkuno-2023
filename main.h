#pragma once

#include<vector>					// メモリ管理用

// 定義
#define ON			1u 
#define OFF			0u

#define ACCUR		512			    // 計算精度

#define Fo_MAIN		"CELL_MODEL"	// 最上位folder
#define Fo_INPUT	"INPUT"		    // 設定値folder
#define Fo_CASH		"CASH"			// 一時folder
#define Fo_OUTPUT	"OUTPUT"		// 計算結果folder


// typedef定義
typedef unsigned char	UINT8;
typedef signed char		SINT8;
typedef unsigned short	UINT16;
typedef signed short	SINT16;
typedef unsigned int	UINT32;
typedef signed int		SINT32;
typedef double			SINT64;

typedef struct {						// 設定情報構造体
	SINT32 size;		// 一辺の長さ
	SINT32 cell_a;		// 全セル数
	SINT32 step_a;		// 全ステップ数
	SINT32 step_i;		// ステップ間隔
	SINT32 type_a;		// 個体種類数
	SINT32 robust;      // ロバストチェックフラグ
	SINT32 rob_step;    // 部分破壊するstep
	SINT32 breakL;      // 破壊する領域の一辺の大きさ
}CONFIGDATA;
typedef struct {							// 個体情報構造体
	SINT32 number;		// 初期個体数
	SINT32  target;		// 捕食対象
	SINT32  diffusion;	// 移動係数
	SINT32  try_move;	// 移動試行回数
	SINT32  m_life;		// 最大寿命
	SINT32  m_breed;	// 最大増殖時間
	SINT32  m_vanish;	// 最大消滅時間
	SINT32  m_react;	// 最大反応間隔      
}TYPEDATA;
typedef struct {						// セル情報構造体
	SINT32 type;		// 種類
	SINT32 r_life;		// 残寿命
	SINT32 r_breed;		// 残増殖時間
	SINT32 r_vanish;	// 残消滅時間
	SINT32 r_react;		// 残反応間隔
	SINT32 f_act;		// 行動済みフラグ
}CELLDATA;



// 変数定義

extern SINT32 step;										// 現在Step数定義
extern char calc_folder[255];							// 計算結果フォルダ名

extern vector<SINT32> array_t;							// 移動順格納配列定義
extern vector<vector<SINT32>> array_q;					// 個体数格納配列定義

extern CONFIGDATA cf;									// 設定データ定義
extern CELLDATA delete_cell;							// 空白Cellデータ定義

extern vector<vector<CELLDATA>> cell_data;				// Cellデータ定義
extern vector<TYPEDATA> type_data;						// 個体データ定義
extern vector<CELLDATA> newtype_cell;					// 新個体Cellデータ定義

extern vector<vector<vector<SINT32>>> d_array_x;		// 移動先格納配列定義
extern vector<vector<vector<SINT32>>> d_array_y;		// 移動先格納配列定義