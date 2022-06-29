function main
tic
clear all;
close all;
cd c:\
cd Users
cd okuno
cd Documents
cd MATLAB

global Size a b r dt
Size = 200;      % 縦軸と横軸の大きさ
FNumber = 5;    % ファイル数 全体フレーム数はseparate×FNumber
separate = 1000; % ファイルを何フレームで分割するか

Ubar = zeros(1,FNumber.*separate);
Vbar = zeros(1,FNumber.*separate);
x0 = RM_ld_default;
k = 1;

for M = 1:FNumber
    for n = 1:separate
        sumU = 0;
        sumV = 0;
        if M==1 && n==1
            for i=1:Size
                for j=1:Size
                    sumU = sumU + x0(1,i,j);
                    sumV = sumV + x0(2,i,j);
                end
            end
        elseif M==1 && n==2
            x = RM_ld_boundary(x0);
            for i=1:Size
                for j=1:Size
                    sumU = sumU + x(1,i,j);
                    sumV = sumV + x(2,i,j);
                end
            end
        else
            x = RM_ld_boundary(x);
            for i=1:Size
                for j=1:Size
                    sumU = sumU + x(1,i,j);
                    sumV = sumV + x(2,i,j);
                end
            end
        end
        Ubar(k) = sumU./(Size.^2);
        Vbar(k) = sumV./(Size.^2);
        k = k+1;
    end
end

t = 1:(separate*FNumber);    
plot(t,Ubar,t,Vbar)
title(['β=',num2str(b) ,'γ=',num2str(r),'α=',num2str(a),'dt=',num2str(dt)])
ylabel('population')
xlabel('Time')
legend('Ubar','Vbar')
toc
end
