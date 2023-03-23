% 2来遊型の来遊開始時期と終了時期を求める
% ReadTable7_2を実行しただけでは来遊開始月と終了月が同じものが2つ出力される場合がある(例: {'6月中旬～12月中旬, 6月中旬～12月中旬'})
% これは来遊の区切りが曖昧になっているため この場合は多項式で近似し、その極値を境目とする

p = polyfit(Month,x,7);
y = polyval(p,Month);
Judge4 = islocalmin(y);  % 多項式近似の極小値がどこであるかをJudge4に格納
EndFlag1 = size(Judge4);
EndFlag1 = EndFlag1(1,1);
EndFlag2 = 0;
j = 1;
% 極小値の2番目(1番目は休漁期の2～3月になることが多いから)を抽出
while EndFlag2 ~= 2
    if j >= EndFlag1 - 1
        break;
    end
    if Judge4(j,1) == 1
        if EndFlag2 == 1
            Judge4 = j;
            EndFlag2 = 2;
            break;
        end
        EndFlag2 = 1;
    end
    j = j + 1;
end

mid = 0; % 極小値が1つしかない場合を検出するために0を予め格納しておく

% 極小値の2番目がある配列の番号を日付表記に変換
if rem(Judge4,3) == 1
    mid = (Judge4 + 2) / 3;
elseif rem(Judge4,3) == 2
    mid = (Judge4 + 1) / 3 + 0.35;
elseif rem(Judge4,3) == 0
    mid = Judge4 / 3 + 0.7;
end

% 極小値が1つしかない場合はエラーが発生してしまう
if mid == 0
    Judge4 = find(Judge4,1,'last');
    if rem(Judge4,3) == 1
        mid = (Judge4 + 2) / 3;
    elseif rem(Judge4,3) == 2
        mid = (Judge4 + 1) / 3 + 0.35;
    elseif rem(Judge4,3) == 0
        mid = Judge4 / 3 + 0.7;
    end
end

% 極小値の2番目を抽出してもうまくいかないことがある
% これは多項式の形の関係上発生するエラーで、このエラーを検出するために元の来遊月一覧の中に2番目の極小値のある月±1が含まれる場合はそのままで良いが、空の行列になるなら休漁期が2番目の極小値となってしまっていることがある
% この場合は最後の極小値を来遊の区切れ目として定義する
Judge5 = Judge2 > mid - 1;
Judge5 = Judge2(Judge5);
Judge6 = Judge5 < mid + 1;
Judge6 = Judge5(Judge6);

TF = isempty(Judge6);
if TF == 1
    Judge4 = islocalmin(y);
    Judge4 = find(Judge4,1,'last');
    if rem(Judge4,3) == 1
        mid = (Judge4 + 2) / 3;
    elseif rem(Judge4,3) == 2
        mid = (Judge4 + 1) / 3 + 0.35;
    elseif rem(Judge4,3) == 0
        mid = Judge4 / 3 + 0.7;
    end
end


if min(Judge2) < 2 && max(Judge2) >= 12   % 年を跨いだ来遊が有る場合(1月にも12月にも来遊がある)
    % 年末年始の来遊を処理
    % アルゴリズム
    % 来遊があった月の一覧データについて、n月m旬までとその後で区切った行列を作成する
    % n月m旬までのデータの中で来遊があった一番最後の月を隔離する
    % n月m+1旬で同じように隔離し、最も来遊が遅い月同士を比較する。異なっていればまだ来遊が続いており、同じであればn月m+1旬ではすでに来遊が終わっている
    % これ年を跨いだ来遊の最終月になる
    endl = 0;
    start2 = 0;
    Flag3 = 0;
    for d = 1:36  % 旬毎に見ていく
        % 現在注目している月以前のデータのみの行列を作成する
        Judge3_1 = Judge2 <= d./3 + 1 - 1/3 + 0.1;  % 1/3を公差とすると1.35以下の要素を見たいときに1.333以下の要素を見てしまう +0.03とすることで対応
        Judge3_1 = Judge2(Judge3_1);
        
        % 空の行列にならないように後ろに0を追加
        matrix = size(Judge3_1);
        Judge3_1(matrix(1,1)+1,1) = 0;
        
        % 一度同じであればFlag2をonにする。更に次のループで最大値が同じであればbreakを実行。この操作によって1旬の空きなら同じ来遊として処理することが出来る
        if max(Judge3_1) == endl
            if Flag3 == 1
                break % 年始の来遊終了時期を記憶するためにbreak
            end
            Flag3 = 1;
        end
        endl = max(Judge3_1);
    end
    Judge3_2 = Judge2 > d./3 + 1 - 1/3;  % 年始の来遊を除去
    Judge3_2 = Judge2(Judge3_2);
    start2 = min(Judge3_2);
    
    Season1 = int8((start2 - fix(start2))*100);
    Season2 = int8((mid - fix(mid))*100);
    if Season1 == 0
        Season1 = '上旬';
    elseif Season1 == 35
        Season1 = '中旬';
    elseif Season1 == 70
        Season1 = '下旬';
    end
    
    if Season2 == 0
        Season2 = '上旬';
    elseif Season2 == 35
        Season2 = '中旬';
    elseif Season2 == 70
        Season2 = '下旬';
    end
    
    if start2 == mid
        str1 = append(num2str(fix(start2)),'月',Season1);
    else
        str1 = append(num2str(fix(start2)),'月',Season1,'～',num2str(fix(mid)),'月',Season2);
    end
    
    Season1 = int8((mid - fix(mid))*100);
    Season2 = int8((endl - fix(endl))*100);
    if Season1 == 0
        Season1 = '上旬';
    elseif Season1 == 35
        Season1 = '中旬';
    elseif Season1 == 70
        Season1 = '下旬';
    end
    
    if Season2 == 0
        Season2 = '上旬';
    elseif Season2 == 35
        Season2 = '中旬';
    elseif Season2 == 70
        Season2 = '下旬';
    end
    
    if mid == endl
        str2 = append(num2str(fix(mid)),'月',Season1);
    else
        str2 = append(num2str(fix(mid)),'月',Season1,'～',num2str(fix(endl)),'月',Season2);
    end
    
    str2 = append(str1,', ',str2);
    V(lines,1) = Directory(b,1);
    V(lines,2) = num2cell(VisitNAVE);
    V(lines,3) = cellstr(str2);
    
% 年を跨いだ来遊が無い場合
else
    start2 = min(Judge2);
    endl = max(Judge2);
    
    Season1 = int8((start2 - fix(start2))*100);
    Season2 = int8((mid - fix(mid))*100);
    
    if Season1 == 0
        Season1 = '上旬';
    elseif Season1 == 35
        Season1 = '中旬';
    elseif Season1 == 70
        Season1 = '下旬';
    end
    
    if Season2 == 0
        Season2 = '上旬';
    elseif Season2 == 35
        Season2 = '中旬';
    elseif Season2 == 70
        Season2 = '下旬';
    end
    
    if start2 == mid
        str1 = append(num2str(fix(start2)),'月',Season1);
    else
        str1 = append(num2str(fix(start2)),'月',Season1,'～',num2str(fix(mid)),'月',Season2);
    end
    
    Season1 = int8((mid - fix(mid))*100);
    Season2 = int8((endl - fix(endl))*100);
    if Season1 == 0
        Season1 = '上旬';
    elseif Season1 == 35
        Season1 = '中旬';
    elseif Season1 == 70
        Season1 = '下旬';
    end
    
    if Season2 == 0
        Season2 = '上旬';
    elseif Season2 == 35
        Season2 = '中旬';
    elseif Season2 == 70
        Season2 = '下旬';
    end
    
    if mid == endl
        str2 = append(num2str(fix(mid)),'月',Season1);
    else
        str2 = append(num2str(fix(mid)),'月',Season1,'～',num2str(fix(endl)),'月',Season2);
    end
    
    str2 = append(str1,', ',str2);
    V(lines,1) = Directory(b,1);
    V(lines,2) = num2cell(VisitNAVE);
    V(lines,3) = cellstr(str2);
end
