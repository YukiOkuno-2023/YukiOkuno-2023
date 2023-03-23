% フーリエ近似、多項式近似を出力
% 年データが空である場合は除外している
% 

tic;
Message = 'ReadTable6を実行します.';
disp(Message)
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
Fourier = cell2mat(Input(9,1));
FolderName1 = append("Fourier Series Approximation(", num2str(Fourier), ")");
Fourier = append("fourier", num2str(Fourier));
Polynomial = cell2mat(Input(10,1));
FolderName2 = append("Polynomial Approximation(", num2str(Polynomial), ")");
Output = cell2mat(Input(11,1));    % 1:フーリエ近似のみ、2:多項式近似のみ、3:データ点、4:フーリエ近似+データ点、5:多項式近似+データ点、6:全てプロット

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

Month = [1; 1.35; 1.7 ; 2; 2.35; 2.7 ; 3; 3.35; 3.7 ; 4; 4.35; 4.7 ; 5; 5.35; 5.7 ; 6; 6.35; 6.7 ; 7; 7.35; 7.7 ; 8; 8.35; 8.7 ; 9; 9.35; 9.7 ; 10; 10.35; 10.7 ; 11; 11.35; 11.7 ; 12; 12.35; 12.7];

for a = 1:PlaceN
    tf = strcmp(PlacePattern(a,1),'0');
    if tf == 0
        cd C:\Users
        cd(Name)
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        cd(cell2mat(PlacePattern(a,1)))

        % 年ファイルを読み込み ループ回数用
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

            % 数量ファイルの読み込み axis用
            FileID = fopen('LocalMass.txt','r');
            FormatSpec = '%f';
            MassDataES = fscanf(FileID,FormatSpec);
            fclose(FileID);
            labelES = max(MassDataES);

            cd C:\Users
            cd(Name)
            cd Documents\MATLAB
            cd(TradingPlace)
            cd(cell2mat(PlacePattern(a,1)))
            cd(cell2mat(Directory(b,1)))
            mkdir Figure
            cd Figure
            if Output == 1 || Output == 4 || Output == 6
                mkdir(FolderName1)
            end
            if Output == 2 || Output == 5 || Output == 6
                mkdir(FolderName2)
            end

            for c = 1:YearNL
                cd C:\Users
                cd(Name)
                cd Documents\MATLAB
                cd(TradingPlace)
                cd(cell2mat(PlacePattern(a,1)))
                cd(cell2mat(Directory(b,1)))
                cd Data

                if num2str(YearPatternL(c,1)) ~= 1900   % 年データが空であるものを除外

                    Catch = strcat(num2str(YearPatternL(c,1)),'.txt');  % ディレクトリを指定する文字列
                    Fitting = load(Catch);
                    
                    if Output == 1 || Output == 4 || Output == 6
                        F = fit(Month, Fitting, Fourier);  % curving toolboxのアドオンのインストールが必要
                    end
                    
                    if Output == 2 || Output == 5 || Output == 6
                        P = polyfit(Month, Fitting, Polynomial);
                        X = linspace(1,12.9);
                        Y = polyval(P,X);
                    end
                    
                    if Output == 1 || Output == 4 || Output == 6
                    % 各年のデータ点とフーリエ近似を重ねて表示
                        figure(1)
                        plot(F,Month,Fitting,'o')
                        ylim([0 labelES*1.05 + 1])  % +1が無いと全て0のデータでバグが発生する
                        xlim([1 12.9])
                        legend('Data','Fitted Curve(Fourier)')
                        xlabel('Month')
                        ylabel('Catch')
                        title([cell2mat(Directory(b,1)), num2str(YearPatternL(c,1)), ' '])
                        xticks([1 2 3 4 5 6 7 8 9 10 11 12])
                        xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})  % xtickに対応する場所に任意の文字を当てはめる
                        hold off
                        
                        cd C:\Users
                        cd(Name)
                        cd Documents\MATLAB
                        cd(TradingPlace)
                        cd(cell2mat(PlacePattern(a,1)))
                        cd(cell2mat(Directory(b,1)))
                        cd Figure
                        cd(FolderName1)
                        
                        FileName = append(cell2mat(Directory(b,1))," ",num2str(YearPatternL(c,1)),".jpg");
                        saveas(gcf,FileName)
                    end
                    
                    % 各年のデータ点と多項式近似を重ねて表示
                    if Output == 2 || Output == 5 || Output == 6
                        figure(2)
                        plot(Month,Fitting,'o')
                        hold on
                        plot(X,Y)
                        ylim([0 labelES*1.05 + 1])  % +1が無いと全て0のデータでバグが発生する
                        xlim([1 12.9])
                        legend('Data','Fitted Curve(Polynomial)')
                        xlabel('Month')
                        ylabel('Catch')
                        title([cell2mat(Directory(b,1)), num2str(YearPatternL(c,1)), ' '])
                        xticks([1 2 3 4 5 6 7 8 9 10 11 12])
                        xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})  % xtickに対応する場所に任意の文字を当てはめる
                        hold off
                        
                        cd C:\Users
                        cd(Name)
                        cd Documents\MATLAB
                        cd(TradingPlace)
                        cd(cell2mat(PlacePattern(a,1)))
                        cd(cell2mat(Directory(b,1)))
                        cd Figure
                        cd(FolderName2)
                        
                        FileName = append(cell2mat(Directory(b,1))," ",num2str(YearPatternL(c,1)),".jpg");
                        saveas(gcf,FileName)
                    end

                    % 全年のデータ点とフーリエ近似を重ねて表示
                    if Output == 1 || Output == 4 || Output == 6
                        figure(3)
                        plot(F,Month,Fitting,'o')
                        hold on
                    end

                    % 全年のデータ点と多項式近似を重ねて表示
                    if Output == 2 || Output == 5 || Output == 6
                        figure(4)
                        plot(X,Y)
                        hold on
                        plot(Month,Fitting,'o')
                    end

                    DataSide = size(Fitting);
                    DataSize = DataSide(1,1);
                    
                    if Output == 3 || Output == 4 || Output == 5 || Output == 6
                        for d = 1:DataSize
                            % 来遊しているデータ点を赤色の〇で表示
                            figure(5)
                            if (Fitting(d,1) >= max(Fitting)/Visit1 && Fitting(d,1) >= Visit2)
                                plot(Month(d,1),Fitting(d,1),'or')
                                hold on
                            else
                                plot(Month(d,1),Fitting(d,1),'ob')
                                hold on
                            end
                        end
                    end
                end
            end
            
            if Output == 1 || Output == 4 || Output == 6
                figure(3)
                xlim([1 12.9])
                ylim([0 labelES*1.1])
                xlabel('Month')
                ylabel('Catch')
                title([cell2mat(Directory(b,1)), ' '])
                xticks([1 2 3 4 5 6 7 8 9 10 11 12])
                xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})
                legend('off')
                
                cd C:\Users
                cd(Name)
                cd Documents\MATLAB
                cd(TradingPlace)
                cd(cell2mat(PlacePattern(a,1)))
                cd(cell2mat(Directory(b,1)))
                cd Figure
                cd(FolderName1)
                
                FileName = append(cell2mat(Directory(b,1))," Fitting(Fourier).jpg");
                saveas(gcf,FileName)
                clf('reset')
            end
            
            if Output == 2 || Output == 5 || Output == 6
                figure(4)
                xlim([1 12.9])
                ylim([0 labelES*1.1])
                xlabel('Month')
                ylabel('Catch')
                title([cell2mat(Directory(b,1)), ' '])
                xticks([1 2 3 4 5 6 7 8 9 10 11 12])
                xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})
                legend('off')
                
                cd C:\Users
                cd(Name)
                cd Documents\MATLAB
                cd(TradingPlace)
                cd(cell2mat(PlacePattern(a,1)))
                cd(cell2mat(Directory(b,1)))
                cd Figure
                cd(FolderName2)
                
                FileName = append(cell2mat(Directory(b,1))," Fitting(Polynomial).jpg");
                saveas(gcf,FileName)
                clf('reset')
            end
            
            if Output == 3 || Output == 4 || Output == 5 || Output == 6
                figure(5)
                xlim([1 12.9])
                ylim([0 labelES*1.1])
                xlabel('Month')
                ylabel('Catch')
                title([cell2mat(Directory(b,1)), ' '])
                xticks([1 2 3 4 5 6 7 8 9 10 11 12])
                xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})
                legend('off')
                saveas(gcf,cell2mat(Directory(b,1)),'jpg')
                
                cd C:\Users
                cd(Name)
                cd Documents\MATLAB
                cd(TradingPlace)
                cd(cell2mat(PlacePattern(a,1)))
                cd(cell2mat(Directory(b,1)))
                cd Figure
                saveas(gcf,cell2mat(Directory(b,1)),'jpg')
                clf('reset')
            end
        end
    end
end




% 全漁場の累計のデータを処理

cd C:\Users
cd(Name)
cd C:\Users
cd(Name)
cd Documents\MATLAB
cd(TradingPlace)
cd 全漁場

% 年ファイルを読み込み ループ回数用
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
    
    % 数量ファイルの読み込み axis用
    FileID = fopen('TotalMass.txt','r');
    FormatSpec = '%f';
    MassDataES = fscanf(FileID,FormatSpec);
    fclose(FileID);
    labelES = max(MassDataES);
    
    cd C:\Users
    cd(Name)
    cd Documents\MATLAB
    cd(TradingPlace)
    cd 全漁場
    cd(cell2mat(Directory(b,1)))
    mkdir Figure
    cd Figure
    mkdir(FolderName1)
    mkdir(FolderName2)
    
    for c = 1:YearNL
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        cd 全漁場
        cd(cell2mat(Directory(b,1)))
        cd Data
        
        if num2str(YearPatternL(c,1)) ~= 1900   % 年データが空であるものを除外
            
            Catch = strcat(num2str(YearPatternL(c,1)),'.txt');  % ディレクトリを指定する文字列
            Fitting = load(Catch);
            
            F = fit(Month, Fitting, Fourier);  % curving toolboxのアドオンのインストールが必要
            P = polyfit(Month, Fitting, Polynomial);
            X = linspace(1,12.9);
            Y = polyval(P,X);
            
            % 各年のデータ点とフーリエ近似を重ねて表示
            if Output == 1 || Output == 4 || Output == 6
                figure(1)
                plot(F,Month,Fitting,'o')
                ylim([0 labelES*1.05 + 1])  % +1が無いと全て0のデータでバグが発生する
                xlim([1 12.9])
                legend('Data','Fitted Curve(Fourier)')
                xlabel('Month')
                ylabel('Catch')
                title([cell2mat(Directory(b,1)), num2str(YearPatternL(c,1)), ' '])
                xticks([1 2 3 4 5 6 7 8 9 10 11 12])
                xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})  % xtickに対応する場所に任意の文字を当てはめる
                hold off
                
                cd C:\Users
                cd(Name)
                cd Documents\MATLAB
                cd(TradingPlace)
                cd 全漁場
                cd(cell2mat(Directory(b,1)))
                cd Figure
                cd(FolderName1)
                
                FileName = append(cell2mat(Directory(b,1))," ",num2str(YearPatternL(c,1)),".jpg");
                saveas(gcf,FileName)
            end
            
            % 各年のデータ点と多項式近似を重ねて表示
            if Output == 2 || Output == 5 || Output == 6
                figure(2)
                plot(Month,Fitting,'o')
                hold on
                plot(X,Y)
                ylim([0 labelES*1.05 + 1])  % +1が無いと全て0のデータでバグが発生する
                xlim([1 12.9])
                legend('Data','Fitted Curve(Polynomial)')
                xlabel('Month')
                ylabel('Catch')
                title([cell2mat(Directory(b,1)), num2str(YearPatternL(c,1)), ' '])
                xticks([1 2 3 4 5 6 7 8 9 10 11 12])
                xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})  % xtickに対応する場所に任意の文字を当てはめる
                hold off
                
                cd C:\Users
                cd(Name)
                cd Documents\MATLAB
                cd(TradingPlace)
                cd 全漁場
                cd(cell2mat(Directory(b,1)))
                cd Figure
                cd(FolderName2)
                
                FileName = append(cell2mat(Directory(b,1))," ",num2str(YearPatternL(c,1)),".jpg");
                saveas(gcf,FileName)
            end
            
            % 全年のデータ点とフーリエ近似を重ねて表示
            if Output == 1 || Output == 4 || Output == 6
                figure(3)
                plot(F,Month,Fitting,'o')
                hold on
            end
            
            % 全年のデータ点と多項式近似を重ねて表示
            if Output == 2 || Output == 5 || Output == 6
                figure(4)
                plot(X,Y)
                hold on
                plot(Month,Fitting,'o')
            end
            
            DataSide = size(Fitting);
            DataSize = DataSide(1,1);
            for d = 1:DataSize
                % 来遊しているデータ点を赤色の〇で表示
                if Output == 3 || Output == 4 || Output == 5 || Output == 6
                    figure(5)
                    if (Fitting(d,1) >= max(Fitting)/Visit3 && Fitting(d,1) >= Visit4)
                        plot(Month(d,1),Fitting(d,1),'or')
                        hold on
                    else
                        plot(Month(d,1),Fitting(d,1),'ob')
                        hold on
                    end
                end
            end
        end
    end
    
    if Output == 1 || Output == 4 || Output == 6
        figure(3)
        xlim([1 12.9])
        ylim([0 labelES*1.1])
        xlabel('Month')
        ylabel('Catch')
        title([cell2mat(Directory(b,1)), ' '])
        xticks([1 2 3 4 5 6 7 8 9 10 11 12])
        xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})
        legend('off')
        
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        cd 全漁場
        cd(cell2mat(Directory(b,1)))
        cd Figure
        cd(FolderName1)
        
        FileName = append(cell2mat(Directory(b,1))," Fitting(Fourier).jpg");
        saveas(gcf,FileName)
        clf('reset')
    end
    
    if Output == 2 || Output == 5 || Output == 6
        figure(4)
        xlim([1 12.9])
        ylim([0 labelES*1.1])
        xlabel('Month')
        ylabel('Catch')
        title([cell2mat(Directory(b,1)), ' '])
        xticks([1 2 3 4 5 6 7 8 9 10 11 12])
        xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})
        
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        cd 全漁場
        cd(cell2mat(Directory(b,1)))
        cd Figure
        cd(FolderName2)
        
        FileName = append(cell2mat(Directory(b,1))," Fitting(Polynomial).jpg");
        saveas(gcf,FileName)
        clf('reset')
    end
    
    if Output == 3 || Output == 4 || Output == 5 || Output == 6
        figure(5)
        xlim([1 12.9])
        ylim([0 labelES*1.1])
        xlabel('Month')
        ylabel('Catch')
        title([cell2mat(Directory(b,1)), ' '])
        xticks([1 2 3 4 5 6 7 8 9 10 11 12])
        xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12'})
        legend('off')
        saveas(gcf,cell2mat(Directory(b,1)),'jpg')
        
        cd C:\Users
        cd(Name)
        cd Documents\MATLAB
        cd(TradingPlace)
        cd 全漁場
        cd(cell2mat(Directory(b,1)))
        cd Figure
        saveas(gcf,cell2mat(Directory(b,1)),'jpg')
        clf('reset')
    end
end


cd C:\Users
cd(Name)
cd Documents\MATLAB

Message = 'ReadTable6 complete';
disp(Message)
toc;
