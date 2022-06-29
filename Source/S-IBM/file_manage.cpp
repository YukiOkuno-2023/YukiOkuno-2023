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
#include "file_manage.h"


SINT64 last_type_count = 4;	// 最終種類数
SINT64 last_min_count = 0;	// 最小個体数

SINT64 now_type_count = 0;	// 最終種類数
SINT64 now_min_count = 0;	// 最小個体数



// フォルダ管理
void fol_manage() {

	char buf_name1[100];
	char buf_name2[100];
	char buf_name3[100];

	sprintf_s(buf_name3, Fo_OUTPUT);
	_mkdir(buf_name3);

	sprintf_s(calc_folder, "%s/BUF_RESULT", Fo_OUTPUT);
	_mkdir(calc_folder);

	// input_main.datコピー
	sprintf_s(buf_name1, "%s/input_main.dat", Fo_INPUT);
	sprintf_s(buf_name2, "%s/input_main.dat", calc_folder);	// ファイルを書きだす場所指定
	copy_file(buf_name1, buf_name2);

	// input_type.datコピー
	sprintf_s(buf_name1, "%s/input_type.dat", Fo_INPUT);
	sprintf_s(buf_name2, "%s/input_type.dat", calc_folder);	// ファイルを書きだす場所指定
	copy_file(buf_name1, buf_name2);
}


// ファイルコピー
void copy_file(char* src, char* dst)
{
	ifstream ifs;
	ofstream ofs;

	ifs.open(src);					// コピー元ファイルをオープン
	ofs.open(dst, ios::out);		// コピー先ファイルをオープン
									// エラーチェック
	if (!ifs || !ofs) {
		cout << "file open error\n";
		exit(0);
	}

	ofs << ifs.rdbuf() << flush;	// コピー
}



//データ更新
void data_update() {

	char buf_name0[100];

	//	char buf_name1[100];
	//	char buf_name2[100];

	char buf_name3[100];
	char buf_name4[100];
	char buf_name5[100];
	char buf_name6[100];

	char buf_name7[100];
	char buf_name8[100];
	char buf_name9[100];
	char buf_name10[100];

	// input_type.datコピー
	//sprintf_s(buf_name0, "%s/%d", Fo_RESULT, time(NULL));  //ファイル名を時間にする場合

															   /*水口変更　7/11 ファイル名をpredatarの増殖時間、飢餓時間に*/
	sprintf_s(buf_name0, "%s/%d-%d-%d-%d", Fo_OUTPUT, type_data[1].m_breed, type_data[1].m_vanish, type_data[2].m_breed, type_data[2].m_vanish);

	//	sprintf_s(buf_name1, "%s/input_type_master.dat", Fo_CONFIG);
	//	sprintf_s(buf_name2, "%s/input_type.dat", Fo_CONFIG);			// ファイルを書きだす場所指定

	sprintf_s(buf_name3, "%s/input_main.dat", calc_folder);
	sprintf_s(buf_name4, "%s/input_type.dat", calc_folder);
	sprintf_s(buf_name5, "%s/population.dat", calc_folder);
	sprintf_s(buf_name6, "%s/output.dat", calc_folder);

	sprintf_s(buf_name7, "%s/input_main.dat", buf_name0);
	sprintf_s(buf_name8, "%s/input_type.dat", buf_name0);
	sprintf_s(buf_name9, "%s/population.dat", buf_name0);
	sprintf_s(buf_name10, "%s/output.dat", buf_name0);

	//	copy_file(buf_name2, buf_name1);	// MASTERデータ書き換え

	// 更新用データ作成
	_mkdir(buf_name0);					// 計算結果フォルダ作成(POSIX時間)
	copy_file(buf_name3, buf_name7);	// 新規 input_main.dat 作成
	copy_file(buf_name4, buf_name8);	// 新規 input_type.dat 作成
	copy_file(buf_name5, buf_name9);	// 新規 population.dat   作成
	copy_file(buf_name6, buf_name10);	// 新規 output.dat     作成

										// フォルダ削除
	remove(buf_name3);
	remove(buf_name4);
	remove(buf_name5);
	remove(buf_name6);
}


// データ比較
void compare_data() {
	SINT32 i;


	char buf_name0[100];

	char buf_name1[100];
	char buf_name2[100];
	char buf_name3[100];
	char buf_name4[100];
	char buf_name5[100];
	char buf_name6[100];

	char buf_name7[100];
	char buf_name8[100];
	char buf_name9[100];
	char buf_name10[100];



	// input_type.datコピー
	sprintf_s(buf_name0, "%s/%lld", Fo_OUTPUT, time(NULL)); // 奥野8/29 %dだと警告

	sprintf_s(buf_name1, "%s/input_type_master.dat", Fo_INPUT);
	sprintf_s(buf_name2, "%s/input_type.dat", Fo_INPUT);			// ファイルを書きだす場所指定


	sprintf_s(buf_name3, "%s/input_main.dat", calc_folder);
	sprintf_s(buf_name4, "%s/input_type.dat", calc_folder);
	sprintf_s(buf_name5, "%s/population.dat", calc_folder);
	sprintf_s(buf_name6, "%s/output.dat", calc_folder);

	sprintf_s(buf_name7, "%s/input_main.dat", buf_name0);
	sprintf_s(buf_name8, "%s/input_type.dat", buf_name0);
	sprintf_s(buf_name9, "%s/population.dat", buf_name0);
	sprintf_s(buf_name10, "%s/output.dat", buf_name0);



	now_min_count = 0;
	now_type_count = 0;

	for (i = 0; i < cf.type_a; i++) {
		if (array_q[i][cf.step_a - 1] > 0) {
			// Type i が生存
			if (type_data[i].target == 0) {
				// Type i が被捕食者
				now_type_count++;
			} else {
				// Type i が捕食者
				now_type_count = now_type_count + 2;
			}

			now_min_count += sqrt(sqrt(array_q[i][cf.step_a - 1]));
		}
	}

	cout << "種類値" << "前回：" << last_type_count << endl;
	cout << "種類値" << "今回：" << now_type_count << endl;
	cout << "個体数" << "前回：" << last_min_count << endl;
	cout << "個体数" << "今回：" << now_min_count << endl;

	if (now_type_count > last_type_count) {
		// データ更新

		cout << endl;
		cout << "データ更新" << endl;
		cout << endl;

		last_min_count = now_min_count;
		last_type_count = now_type_count;

		copy_file(buf_name2, buf_name1);	// MASTERデータ書き換え
		_mkdir(buf_name0);					// 計算結果フォルダ作成(POSIX時間)
		copy_file(buf_name3, buf_name7);	// 新規 input_main.dat 作成
		copy_file(buf_name4, buf_name8);	// 新規 input_type.dat 作成
		copy_file(buf_name5, buf_name9);	// 新規 population.dat   作成
		copy_file(buf_name6, buf_name10);	// 新規 output.dat     作成


	} else if (now_type_count == last_type_count) {
		if (now_min_count >= last_min_count) {
			// データ更新
			cout << endl;
			cout << "データ更新" << endl;
			cout << endl;

			last_min_count = now_min_count;
			last_type_count = now_type_count;

			copy_file(buf_name2, buf_name1);	// MASTERデータ書き換え
			_mkdir(buf_name0);					// 計算結果フォルダ作成(POSIX時間)
			copy_file(buf_name3, buf_name7);	// 新規 input_main.dat 作成
			copy_file(buf_name4, buf_name8);	// 新規 input_type.dat 作成
			copy_file(buf_name5, buf_name9);	// 新規 population.dat   作成
			copy_file(buf_name6, buf_name10);	// 新規 output.dat     作成
		}

	} else {
		// Do Nothing
	}
	// フォルダ削除
	remove(buf_name3);
	remove(buf_name4);
	remove(buf_name5);
	remove(buf_name6);
}
