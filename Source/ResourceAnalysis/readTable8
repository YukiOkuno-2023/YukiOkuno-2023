% 1来遊型の来遊開始時期と終了時期を求める
Flag2 = 0;
if min(Judge2) < 2 && max(Judge2) >= 12   % 年を跨いだ来遊が有る場合(1月にも12月にも来遊がある)
    endl = 0;
    for d = 1:36  % 旬毎に見ていく
        % 刻み幅は1, 1.35, 1.7, 2...なのでdは3を周期に異なる処理が必要になる
        % 現在注目している月以前のデータのみの行列を作成する
        
        Judge3_1 = Judge2 <= d./3 + 1 - 1/3 + 0.1;  % 1/3を公差とすると1.35以下の要素を見たいときに1.333以下の要素を見てしまう +0.1とすることで対応
        Judge3_1 = Judge2(Judge3_1);
        
        % 例えば1月に来遊が無い場合、上記のif文内で空の行列を格納してしまう
        % これを避けるために最後の行に0の行を追加する
        matrix = size(Judge3_1);
        Judge3_1(matrix(1,1)+1,1) = 0;
        
        if max(Judge3_1) == endl
            if Flag2 == 1
                break  % d=2,3を例に考えると、1.35以下の要素を取り出したときの最小値と1.7以下の要素を取り出したときの最小値が同じなら1.7ではすでに来遊が終了しているのでループを抜ける
            end
            Flag2 = 1;
        end
        endl = max(Judge3_1);
    end
    
    % 来遊開始月 break後ということはその月で来遊が途切れているのでdを用いて行列を分割可能
    Judge3_2 = Judge2 > d./3 + 1 - 1/3 + 0.1;
    Judge3_2 = Judge2(Judge3_2);
    
    start = min(Judge3_2);
    
else   % 年を跨いだ来遊が無い場合
    start = min(Judge2);
    endl = max(Judge2);
end

Season1 = int8((start - fix(start))*100);
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

if start == endl
    str1 = append(num2str(fix(start)),'月',Season1);
else
    str1 = append(num2str(fix(start)),'月',Season1,'～',num2str(fix(endl)),'月',Season2);
end
V(lines,1) = Directory(b,1);
V(lines,2) = num2cell(VisitNAVE);
V(lines,3) = cellstr(str1);
