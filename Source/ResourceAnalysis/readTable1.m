% 漁場、魚種、年、旬が全て同じデータをマージ
% 実行時間: 1800s

tic;
Message = 'ReadTable1を実行します.';
disp(Message)
clear all;
close all;

Input = readcell('ReadTable.txt');

Name = cell2mat(Input(1,1));
TradingPlace = cell2mat(Input(2,1));

cd C:\Users
cd(Name)
cd Documents\MATLAB

Data= readtable('全データ.xlsx');

roop = size(Data);  % 全データのサイズ
roop = roop(1,1);   % 全データの行数

% table型は扱いづらいのでcell配列に変換
PlaceData = table2array(Data(:,2));  % 漁場
SpieceData = table2array(Data(:,3)); % 魚種
MassData = table2array(Data(:,4));  % 漁獲量
YearData = table2array(Data(:,5));   % 年
MonthData = table2array(Data(:,6));  % 月
DayData = table2array(Data(:,7));    % 旬

l = 0;
x = 200;  % 何行後ろまで検索するか

for a = 1:roop
    k = a + 1;
    m = a + x;
    c = k;
    for b = k:m
        if c <= roop-l  % インデックスが配列範囲を超えないように条件付け
            tf1 = strcmp(PlaceData(a,1),PlaceData(c,1));  % 漁場の判定
            tf2 = strcmp(SpieceData(a,1),SpieceData(c,1));  % 魚種の判定
            tf5 = strcmp(DayData(a,1),DayData(c,1));  % 旬の判定
            
            if (tf1 == 1 && tf2 == 1 && YearData(a,1) == YearData(c,1) && MonthData(a,1) == MonthData(c,1) && tf5 == 1)
                % YearDataとMonthDataはdouble型なのでstrcmpで比較するとF(0)が必ず返ってしまう
                MassData(a,1) = MassData(a,1) + MassData(c,1);  % a行目の漁獲量とb行目の漁獲量をマージ
                PlaceData(c,:) = [];  % c行目のデータを削除 []は行データまたは列データ全体を指すのでPlaceData(b,1) = [];とするとエラーが発生する
                SpieceData(c,:) = [];
                MassData(c,:) = [];
                YearData(c,:) = [];
                MonthData(c,:) = [];
                DayData(c,:) = [];
                
                c = c - 1;  % マージした後、次のループにおいては同じcを検索する必要があるため減算処理を行う
                l = l + 1;  % マージした回数 インデックスが配列範囲を超えないように調整する
            end
        end
        c = c + 1;
    end
end

mkdir(TradingPlace)
cd(TradingPlace)

PlaceData = array2table(PlaceData);    % ReadTable2.mでは漁場データについてUniqueを使用するためtable型で読み込む
% table型はcell型に変換する際、1行目が無くなる(ヘッダーと認識されて除外される)ため予めヘッダーを1行目に追加するためにtable型に変換しておく

writetable(PlaceData,'Place.txt')
writecell(SpieceData,'Spieces.txt')
writematrix(MassData,'Mass.txt')
writematrix(YearData,'Year.txt')
writematrix(MonthData,'Month.txt')
writecell(DayData,'Day.txt')

cd C:\Users
cd(Name)
cd Documents\MATLAB

Message = 'ReadTable1 complete';
disp(Message)
toc;
