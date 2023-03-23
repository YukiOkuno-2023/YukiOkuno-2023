% 漁場ごとにデータを分割
% 実行時間: 15s

tic;
Message = 'ReadTable2を実行します.';
disp(Message)

clear all;
close all;

Input = readcell('ReadTable.txt');

Name = cell2mat(Input(1,1));
TradingPlace = cell2mat(Input(2,1));

cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)

% 年ファイルを読み込み
FileID = fopen('Year.txt','r');
FormatSpec = '%d';
YearData = fscanf(FileID,FormatSpec);
fclose(FileID);

roop = size(YearData);  % 全データの行数
roop = roop(1,1);

% 月ファイルを読み込み
FileID = fopen('Month.txt','r');
FormatSpec = '%d';
MonthData = fscanf(FileID,FormatSpec);
fclose(FileID);

% 日ファイルの読み込み
DayData = readcell('Day.txt');

% 漁場ファイルを読み込み
PlaceData = readtable('Place.txt');
PlacePattern = unique(PlaceData);     % データ内に存在する漁場の一覧
PlaceN = size(PlacePattern);
PlaceN = PlaceN(1,1);                 % データ内に存在する漁場のパターン数
PlaceData = table2cell(PlaceData);    % tableをcell配列に変換 ヘッダーが無くなる
PlacePattern = table2cell(PlacePattern);

% 魚種ファイルを読み込み
SpieceData = readcell('Spieces.txt');

% 数量ファイルの読み込み
FileID = fopen('Mass.txt','r');
FormatSpec = '%f';  % %cは単一文字、%sは文字ベクトル %sと指定すると改行を読み取ることが出来ない
MassData = fscanf(FileID,FormatSpec);
fclose(FileID);

for a = 1:roop
    tf = isnan(MassData(a,1));
    if tf == 1
        MassData(a,1) = 0;
    end
end


% 各漁場でデータが何回出現するか(各漁場のデータ数)
n = zeros(PlaceN,1);

% 各漁場について構造体ごとに分類
for a = 1:roop
    for b = 1:PlaceN
        tf = strcmp(PlaceData(a,1),PlacePattern(b,1));  % cell配列の成分同士を比較 同じならT(1)、異なっていればF(0)を返す
            % b=2: 仁王、b=3: 垂水、b=4: 大根、b=5: 新瀬、b=6: 新網、b=7: 重根(環境によって異なる可能性が有る)
        if tf == 1
            
            n(b,1) = n(b,1) + 1;
            
            % 1つの配列を層に分けるよりも構造体を定義して構造体自体を層にした方がコストが低い
            EachPlace(b).Spieces(n(b,1),1) = SpieceData(a,1);
            EachPlace(b).Mass(n(b,1),1) = MassData(a,1);
            EachPlace(b).Year(n(b,1),1) = YearData(a,1);
            EachPlace(b).Month(n(b,1),1) = MonthData(a,1);
            EachPlace(b).Day(n(b,1),1) = DayData(a,1);
            % EachPlace(1):仁王 EachPlace(2):垂水 EachPlace(3):大根
            % EachPlace(4):新瀬 EachPlace(5):新網 EachPlace(6):重根(環境によって異なる可能性が有る)
        end
    end
end

mkdir '全漁場'

for i = 1:PlaceN
    tf = strcmp(PlacePattern(i,1),'0');
    if tf == 0   % 漁場データが空であるものは除外
        
        % ディレクトリ作成
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        mkdir(cell2mat(PlacePattern(i,1)))
        cd(cell2mat(PlacePattern(i,1)))
        
        EachPlace(i).Spieces = array2table(EachPlace(i).Spieces); % ReadTable3.mでは魚種データについてUniqueを使用するためtable型で読み込む
        writetable(EachPlace(i).Spieces,'LocalSpieces.txt')
        writematrix(EachPlace(i).Mass,'LocalMass.txt')
        writematrix(EachPlace(i).Year,'LocalYear.txt')
        writematrix(EachPlace(i).Month,'LocalMonth.txt')
        writecell(EachPlace(i).Day,'LocalDay.txt')
    end
end

cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)
cd 全漁場

SpieceData = array2table(SpieceData);  % ReadTable3.mでは魚種データについてUniqueを使用するためtable型で読み込む
writetable(SpieceData,'TotalSpieces.txt')
writematrix(MassData,'TotalMass.txt')
writematrix(YearData,'TotalYear.txt')
writematrix(MonthData,'TotalMonth.txt')
writecell(DayData,'TotalDay.txt')

cd C:\Users
cd(Name)
cd Documents\MATLAB

Message = 'ReadTable2 complete';
disp(Message)
toc;
