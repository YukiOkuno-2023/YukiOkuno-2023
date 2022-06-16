%作成者　奥野 2018/7/5
% 更新   奥野 2018/7/11 ファイル名をpreddatorの変数に
% 更新   奥野 2018/11/10 ファイル名等修正
clear all;		%初期化
close all;		%初期化

prompt=strcat('計算するフォルダ番号を入力してください。');
TARGET_FOLDER=input(prompt,'s');
prompt=strcat('画像サイズを決定してください(1=180*180,2=360*360,...)。');
gazouQ=str2double(input(prompt,'s'));

DATA_MAIN = strcat('OUTPUT/',TARGET_FOLDER,'/input_main.dat');		%基本情報ファイル
DATA_TYPE = strcat('OUTPUT/',TARGET_FOLDER,'/input_type.dat');      %個体パラメータファイル
DATA_QUANTITY = strcat('OUTPUT/',TARGET_FOLDER,'/population.dat');	%個体数ファイル
DATA_RESULT = strcat('OUTPUT/',TARGET_FOLDER,'/output.dat');		%CELLデータファイル
DATA_SAVE = strcat('OUTPUT/',TARGET_FOLDER);                        %画像、動画保存先


% data_quantity = load(DATA_QUANTITY);						%個体数READ
data_main = load(DATA_MAIN);								%基本情報READ
data_type = load(DATA_TYPE);                                %個体パラメータ

size          = data_main(1,1);		%全体のSIZE
step_all      = data_main(2,1);		%全step回数
step_interval = data_main(3,1);		%画像書き出しstep間隔
type_all      = data_main(4,1);		%全個体種類数

predrep   = data_type(14,1); %predatorの増殖時間
predstarv = data_type(15,1); %predatorの飢餓時間
coord=strcat('x',num2str(predrep),'y',num2str(predstarv)); %ファイル名(x?y?)

load('MyColormaps','mycmap');							%カラーマップ取得

%%%% 個体数遷移図作成 %%%%
fileID = fopen(DATA_QUANTITY,'r');
scan_quantity=textscan(fileID,'%d','headerLines',1);  %quantity.txtの読み込み(2行目から読み込み)
data_quantity=scan_quantity{1,1};
line=1;
for i=1:step_all+1
    data_quantity(i,2)=data_quantity(line,1);  %step
    data_quantity(i,3)=data_quantity(line+1,1); %type1の個体数
    data_quantity(i,4)=data_quantity(line+2,1); %type2
    data_quantity(i,5)=data_quantity(line+3,1); %type3
    data_quantity(i,6)=data_quantity(line+4,1); %type4
    data_quantity(i,7)=data_quantity(line+5,1); %type5
    data_quantity(i,8)=data_quantity(line+6,1); %type6
    data_quantity(i,9)=data_quantity(line+7,1); %type7
    line=line+8;
end
data_quantity(:,1) = []; %いらない列を削除
data_quantity(step_all+2:8*(step_all+1),:) = []; %いらない行を削除

fig = figure('visible','off');							%画像表示OFF
plot(0:step_all,data_quantity(1:step_all+1,2),'green');  %1:step_all,data_quantity(1,1:step_all)を0step目の個体数を表示するよう変更
hold on;
plot(0:step_all,data_quantity(1:step_all+1,3),'red');
hold on;
plot(0:step_all,data_quantity(1:step_all+1,4),'blue');
hold on;
plot(0:step_all,data_quantity(1:step_all+1,5),'black');
hold on;
plot(0:step_all,data_quantity(1:step_all+1,6),'yellow');
hold on;
plot(0:step_all,data_quantity(1:step_all+1,7),'magenta');
hold on;
plot(0:step_all,data_quantity(1:step_all+1,8),'cyan');

axis([0,step_all,0,size * size]);						%PLOT範囲決定
title('population');										%TITLE付け
xlabel('step')

buf_name = strcat('OUTPUT/',TARGET_FOLDER,'/',coord);
saveas(fig,buf_name, 'jpg');							%画像保存

close all;												%初期化

%%%% CELL画像作成 %%%%
step_gazou    = round(step_all/step_interval) + 1;		%書き出し画像枚数
for buf_step = 1 : step_gazou;
   load('MyColormaps','mycmap')
   figure(1);
   set(1,'Colormap',mycmap)
   range = [(size * (buf_step-1)) 0 (size * buf_step - 1) size - 1];	%TXT内画像範囲選択(バグ対策範囲SIZE-1)
   CELL_MAP = dlmread(DATA_RESULT,',', range);
   pcolor(CELL_MAP);													%画像作成
   caxis([0 7]);
   shading flat;
   axis square
   axis off

   InputRatio=[100 100];
   set(gca,'PlotBoxAspectRatio',[InputRatio(1) InputRatio(2) 1]);
   set(gca,'Position',get(gca,'OuterPosition'));
   Fpos=get(gcf,'Position');
   set(gcf,'Position',[Fpos([1,2]),Fpos(3)*InputRatio/InputRatio(1)])
   
   picnumber=(buf_step-1) * step_interval;
   NowStep=strcat(num2str(picnumber));
   text(round(size/50),size-round(size/50),NowStep,'FontSize',gazouQ*gazouQ)
   
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 180*gazouQ 180*gazouQ])
   
   if buf_step<=9
       eval(['print -dtiff -r1 ./',DATA_SAVE,'/','000',num2str(buf_step), '.jpg'])
   end
   if buf_step>=10&&buf_step<=99
       eval(['print -dtiff -r1 ./',DATA_SAVE,'/','00',num2str(buf_step), '.jpg'])
   end
   if buf_step>=100&&buf_step<=999
       eval(['print -dtiff -r1 ./',DATA_SAVE,'/','0',num2str(buf_step), '.jpg'])
   end
   if buf_step>=1000&&buf_step<=9999
       eval(['print -dtiff -r1 ./',DATA_SAVE,'/',num2str(buf_step), '.jpg'])
   end
   
   close all;
end

writerObj = VideoWriter(coord);
writerObj.FrameRate = 10;  % Default 30
writerObj.Quality = 75;    % Default 75
open(writerObj);
set(gca,'Position',get(gca,'OuterPosition'));

for i = 1 : step_gazou;
    if i<=9
        Imgfilename = strcat(DATA_SAVE,'/000',num2str(i),'.jpg');
    end
    if i>=10&&i<=99
        Imgfilename = strcat(DATA_SAVE,'/00',num2str(i),'.jpg');
    end
    if i>=100&&i<=999
        Imgfilename = strcat(DATA_SAVE,'/0',num2str(i),'.jpg');
    end
    if i>=1000&&i<=9999
        Imgfilename = strcat(DATA_SAVE,'/',num2str(i),'.jpg');
    end
    
    A=imread(Imgfilename);    
    image(A) 
    axis square
    axis off;
    drawnow;
    M = getframe(gcf);
    writeVideo(writerObj,M);   
end
close(writerObj);
close all;
coord2=strcat(coord,'.avi');%文字列をx?y?からx?y?.aviに更新
movefile(coord2,DATA_SAVE);

clear all;
close all;

