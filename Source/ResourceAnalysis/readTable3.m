% 各漁場ごとのフォルダ内で各魚種のデータを作成
% 除外されるデータ: 10日間の内に一定以上の漁獲が一度も無かった魚種
%                 漁場データが0
%                 魚種データが0
%                 魚種データがその他、一山、皆物、雑、魚類、活魚
% 実行時間 430s

tic;
Message = 'ReadTable3を実行します.';
disp(Message)

clear all;
close all;

Input = readcell('ReadTable.txt');

Name = cell2mat(Input(1,1));
TradingPlace = cell2mat(Input(2,1));
Screening1 = cell2mat(Input(3,1));   % 25と入力すると、各漁場で10日間で過去に一度も25kgを超える漁獲が無かった種をスクリーニングする
Screening2 = cell2mat(Input(4,1));   % 100と入力すると、全漁場の累計で10日間で過去に一度も100kgを超える漁獲が無かった種をスクリーニングする


cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)

% 漁場ファイルを読み込み
PlaceData = readtable('Place.txt');
PlacePattern = unique(PlaceData);     % データ内に存在する漁場の一覧
PlaceN = size(PlacePattern);
PlaceN = PlaceN(1,1);                 % データ内に存在する漁場のパターン数
PlacePattern = table2cell(PlacePattern);

for a = 1:PlaceN
    
    clear EachSpiece
    
    cd C:\Users
    cd(Name)
    cd Documents\MATLAB
    cd(TradingPlace)
    
    tf = strcmp(PlacePattern(a,1),'0');
    if tf == 0
        
        cd(cell2mat(PlacePattern(a,1)))
        
        % 年ファイルを読み込み
        FileID = fopen('LocalYear.txt','r');
        FormatSpec = '%d';
        YearDataL = fscanf(FileID,FormatSpec);
        fclose(FileID);
        
        % 月ファイルを読み込み
        FileID = fopen('LocalMonth.txt','r');
        FormatSpec = '%d';
        MonthDataL = fscanf(FileID,FormatSpec);
        fclose(FileID);
        
        % 日ファイルの読み込み
        DayDataL = readcell('LocalDay.txt');
        
        % 魚種ファイルを読み込み
        SpieceDataL = readtable('LocalSpieces.txt');
        SpiecePatternL = unique(SpieceDataL);       % データ中に存在する魚種データの一覧
        SpieceNL = size(SpiecePatternL);
        SpieceNL = SpieceNL(1,1);                   % データ中の魚種データのパターン数
        SpieceDataL = table2cell(SpieceDataL);      % cell型に変換することでヘッダーを削除
        SpiecePatternL = table2cell(SpiecePatternL);
        
        % 数量ファイルの読み込み
        FileID = fopen('LocalMass.txt','r');
        FormatSpec = '%f';
        MassDataL = fscanf(FileID,FormatSpec);
        fclose(FileID);
        
        roop = size(YearDataL);
        roop = roop(1,1);  % ローカルの全データ数
        m = zeros(SpieceNL,1);  % 各魚種のデータ数のカウント
        
        for b = 1:roop
            for c = 1:SpieceNL
                tf1 = strcmp(SpiecePatternL(c,1),'その他');
                tf2 = strcmp(SpiecePatternL(c,1),'一山');
                tf3 = strcmp(SpiecePatternL(c,1),'皆物');
                tf4 = strcmp(SpiecePatternL(c,1),'雑');
                tf5 = strcmp(SpiecePatternL(c,1),'魚類');
                tf6 = strcmp(SpiecePatternL(c,1),'活魚');
                tf7 = strcmp(SpiecePatternL(c,1),'0');
                if (tf1 == 0 && tf2 == 0 && tf3 == 0 && tf4 == 0 && tf5 == 0 && tf6 == 0 && tf7 == 0)
                    
                    tf = strcmp(SpieceDataL(b,1),SpiecePatternL(c,1));
                    
                    if tf == 1
                        m(c,1) = m(c,1) + 1;
                        EachSpiece(c).Mass(m(c,1),1) = MassDataL(b,1);
                        EachSpiece(c).Year(m(c,1),1) = YearDataL(b,1);
                        
                        tf1 = strcmp(DayDataL(b,1),'上旬');
                        tf2 = strcmp(DayDataL(b,1),'中旬');
                        tf3 = strcmp(DayDataL(b,1),'下旬');
                        if tf1 == 1  % 上旬、中旬、下旬の情報を月データに組み込む
                            EachSpiece(c).Month(m(c,1),1) = MonthDataL(b,1);
                        elseif tf2 == 1
                            EachSpiece(c).Month(m(c,1),1) = MonthDataL(b,1) + 0.35;
                        elseif tf3 == 1
                            EachSpiece(c).Month(m(c,1),1) = MonthDataL(b,1) + 0.7;
                        end
                    end
                end
            end
        end
        
        % ディレクトリ作成
        i = 0;
        for b = 1:SpieceNL
            tf1 = strcmp(SpiecePatternL(b,1),'その他');
            tf2 = strcmp(SpiecePatternL(b,1),'一山');
            tf3 = strcmp(SpiecePatternL(b,1),'皆物');
            tf4 = strcmp(SpiecePatternL(b,1),'雑');
            tf5 = strcmp(SpiecePatternL(b,1),'魚類');
            tf6 = strcmp(SpiecePatternL(b,1),'活魚');
            tf7 = strcmp(SpiecePatternL(b,1),'0');
            if (tf1 == 0 && tf2 == 0 && tf3 == 0 && tf4 == 0 && tf5 == 0 && tf6 == 0 && tf7 == 0)
                if max(EachSpiece(b).Mass) >= Screening1
                    
                    i = i + 1;
                    
                    cd C:\Users
                    cd(Name)
                    cd Documents\MATLAB
                    cd(TradingPlace)
                    cd(cell2mat(PlacePattern(a,1)))
                    
                    SpiecePattern2(i,1) = SpiecePatternL(b,1); % スクリーニング後のディレクトリ指定用
                    
                    mkdir(cell2mat(SpiecePatternL(b,1)))
                    cd(cell2mat(SpiecePatternL(b,1)))
                    mkdir Data
                    cd Data
                    writematrix(EachSpiece(b).Mass,'LocalMass.txt')
                    writematrix(EachSpiece(b).Year,'LocalYear.txt')
                    writematrix(EachSpiece(b).Month,'LocalMonth.txt')
                end
            end
        end
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        cd(cell2mat(PlacePattern(a,1)))
        writecell(SpiecePattern2,'screening.txt')
        clear SpiecePattern2
    end 
end

% 全体のデータの処理

cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)
cd 全漁場

% 年ファイルを読み込み
FileID = fopen('TotalYear.txt','r');
FormatSpec = '%d';
YearDataL = fscanf(FileID,FormatSpec);
fclose(FileID);

% 月ファイルを読み込み
FileID = fopen('TotalMonth.txt','r');
FormatSpec = '%d';
MonthDataL = fscanf(FileID,FormatSpec);
fclose(FileID);

% 日ファイルの読み込み
DayDataL = readcell('TotalDay.txt');

% 魚種ファイルを読み込み
SpieceDataL = readtable('TotalSpieces.txt');
SpiecePatternL = unique(SpieceDataL);
SpieceNL = size(SpiecePatternL);
SpieceNL = SpieceNL(1,1);
SpieceDataL = table2cell(SpieceDataL);
SpiecePatternL = table2cell(SpiecePatternL);

% 数量ファイルの読み込み
FileID = fopen('TotalMass.txt','r');
FormatSpec = '%f';
MassDataL = fscanf(FileID,FormatSpec);
fclose(FileID);

roop = size(YearDataL);
roop = roop(1,1);
m = zeros(SpieceNL,1);

for b = 1:roop
    for c = 1:SpieceNL
        tf1 = strcmp(SpiecePatternL(c,1),'その他');
        tf2 = strcmp(SpiecePatternL(c,1),'一山');
        tf3 = strcmp(SpiecePatternL(c,1),'皆物');
        tf4 = strcmp(SpiecePatternL(c,1),'雑');
        tf5 = strcmp(SpiecePatternL(c,1),'魚類');
        tf6 = strcmp(SpiecePatternL(c,1),'活魚');
        tf7 = strcmp(SpiecePatternL(c,1),'0');
        if (tf1 == 0 && tf2 == 0 && tf3 == 0 && tf4 == 0 && tf5 == 0 && tf6 == 0 && tf7 == 0)
            
            tf = strcmp(SpieceDataL(b,1),SpiecePatternL(c,1));
            
            if tf == 1
                m(c,1) = m(c,1) + 1;
                EachSpiece(c).Mass(m(c,1),1) = MassDataL(b,1);
                EachSpiece(c).Year(m(c,1),1) = YearDataL(b,1);
                
                tf1 = strcmp(DayDataL(b,1),'上旬');
                tf2 = strcmp(DayDataL(b,1),'中旬');
                tf3 = strcmp(DayDataL(b,1),'下旬');
                if tf1 == 1  % 上旬、中旬、下旬の情報を月データに組み込む
                    EachSpiece(c).Month(m(c,1),1) = MonthDataL(b,1);
                elseif tf2 == 1
                    EachSpiece(c).Month(m(c,1),1) = MonthDataL(b,1) + 0.35;
                elseif tf3 == 1
                    EachSpiece(c).Month(m(c,1),1) = MonthDataL(b,1) + 0.7;
                end
            end
        end
    end
end

% ディレクトリ作成
i = 0;
for b = 1:SpieceNL
    tf1 = strcmp(SpiecePatternL(b,1),'その他');
    tf2 = strcmp(SpiecePatternL(b,1),'一山');
    tf3 = strcmp(SpiecePatternL(b,1),'皆物');
    tf4 = strcmp(SpiecePatternL(b,1),'雑');
    tf5 = strcmp(SpiecePatternL(b,1),'魚類');
    tf6 = strcmp(SpiecePatternL(b,1),'活魚');
    tf7 = strcmp(SpiecePatternL(b,1),'0');
    if (tf1 == 0 && tf2 == 0 && tf3 == 0 && tf4 == 0 && tf5 == 0 && tf6 == 0 && tf7 == 0)
        if max(EachSpiece(b).Mass) >= Screening2
            
            i = i + 1;
            
            cd C:\Users
            cd(Name)
            cd Documents\MATLAB
            cd(TradingPlace)
            cd 全漁場
            
            SpiecePattern2(i,1) = SpiecePatternL(b,1); % スクリーニング後のディレクトリ指定用
            
            mkdir(cell2mat(SpiecePatternL(b,1)))
            cd(cell2mat(SpiecePatternL(b,1)))
            mkdir Data
            cd Data
            writematrix(EachSpiece(b).Mass,'TotalMass.txt')
            writematrix(EachSpiece(b).Year,'TotalYear.txt')
            writematrix(EachSpiece(b).Month,'TotalMonth.txt')
        end
    end
end

cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)
cd 全漁場
writecell(SpiecePattern2,'screening.txt')

cd C:\Users
cd(Name)
cd Documents\MATLAB

Message = 'ReadTable3 complete';
disp(Message)
toc;
