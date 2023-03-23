% 水温の比較を行う

D1 = 0.5;  % 相対量 その年の最大漁獲量のn倍
D2 = 20; % 絶対量

cd C:\Users
cd(Name)
cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)
cd(cell2mat(PlacePattern(a,1)))
cd(cell2mat(Directory(b,1)))
cd Data

first = YearPatternL(1,1);
if first == 1900
    first = YearPatternL(2,1);
end

NoVisit7_4 = zeros(36,1);
NoVisit7_4N = zeros(36,1);

% 非来遊時の各月の水温の平均を算出
for v = 1:YearNL    
    if YearPatternL(v,1) ~= 1900   % 年データが空であるものを除外
        
        Catch = strcat(num2str(YearPatternL(v,1)),'.txt');  % ディレクトリを指定する文字列
        Mass = load(Catch); % 各年の月変動を読み込み
        
        error = size(WaterTemperature);  % インデックスのエラーを回避するために予めループ上限を決めておく
        error = error(1,1);
        cdn1 = 1;  % 水温データの中の年が記載しある場所の座標(行)
        Flag = 0;
        while Flag ~= 1
            tf = strcmp(WaterTemperature(cdn1,2),int2str(YearPatternL(v,1)));  % 現在
            if tf == 1
                Flag = 1;
                break
            end
            cdn1 = cdn1 + 1;
            if cdn1 > error  % エラー内容を表示
                disp(PlacePattern(a,1))
                disp(Directory(b,1))
                disp(YearPatternL(v,1))
                Message = '水温データ表に該当する年が存在しません.';
                disp(Message)
                break
            end
        end
        
        % 36ヶ月
        for k = 1:roop
            if (Mass(k,1) >= mx*D1 && Mass(k,1) >= D2)
                % Nothing
            else
                TF = isempty(str2num(WaterTemperature(cdn1,k+3)));
                if TF == 1
                else
                    NoVisit7_4(k,1) = NoVisit7_4(k,1) + str2num(WaterTemperature(cdn1,k+3));    % 各配列要素に来遊しているときの水温をスタック
                    NoVisit7_4N(k,1) = NoVisit7_4N(k,1) + 1;    % 各配列要素に来遊した回数をスタック
                end
            end
        end
    end
end

% 来遊していない場合の水温の各月平均
NoVistAVE = zeros(36,1);
for v = 1:roop
    NoVistAVE(v,1) = NoVisit7_4(v,1) ./ NoVisit7_4N(v,1);
end

Visit7_4 = 0;
Visit7_4N = 0;
% 来遊時の水温と非来遊時の水温の差をとる
for v = 1:YearNL
    if YearPatternL(v,1) ~= 1900
                
        Catch = strcat(num2str(YearPatternL(v,1)),'.txt');  % ディレクトリを指定する文字列
        Mass = load(Catch); % 各年の月変動を読み込み
        
        error = size(WaterTemperature);  % インデックスのエラーを回避するために予めループ上限を決めておく
        error = error(1,1);
        cdn1 = 1;  % 水温データの中の年が記載しある場所の座標(行)
        Flag = 0;
        while Flag ~= 1
            tf = strcmp(WaterTemperature(cdn1,2),int2str(YearPatternL(v,1)));  % 現在
            if tf == 1
                Flag = 1;
            end
            cdn1 = cdn1 + 1;
            if cdn1 > error  % エラー内容を表示
                disp(PlacePattern(a,1))
                disp(Directory(b,1))
                disp(YearPatternL(v,1))
                Message = 'error: 水温データ表に該当する年が存在しません.';
                disp(Message)
                break
            end
        end
        
        % 36ヶ月
        for k = 1:roop
            if (Mass(k,1) >= mx*D1 && Mass(k,1) >= D2)
                Visit7_4 = Visit7_4 + ( str2num(WaterTemperature(cdn1,k+3)) - NoVistAVE(k,1) );
                Visit7_4N = Visit7_4N + 1;
            end
        end
    end
end

Visit7_4 = round(Visit7_4 ./ Visit7_4N,2);
V(lines,4) = num2cell(Visit7_4);
