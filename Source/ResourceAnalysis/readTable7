% 来遊のヒストグラムを作成
% 水温比較を行う

tic;
% 実行時間 270s
Message = 'ReadTable7を実行します.';
disp(Message)
% 実行時間: 1800s
clear all;
close all;

Input = readcell('ReadTable.txt');

Name = cell2mat(Input(1,1));
TradingPlace = cell2mat(Input(2,1));
Visit1 = cell2mat(Input(5,1));   % 来遊時期を判定する際に用いる相対量 0.5と入力するとその年の最大漁獲量の50%以上の漁獲があるとき来遊していると判断されるようになる
Visit1 = 1/Visit1;
Visit2 = cell2mat(Input(6,1));   % 来遊時期を判定する際に用いる絶対量 25と入力すると10日間の内に25kg以上の漁獲があるとき来遊していると判断されるようになる
Visit3 = cell2mat(Input(7,1));   % 来遊時期を判定する際に用いる相対量 0.5と入力するとその年の最大漁獲量の50%以上の漁獲があるとき来遊していると判断されるようになる
Visit3 = 1/Visit3;
Visit4 = cell2mat(Input(8,1));   % 来遊時期を判定する際に用いる絶対量 100と入力すると10日間の内に100kg以上の漁獲があるとき来遊していると判断されるようになる
extension = cell2mat(Input(12,1));   % 水温ファイルの拡張子


VisitN1 = 1.45; % この値を下回れば1回来遊 1.45
VisitN2 = 2.45; % この値を下回れば2回来遊


cd C:\Users
cd(Name)
cd Documents\MATLAB

str = append("水温データ.",extension);
WaterTemperature = readcell(str);
WaterTemperature = string(WaterTemperature);  % 検索を行うためにcell型からstring型に変換

cd(TradingPlace)

% 年ファイルを読み込み 水温データ整理用
FileID = fopen('Year.txt','r');
FormatSpec = '%d';
YearData = fscanf(FileID,FormatSpec);
fclose(FileID);
YearData(YearData == 1900) = NaN;   % YearDataのなかの1900をNaNとして扱う 中身を置き換えている訳ではない
start = min(YearData);   % 空のデータ(1900)がNaNとして扱われるので漁獲開始年を割り出せる
now = max(YearData);

% 漁場ファイルを読み込み
PlaceData = readtable('Place.txt');
PlacePattern = unique(PlaceData);     % データ内に存在する漁場の一覧
PlaceN = size(PlacePattern);
PlaceN = PlaceN(1,1);                 % データ内に存在する漁場のパターン数
PlacePattern = table2cell(PlacePattern);
PlacePattern(PlaceN+1,1) = cellstr('全漁場');
PlaceN = PlaceN + 1;

Month = [1; 1.35; 1.7 ; 2; 2.35; 2.7 ; 3; 3.35; 3.7 ; 4; 4.35; 4.7 ; 5; 5.35; 5.7 ; 6; 6.35; 6.7 ; 7; 7.35; 7.7 ; 8; 8.35; 8.7 ; 9; 9.35; 9.7 ; 10; 10.35; 10.7 ; 11; 11.35; 11.7 ; 12; 12.35; 12.7];

Excel = '来遊時期.xlsx';
Header = {'魚種名','来遊回数','来遊時期','来遊時期水温','来遊前水温(平均温度比)'};


for a = 1:PlaceN
% for a = 8:8  % バグチェック
V = {};
    tf = strcmp(PlacePattern(a,1),'0');
    if tf == 0

        cd C:\Users
        cd(Name)
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        
        lines = 1;
        writecell(PlacePattern(a,1),Excel,'Sheet',cell2mat(PlacePattern(a,1)),'Range','A1')
        writecell(Header,Excel,'Sheet',cell2mat(PlacePattern(a,1)),'Range','A2')
        
        cd(cell2mat(PlacePattern(a,1)))

        % 年ファイルを読み込み ループ回数用
        if a ~= PlaceN
            FileID = fopen('LocalYear.txt','r');
        else
            FileID = fopen('TotalYear.txt','r');
        end
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
        
        
        
        
%       DirectoryN = 1;  % バグチェック
        
      
      
        WT = 0;
        WTAV = 0;
        Prompt = 0;
        
        for b = 1:DirectoryN
%         for b = DirectoryN:DirectoryN  % バグチェック
            
            x = zeros(36,1);
            VisitN = 0;
            N = 0;
            Judge2 = zeros(36,1);
            Judge2(Judge2 == 0) = NaN;
            
            for c = 1:YearNL
                cd C:\Users
                cd(Name)
                cd Documents\MATLAB
                cd(TradingPlace)
                cd(cell2mat(PlacePattern(a,1)))
                cd(cell2mat(Directory(b,1)))
                cd Data
                
                Judge = zeros(36,1);
                Flag1 = 0;
                
                if YearPatternL(c,1) ~= 1900   % 年データが空であるものを除外

                    Catch = strcat(num2str(YearPatternL(c,1)),'.txt');  % ディレクトリを指定する文字列
                    Mass = load(Catch); % 各年の月変動を読み込み
                    mx = max(Mass);
                    roop = size(Mass);
                    roop = roop(1,1);
                    
                    % 基準を満たしているものを各月ごとにカウントアップ
                    for k = 1:roop
                        if (Mass(k,1) >= mx/Visit1 && Mass(k,1) >= Visit2)
                            x(k,1) = x(k,1) + 1;          % 来遊回数のカウント(全年)
                            Judge(k,1) = Judge(k,1) + 1;  % 来遊回数のカウント(1年のみ)
                            Flag1 = 1;                   % 来遊回数をカウントするためのフラグ
                        end
                    end
                    
                    % その魚種が累計で何回来遊しているかをカウント 間に1ヶ月間来遊が無い場合別の来遊として来遊回数の累計をカウントする
                    for k = 1:roop
                        if (Mass(k,1) >= mx/Visit1 && Mass(k,1) >= Visit2)
                            if k == 1
                                if Judge(36,1) == 0 && Judge(35,1) == 0 && Judge(34,1) == 0
                                    VisitN = VisitN + 1;
                                end
                            elseif k == 2
                                if Judge(k-1,1) == 0 && Judge(36,1) == 0 && Judge(35,1) == 0
                                    VisitN = VisitN + 1;
                                end
                            elseif k == 3
                                if Judge(k-1,1) == 0 && Judge(k-2,1) == 0 && Judge(36,1) == 0
                                    VisitN = VisitN + 1;
                                end
                            else
                                if Judge(k-1,1) == 0 && Judge(k-2,1) == 0 && Judge(k-3,1) == 0
                                    VisitN = VisitN + 1;
                                end
                            end
                        end
                    end
                    
                    if Flag1 == 1
                        N = N + 1;   % 来遊があった年の数　1年間当たりの来遊回数の平均を求める際に使用
                    end
                end
                
            end
            
            ymax = max(x)+1;
            bar(Month,x)
            ylim([0 ymax])
            xlim([1 12.9])
            xlabel('Month')
            ylabel('Frequency')
            xticks([1 2 3 4 5 6 7 8 9 10 11 12])
            xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})
            title([cell2mat(Directory(b,1)), ' '])
            cd C:\Users
            cd(Name)
            cd Documents\MATLAB
            cd(TradingPlace)
            cd(cell2mat(PlacePattern(a,1)))
            cd(cell2mat(Directory(b,1)))
            cd Figure
            FileName = append(Directory(b,1),' Histogram.jpg');
            saveas(gcf,cell2mat(FileName))
            
            % 来遊回数のカウントを再整理 その期間の来遊回数の過去累計が1回である場合、その月の1ヶ月以内に累計1回以下の来遊しかないものを無視する
            % 来遊回数が1回しか無い月しかない場合はこの処理は行わない
            if max(x) ~= 1
                for u = 1:36
                    if x(u,1) == 1
                        if u == 1
                            if x(36,1) < 1 && x(35,1) < 1 && x(34,1) < 1 && x(u+1,1) < 1 && x(u+2,1) < 1 && x(u+3,1) < 1
                                x(u,1) = 0;
                            end
                        elseif u == 2
                            if x(u-1,1) < 1 && x(36,1) < 1 && x(35,1) < 1 && x(u+1,1) < 1 && x(u+2,1) < 1 && x(u+3,1) < 1
                                x(u,1) = 0;
                            end
                        elseif u == 3
                            if x(u-1,1) < 1 && x(u-2,1) < 1 && x(36,1) < 1 && x(u+1,1) < 1 && x(u+2,1) < 1 && x(u+3,1) < 1
                                x(u,1) = 0;
                            end
                        elseif u == 36
                            if x(u-1,1) < 1 && x(u-2,1) < 1 && x(u-3,1) < 1 && x(1,1) < 1 && x(2,1) < 1 && x(3,1) < 1
                                x(u,1) = 0;
                            end
                        elseif u == 35
                            if x(u-1,1) < 1 && x(u-2,1) < 1 && x(u-3,1) < 1 && x(u+1,1) < 1 && x(1,1) < 1 && x(2,1) < 1
                                x(u,1) = 0;
                            end
                        elseif u == 34
                            if x(u-1,1) < 1 && x(u-2,1) < 1 && x(u-3,1) < 1 && x(u+1,1) < 1 && x(u+2,1) < 1 && x(1,1) < 1
                                x(u,1) = 0;
                            end
                        else
                            if x(u-1,1) < 1 && x(u-2,1) < 1 && x(u-3,1) < 1 && x(u+1,1) < 1 && x(u+2,1) < 1 && x(u+3,1) < 1
                                x(u,1) = 0;
                            end
                        end
                    end
                end
            end
            
            
            % 来遊回数の平均
            VisitNAVE = round(VisitN / N,3);
            
            count = 0;
            i = 0;
            % 累計の来遊回数が1回の場合とそうでない場合で分ける
            for l = 1:roop
                if x(l) ~= 0
                    count = count + 1;
                end
            end
            
            if count == 1 % 過去来遊が1回しか無い場合の処理
                for k = 1:roop
                    if x(k,1) > 0
                        i = i + 1;
                        Judge2(i,1) = Month(k,1);
                    end
                end
                
            else % 過去来遊が1回を超える場合の処理
                for k = 1:roop
                    if max(x) ~= 1  % 1回来遊を取り除くため最大が1回であるものとそうでない場合を分ける
                        if k == 1
                            if x(36,1) == 0 && x(35,1) == 0 && x(34,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                % 1ヶ月後まで漁獲が来遊が無い場合は来遊シーズンとは判定しない
                                
                            else
                                if x(k,1) >= max(x)/5 && x(k,1) > 1
                                    i = i + 1;
                                    Judge2(i,1) = Month(k,1);
                                elseif x(k,1) == 1 && x(36,1) == 0 && x(35,1) == 0 && x(34,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                    % 1回来遊且つ前後1ヶ月で来遊していない月は除外
                                elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても前後1ヶ月で来遊していればカウント
                                    if x(36,1) >= max(x)/5 || x(35,1) >= max(x)/5 || x(34,1) >= max(x)/5 || x(k+1,1) >= max(x)/5 || x(k+2,1) >= max(x)/5  || x(k+3,1) >= max(x)/5
                                        i = i + 1;
                                        Judge2(i,1) = Month(k,1);
                                    end
                                end
                            end
                            
                        elseif k == 2
                            if x(k-1,1) == 0 && x(36,1) == 0 && x(35,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                % 10日前と1ヶ月後まで漁獲が来遊が無い場合は来遊シーズンとは判定しない
                                
                            else
                                if x(k,1) >= max(x)/5 && x(k,1) > 1
                                    i = i + 1;
                                    Judge2(i,1) = Month(k,1);
                                elseif x(k,1) == 1 && x(k-1,1) == 0 && x(36,1) == 0 && x(35,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                    % 1回来遊且つ前後1ヶ月で来遊していない月は除外
                                elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても前か後ろで来遊していればカウント
                                    if x(k-1,1) >= max(x)/5 || x(36,1) >= max(x)/5 || x(35,1) >= max(x)/5 || x(k+1,1) >= max(x)/5 || x(k+2,1) >= max(x)/5  || x(k+3,1) >= max(x)/5
                                        i = i + 1;
                                        Judge2(i,1) = Month(k,1);
                                    end
                                end
                            end
                            
                        elseif k == 3
                            if x(k-1,1) == 0 && x(k-2,1) == 0 && x(36,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                % 20日前と1ヶ月後まで漁獲が来遊が無い場合は来遊シーズンとは判定しない
                                
                            else
                                if x(k,1) >= max(x)/5 && x(k,1) > 1
                                    i = i + 1;
                                    Judge2(i,1) = Month(k,1);
                                elseif x(k,1) == 1 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(36,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                    % 1回来遊且つ前後1ヶ月で来遊していない月は除外
                                elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても前か後ろで来遊していればカウント
                                    if x(k-1,1) >= max(x)/5 || x(k-2,1) >= max(x)/5 || x(36,1) >= max(x)/5 || x(k+1,1) >= max(x)/5 || x(k+2,1) >= max(x)/5  || x(k+3,1) >= max(x)/5
                                        i = i + 1;
                                        Judge2(i,1) = Month(k,1);
                                    end
                                end
                            end
                            
                        elseif k == 36
                            if x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(1,1) == 0 && x(2,1) == 0 && x(3,1) == 0
                                % 1ヶ月前まで漁獲が来遊が無い場合は来遊シーズンとは判定しない
                                
                            else
                                if x(k,1) >= max(x)/5 && x(k,1) > 1
                                    i = i + 1;
                                    Judge2(i,1) = Month(k,1);
                                elseif x(k,1) == 1 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(1,1) == 0 && x(2,1) == 0 && x(3,1) == 0
                                    % 1回来遊且つ前後1ヶ月で来遊していない月は除外
                                elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても前か後ろで来遊していればカウント
                                    if x(k-1,1) >= max(x)/5 || x(k-2,1) >= max(x)/5 || x(k-3,1) >= max(x)/5 || x(1,1) >= max(x)/5 || x(2,1) >= max(x)/5  || x(3,1) >= max(x)/5
                                        i = i + 1;
                                        Judge2(i,1) = Month(k,1);
                                    end
                                end
                            end
                            
                        elseif k == 35
                            if x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(1,1) == 0 && x(2,1) == 0
                                % 1ヶ月前まで漁獲が来遊が無い場合は来遊シーズンとは判定しない
                                
                            else
                                if x(k,1) >= max(x)/5 && x(k,1) > 1
                                    i = i + 1;
                                    Judge2(i,1) = Month(k,1);
                                elseif x(k,1) == 1 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(1,1) == 0 && x(2,1) == 0
                                    % 1回来遊且つ前後1ヶ月で来遊していない月は除外
                                elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても来遊回数が1回以上且つ前か後ろで来遊していればカウント
                                    if x(k-1,1) >= max(x)/5 || x(k-2,1) >= max(x)/5 || x(k-3,1) >= max(x)/5 || x(k+1,1) >= max(x)/5 || x(1,1) >= max(x)/5  || x(2,1) >= max(x)/5
                                        i = i + 1;
                                        Judge2(i,1) = Month(k,1);
                                    end
                                end
                            end
                            
                        elseif k == 34
                            if x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(1,1) == 0
                                % 1ヶ月前まで漁獲が来遊が無い場合は来遊シーズンとは判定しない
                                
                            else
                                if x(k,1) >= max(x)/5 && x(k,1) > 1
                                    i = i + 1;
                                    Judge2(i,1) = Month(k,1);
                                elseif x(k,1) == 1 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(1,1) == 0
                                    % 1回来遊且つ前後1ヶ月で来遊していない月は除外
                                elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても前か後ろで来遊していればカウント
                                    if x(k-1,1) >= max(x)/5 || x(k-2,1) >= max(x)/5 || x(k-3,1) >= max(x)/5 || x(k+1,1) >= max(x)/5 || x(k+2,1) >= max(x)/5  || x(1,1) >= max(x)/5
                                        i = i + 1;
                                        Judge2(i,1) = Month(k,1);
                                    end
                                end
                            end
                            
                        else
                            if x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                % 前後に1ヶ月間漁獲が来遊が無い場合は来遊シーズンとは判定しない
                                
                            else  % 前後1ヶ月以内に来遊が2度以上あり、且つ最も来遊した月の回数の5分の1以上来遊していれば来遊シーズンとして判断
                                if x(k,1) >= max(x)/5 && x(k,1) > 1
                                    i = i + 1;
                                    Judge2(i,1) = Month(k,1);
                                elseif x(k,1) == 1 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                                    % 1回来遊且つ前後1ヶ月で来遊していない月は除外
                                elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても前か後ろで来遊していればカウント
                                    if x(k-1,1) >= max(x)/5 || x(k-2,1) >= max(x)/5 || x(k-3,1) >= max(x)/5 || x(k+1,1) >= max(x)/5 || x(k+2,1) >= max(x)/5  || x(k+3,1) >= max(x)/5
                                        i = i + 1;
                                        Judge2(i,1) = Month(k,1);
                                    end
                                end
                            end
                        end
                    
                    % 来遊回数の最大が1回の場合
                    else
                        if k == 1
                            if x(k,1) ~= 0 && x(36,1) == 0 && x(35,1) == 0 && x(34,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                            elseif x(k,1) == 1
                                i = i + 1;
                                Judge2(i,1) = Month(k,1);
                            end
                            
                        elseif k == 2
                            if x(k,1) ~= 0 && x(k-1,1) == 0 && x(36,1) == 0 && x(35,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                            elseif x(k,1) == 1
                                i = i + 1;
                                Judge2(i,1) = Month(k,1);
                            end
                            
                        elseif k == 3
                            if x(k,1) ~= 0 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(36,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                            elseif x(k,1) == 1
                                i = i + 1;
                                Judge2(i,1) = Month(k,1);
                            end
                            
                        elseif k == 36
                            if x(k,1) ~= 0 && x(k,1) ~= 0 && x(k,1) == 1 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(1,1) == 0 && x(2,1) == 0 && x(3,1) == 0
                            elseif x(k,1) == 1
                                i = i + 1;
                                Judge2(i,1) = Month(k,1);
                            end
                            
                        elseif k == 35
                            if x(k,1) ~= 0 && x(k,1) == 1 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(1,1) == 0 && x(2,1) == 0
                            elseif x(k,1) == 1
                                i = i + 1;
                                Judge2(i,1) = Month(k,1);
                            end
                            
                        elseif k == 34
                            if x(k,1) ~= 0 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(1,1) == 0
                            elseif x(k,1) == 1
                                i = i + 1;
                                Judge2(i,1) = Month(k,1);
                            end
                            
                        else
                            if x(k,1) ~= 0 && x(k-1,1) == 0 && x(k-2,1) == 0 && x(k-3,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
                            elseif x(k,1) == 1
                                i = i + 1;
                                Judge2(i,1) = Month(k,1);
                            end
                        end
                    end
                end
            end
            
            % 1来遊型の処理
            if VisitNAVE < VisitN1
                ReadTable7_1
                
            % 2来遊型の処理
            elseif VisitN1 <= VisitNAVE && VisitNAVE < VisitN2
                
                ReadTable7_2
                
                if start1 == start2 && end1 == end2 || start1 == end1 || start2 == end2
                    
                    lines = lines - 1;  % ReadTable7_2でlinesをすでにインクリメントしており、ReadTable7_3でもするため同じ魚種でのカウントが重複する
                    ReadTable7_3
                    
                end
            end
            
            % 水温比較
            ReadTable7_4
            
            V % バグチェック
            lines = lines + 1;
        end
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        xlswrite(Excel,V,cell2mat(PlacePattern(a,1)),'A3')

    end
end

cd C:\Users
cd(Name)
cd Documents\MATLAB

Message = 'ReadTable7 complete';
disp(Message)
toc;
