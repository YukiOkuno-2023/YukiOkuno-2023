% 各魚種のデータを年毎に再整理
% 実行時間 60s

tic;
Message = 'ReadTable5を実行します.';
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

% 漁場ファイルを読み込み
PlaceData = readtable('Place.txt');
PlacePattern = unique(PlaceData);     % データ内に存在する漁場の一覧
PlaceN = size(PlacePattern);
PlaceN = PlaceN(1,1);                 % データ内に存在する漁場のパターン数
PlacePattern = table2cell(PlacePattern);


for a = 1:PlaceN
    tf = strcmp(PlacePattern(a,1),'0');
    if tf == 0
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        cd(cell2mat(PlacePattern(a,1)))
        
        % 年ファイルを読み込み ファイル作成用
        FileID = fopen('LocalYear.txt','r');
        FormatSpec = '%d';
        YearDataL = fscanf(FileID,FormatSpec);
        fclose(FileID);
        YearPatternL = unique(YearDataL);       % データ中に存在する年データの一覧 中身はソートしてくれている
        YearNL = size(YearPatternL);
        YearNL = YearNL(1,1);                   % データ中の年データのパターン数
        
        % ディレクトリ指定用ファイルの読み込み
        Directory = readcell('screening.txt');
        DirectoryN = size(Directory);
        DirectoryN = DirectoryN(1,1);
        
        for b = 1:DirectoryN
            cd C:\Users
            cd(Name)
            cd Documents\MATLAB
            cd(TradingPlace)
            cd(cell2mat(PlacePattern(a,1)))
            cd(cell2mat(Directory(b,1)))
            cd Data
            
            % 年ファイルを読み込み
            FileID = fopen('LocalYear.txt','r');
            FormatSpec = '%d';
            YearDataES = fscanf(FileID,FormatSpec);
            fclose(FileID);
            DataN = size(YearDataES);
            DataN = DataN(1,1);                   % 各魚種のデータの数
            
            % 月ファイルを読み込み
            FileID = fopen('LocalMonth.txt','r');
            FormatSpec = '%f';
            MonthDataES = fscanf(FileID,FormatSpec);
            fclose(FileID);
            
            % 数量ファイルの読み込み
            FileID = fopen('LocalMass.txt','r');
            FormatSpec = '%f';
            MassDataES = fscanf(FileID,FormatSpec);
            fclose(FileID);
            
            Month = [1; 1.35; 1.7 ; 2; 2.35; 2.7 ; 3; 3.35; 3.7 ; 4; 4.35; 4.7 ; 5; 5.35; 5.7 ; 6; 6.35; 6.7 ; 7; 7.35; 7.7 ; 8; 8.35; 8.7 ; 9; 9.35; 9.7 ; 10; 10.35; 10.7 ; 11; 11.35; 11.7 ; 12; 12.35; 12.7];
            for c = 1:YearNL
                Mass = zeros(36,1);
                for d = 1:DataN
                    if YearPatternL(c,1) == YearDataES(d,1) && YearPatternL(c,1) ~= 1900
                        for e = 1:36
                            if Month(e,1) == MonthDataES(d,1)
                                Mass(e,1) = MassDataES(d,1);
                            end
                        end
                    end
                end
                
                FileName = append(num2str(YearPatternL(c,1)),'.txt');
                writematrix(Mass,FileName)
            end
            
        end
        
    end
end


cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)
cd 全漁場

% 年ファイルを読み込み ファイル作成用
FileID = fopen('TotalYear.txt','r');
FormatSpec = '%d';
YearDataL = fscanf(FileID,FormatSpec);
fclose(FileID);
YearPatternL = unique(YearDataL);       % データ中に存在する年データの一覧 中身はソートしてくれている
YearNL = size(YearPatternL);
YearNL = YearNL(1,1);                   % データ中の年データのパターン数

% ディレクトリ指定用ファイルの読み込み
Directory = readcell('screening.txt');
DirectoryN = size(Directory);
DirectoryN = DirectoryN(1,1);

for b = 1:DirectoryN
    
    cd C:\Users
    cd(Name)
    cd Documents\MATLAB
    cd(TradingPlace)
    cd 全漁場
    cd(cell2mat(Directory(b,1)))
    cd Data
    
    % 年ファイルを読み込み
    FileID = fopen('TotalYear.txt','r');
    FormatSpec = '%d';
    YearDataES = fscanf(FileID,FormatSpec);
    fclose(FileID);
    DataN = size(YearDataES);
    DataN = DataN(1,1);                   % 各魚種のデータの数
    
    % 月ファイルを読み込み
    FileID = fopen('TotalMonth.txt','r');
    FormatSpec = '%f';
    MonthDataES = fscanf(FileID,FormatSpec);
    fclose(FileID);
    
    % 数量ファイルの読み込み
    FileID = fopen('TotalMass.txt','r');
    FormatSpec = '%f';
    MassDataES = fscanf(FileID,FormatSpec);
    fclose(FileID);
    
    Month = [1; 1.35; 1.7 ; 2; 2.35; 2.7 ; 3; 3.35; 3.7 ; 4; 4.35; 4.7 ; 5; 5.35; 5.7 ; 6; 6.35; 6.7 ; 7; 7.35; 7.7 ; 8; 8.35; 8.7 ; 9; 9.35; 9.7 ; 10; 10.35; 10.7 ; 11; 11.35; 11.7 ; 12; 12.35; 12.7];
    for c = 1:YearNL
        Mass = zeros(36,1);
        for d = 1:DataN
            if YearPatternL(c,1) == YearDataES(d,1)  && YearPatternL(c,1) ~= 1900
                for e = 1:36
                    if Month(e,1) == MonthDataES(d,1)
                        Mass(e,1) = MassDataES(d,1);
                    end
                end
            end
        end
        
        FileName = append(num2str(YearPatternL(c,1)),'.txt');
        writematrix(Mass,FileName)
    end
    
end

cd C:\Users
cd(Name)
cd Documents\MATLAB

Message = 'ReadTable5 complete';
disp(Message)
toc;

ReadTable6
