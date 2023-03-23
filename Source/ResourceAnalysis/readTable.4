% 各魚種のデータの旬毎のデータを統合
% 実行時間 30s

tic;
Message = 'ReadTable4を実行します.';
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
    cd C:\Users
    cd(Name)
    cd Documents\MATLAB
    cd(TradingPlace)
    
    tf = strcmp(PlacePattern(a,1),'0');
    if tf == 0
        cd(cell2mat(PlacePattern(a,1)))
        
        % 魚種ファイルを読み込み
        SpiecePatternL = readcell('screening.txt');
        SpieceNL = size(SpiecePatternL);
        SpieceNL = SpieceNL(1,1);                   % データ中の魚種データのパターン数
        
        for b = 1:SpieceNL
            cd C:\Users
            cd(Name)
            cd Documents\MATLAB
            cd(TradingPlace)
            cd(cell2mat(PlacePattern(a,1)))
            cd(cell2mat(SpiecePatternL(b,1)))
            cd Data
            
            % 年ファイルを読み込み
            FileID = fopen('LocalYear.txt','r');
            FormatSpec = '%d';
            YearDataL = fscanf(FileID,FormatSpec);
            fclose(FileID);
            DataN = size(YearDataL);
            DataN = DataN(1,1);
            
            % 月ファイルを読み込み
            FileID = fopen('LocalMonth.txt','r');
            FormatSpec = '%f';
            MonthDataL = fscanf(FileID,FormatSpec);
            fclose(FileID);
            
            % 数量ファイルの読み込み
            FileID = fopen('LocalMass.txt','r');
            FormatSpec = '%f';
            MassDataL = fscanf(FileID,FormatSpec);
            fclose(FileID);
            
            marge = 0;
            for c = 1:DataN
                if (c + 1) < (DataN - marge)
                    for d = c+1:DataN
                        e = c + 1;
                        if YearDataL(c,1) == YearDataL(e,1) && MonthDataL(c,1) == MonthDataL(e,1)
                            MassDataL(c,1) = MassDataL(c,1) + MassDataL(e,1);
                            YearDataL(e,:) = [];
                            MonthDataL(e,:) = [];
                            MassDataL(e,:) = [];
                            e = e - 1;
                            marge = marge + 1;
                        end
                        e = e + 1;
                    end
                end
            end
            delete *.txt
            writematrix(YearDataL,'LocalYear.txt')
            writematrix(MonthDataL,'LocalMonth.txt')
            writematrix(MassDataL,'LocalMass.txt')
        end
        
    end
end


% 全漁場の累計データの処理

cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)
cd 全漁場


% 魚種ファイルを読み込み
SpiecePatternL = readcell('screening.txt');
SpieceNL = size(SpiecePatternL);
SpieceNL = SpieceNL(1,1);                   % データ中の魚種データのパターン数

for b = 1:SpieceNL
    cd C:\Users
    cd(Name)
    cd Documents\MATLAB
    cd(TradingPlace)
    cd 全漁場
    cd(cell2mat(SpiecePatternL(b,1)))
    cd Data
    
    % 年ファイルを読み込み
    FileID = fopen('TotalYear.txt','r');
    FormatSpec = '%d';
    YearDataL = fscanf(FileID,FormatSpec);
    fclose(FileID);
    
    % 月ファイルを読み込み
    FileID = fopen('TotalMonth.txt','r');
    FormatSpec = '%f';
    MonthDataL = fscanf(FileID,FormatSpec);
    fclose(FileID);
    
    % 数量ファイルの読み込み
    FileID = fopen('TotalMass.txt','r');
    FormatSpec = '%f';
    MassDataL = fscanf(FileID,FormatSpec);
    fclose(FileID);
    
    DataN = size(YearDataL);
    DataN = DataN(1,1);
    
    marge = 0;
    for c = 1:DataN
        if (c + 1) < (DataN - marge)
            for d = c+1:DataN
                e = c + 1;
                if YearDataL(c,1) == YearDataL(e,1) && MonthDataL(c,1) == MonthDataL(e,1)
                    MassDataL(c,1) = MassDataL(c,1) + MassDataL(e,1);
                    YearDataL(e,:) = [];
                    MonthDataL(e,:) = [];
                    MassDataL(e,:) = [];
                    e = e - 1;
                    marge = marge + 1;
                end
                e = e + 1;
            end
        end
    end
    delete *.txt
    writematrix(YearDataL,'TotalYear.txt')
    writematrix(MonthDataL,'TotalMonth.txt')
    writematrix(MassDataL,'TotalMass.txt')
end
        

cd C:\Users
cd(Name)
cd Documents\MATLAB

Message = 'ReadTable4 complete';
disp(Message)
toc;
