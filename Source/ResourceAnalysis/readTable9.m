% 2来遊型の来遊開始時期と終了時期を求める
% 来遊の区切りが明確でない場合、精度が低くなるのでx(来遊回数を月ごとにスタックしたデータを格納)から低い値(来遊回数が少ないデータ)を取り除き、
% 再度Judge2(来遊している月の一覧)を定義

boundary = 0; % boundaryはバグチェック用
for k = 1:36
    if k == 1
        if x(36) < max(x)/5 && x(k+1) < max(x)/5
            x(x <= max(x)/5) = 0;
            boundary = k;
        end
    elseif k == 36
        if x(k-1) < max(x)/5 && x(1) < max(x)/5
            x(x <= max(x)/5) = 0;
            boundary = k;
        end
    else
        if x(k-1) < max(x)/5 && x(k+1) < max(x)/5
            x(x <= max(x)/5) = 0;
            boundary = k;
        end
    end
end

for k = 1:roop
    if k == 1
        if x(36,1) == 0 && x(35,1) == 0 && x(34,1) == 0 && x(k+1,1) == 0 && x(k+2,1) == 0 && x(k+3,1) == 0
            % 1ヶ月後まで漁獲が来遊が無い場合は来遊シーズンとは判定しない

        else
            if x(k,1) >= max(x)/5 && x(k,1) > 1
                i = i + 1;
                Judge2(i,1) = Month(k,1);
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

        else  % 前後1ヶ月以内に来遊が1度以上あり、且つ最も来遊した月の回数の5分の1以上来遊していれば来遊シーズンとして判断
            if x(k,1) >= max(x)/5 && x(k,1) > 1
                i = i + 1;
                Judge2(i,1) = Month(k,1);
            elseif x(k,1) > 0  % 最も来遊した月の回数の5分の1以上来遊していなくても前か後ろで来遊していればカウント
                if x(k-1,1) >= max(x)/5 || x(k-2,1) >= max(x)/5 || x(k-3,1) >= max(x)/5 || x(k+1,1) >= max(x)/5 || x(k+2,1) >= max(x)/5  || x(k+3,1) >= max(x)/5
                    i = i + 1;
                    Judge2(i,1) = Month(k,1);
                end
            end
        end
    end
end
                


if min(Judge2) < 2 && max(Judge2) >= 12   % 年を跨いだ来遊が有る場合(1月にも12月にも来遊がある)
    
    % 年末年始の来遊を処理
    % アルゴリズム
    % 来遊があった月の一覧データについて、n月m旬までとその後で区切った行列を作成する
    % n月m旬までのデータの中で来遊があった一番最後の月を隔離する
    % n月m+1旬で同じように隔離し、最も来遊が遅い月同士を比較する。異なっていればまだ来遊が続いており、同じであればn月m+1旬ではすでに来遊が終わっている
    % これ年を跨いだ来遊の最終月になる
    end1 = 0;
    start1 = 0;
    Flag3 = 0;
    for d = 1:36  % 旬毎に見ていく
        % 現在注目している月以前のデータのみの行列を作成する
        Judge3_1 = Judge2 <= d./3 + 1 - 1/3 + 0.1;  % 1/3を公差とすると1.35以下の要素を見たいときに1.333以下の要素を見てしまう +0.03とすることで対応
        Judge3_1 = Judge2(Judge3_1);
        
        % 空の行列にならないように後ろに0を追加
        matrix = size(Judge3_1);
        Judge3_1(matrix(1,1)+1,1) = 0;
        
        % 一度同じであればFlag2をonにする。更に次のループで最大値が同じであればbreakを実行。この操作によって1旬の空きなら同じ来遊として処理することが出来る
        if max(Judge3_1) == end1
            if Flag3 == 1
                break % 年始の来遊終了時期を記憶するためにbreak
            end
            Flag3 = 1;
        end
        end1 = max(Judge3_1);
    end

    % 年を跨いだ来遊の開始月の特定
    % 年始の最終来遊と同様の処理を行う。先ず12月下旬から順に行列を分割し、来遊があった最小月(つまり一後ろから年始に近い来遊月を検索)を隔離する
    % 次のループでも最小月が同じであればそこで来遊が途切れているのでそこが年を跨いだ来遊の開始月となる
    for e = 36:-1:1  % 旬毎に見ていく
        Judge3_1 = Judge2 >= e./3 + 1 - 1/3;  % 1/3を公差とすると1.35以上の要素を見たいときに1.333以上となる　よって以上を検索するときは補正が不要になる
        Judge3_1 = Judge2(Judge3_1);
        
        matrix = size(Judge3_1);
        Judge3_1(matrix(1,1)+1,1) = NaN;
        
        if min(Judge3_1) == start1
            break
        end
        start1 = min(Judge3_1);
    end
    
    Season1 = int8((start1 - fix(start1))*100);
    Season2 = int8((end1 - fix(end1))*100);
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
    
    if start1 == end1
        str1 = append(num2str(fix(start1)),'月',Season1);
    else
        str1 = append(num2str(fix(start1)),'月',Season1,'～',num2str(fix(end1)),'月',Season2);
    end
    
    
    % 春から秋の来遊を処理
    % 年始の来遊の最終がいつであるかがdにあり、年末の来遊の開始がeに入っている
    % そのため一年の来遊からd～eを区切ることで2回来遊のうちの1回を取り除くことが出来る。あとは区切った来遊の最小値と最大値がそれぞれ冬以外の来遊の開始月と終了月になる
    Judge3_2 = Judge2 > d./3 + 1 - 1/3;  % 年始の来遊を除去
    Judge3_2 = Judge2(Judge3_2);
    start2 = min(Judge3_2);
    
    Judge3_3 = Judge2 < e./3 + 1 - 1/3 + 0.1; % 年末の来遊を除去
    Judge3_3 = Judge2(Judge3_3);
    end2 = max(Judge3_3);
    
    Season1 = int8((start2 - fix(start2))*100);
    Season2 = int8((end2 - fix(end2))*100);
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
    
    if start2 == end2
        str2 = append(num2str(fix(start2)),'月',Season1);
    else
        str2 = append(num2str(fix(start2)),'月',Season1,'～',num2str(fix(end2)),'月',Season2);
    end
    
    str2 = append(str2,', ',str1);
    V(lines,1) = Directory(b,1);
    V(lines,2) = num2cell(VisitNAVE);
    V(lines,3) = cellstr(str2);
    
    
else % 年を跨いだ来遊が無い場合
    % 来遊月の一覧の中の最小値と最大値がそれぞれ1回目の来遊の開始月と2回目の来遊の終了月になる
    start1 = min(Judge2);
    end2 = max(Judge2);
    
    % 1月上旬から順に見て行き、次の来遊データが現在見ている来遊月+1以内であれば、つまり1カ月以内に来遊があれば次のループへ
    % 無ければそこで来遊が区切れているのでそのdを記録する
    % あとはdまでとd後で来遊月の一覧を分割し、前半の最大値が1回目の来遊の最終月で、後半の最小値が2回目の来遊の開始月となる
    for d = 1:36
        if d == 36
            break
        else
            if Judge2(d+1,1) <= Judge2(d,1) + 1.0
                % Nothing
            else
                break
            end
        end
    end
    
    end1 = Judge2(d,1);
    Judge4 = Judge2 > Judge2(d,1);
    Judge4 = Judge2(Judge4);
    start2 = min(Judge4);
    
    Season1 = int8((start1 - fix(start1))*100);
    Season2 = int8((end1 - fix(end1))*100);
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
    
    if start1 == end1
        str1 = append(num2str(fix(start1)),'月',Season1);
    else
        str1 = append(num2str(fix(start1)),'月',Season1,'～',num2str(fix(end1)),'月',Season2);
    end
    
    % エラー対策
    % 2来遊型でも間に1ヶ月以上空きが無い来遊の仕方をしていると2回目の来遊の開始月には空の行列が入ってしまう
    % そこで空の行列であれば来遊月が区切れていないため、最小値と最大値のみを返してエラーを回避する
    TF = isempty(start2);
    if TF == 1
        start2 = min(Judge2);
        end2 = max(Judge2);
        Season1 = int8((start2 - fix(start2))*100);
        Season2 = int8((end2 - fix(end2))*100);
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
        
        if start2 == end2
            str2 = append(num2str(fix(start2)),'月',Season1);
        else
            str2 = append(num2str(fix(start2)),'月',Season1,'～',num2str(fix(end2)),'月',Season2);
        end
        
        str2 = append(str1,', ',str2);
        V(lines,1) = Directory(b,1);
        V(lines,2) = num2cell(VisitNAVE);
        V(lines,3) = cellstr(str2);
        
    else
        Season1 = int8((start2 - fix(start2))*100);
        Season2 = int8((end2 - fix(end2))*100);
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
        
        if start2 == end2
            str2 = append(num2str(fix(start2)),'月',Season1);
        else
            str2 = append(num2str(fix(start2)),'月',Season1,'～',num2str(fix(end2)),'月',Season2);
        end
        
        str2 = append(str1,', ',str2);
        V(lines,1) = Directory(b,1);
        V(lines,2) = num2cell(VisitNAVE);
        V(lines,3) = cellstr(str2);
    end
end
