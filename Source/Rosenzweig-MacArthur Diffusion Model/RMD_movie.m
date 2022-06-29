function main
tic
clear all;
close all;

global Size a b r dt
Size = 400;      % 縦軸と横軸の大きさ
Time = 2000;
separate = 500; % ファイルを何フレームで分割するか
FNumber = round(Time/dt/separate);    % ファイル数 全体フレーム数はseparate×FNumber

RMmovie(separate) = struct('cdata',[],'colormap',[]);

U = zeros(Size,Size);
V = zeros(Size,Size);

for M = 1:FNumber
    cd c:\
    cd Users
    cd okuno
    cd Documents
    cd MATLAB
    for n = 1:separate
        if M==1 && n==1
            x0 = RM_ld_default;
            for i=1:Size
                for j=1:Size
                    U(i,j) = x0(1,i,j);
                    V(i,j) = x0(2,i,j);
                end
            end
        elseif M==1 && n==2
            x = RM_ld_boundary(x0);
            for i=1:Size
                for j=1:Size
                    U(i,j) = x(1,i,j);
                    V(i,j) = x(2,i,j);
                end
            end
        else
            x = RM_ld_boundary(x);
            for i=1:Size
                for j=1:Size
                    U(i,j) = x(1,i,j);
                    V(i,j) = x(2,i,j);
                end
            end
        end
        subplot(1,2,1)
        imagesc(U);
        colormap(jet);
        title('prey')
        caxis([0,1])
        colorbar
        drawnow;
    
        subplot(1,2,2)
        imagesc(V);
        colormap(jet);
        title('predator')
        caxis([0,4])
        colorbar
        drawnow;
        RMmovie(n) = getframe(gcf);
    end
    
    cd e:\
    cd okuno
    cd movie
    if M<10
        filename = ['0',num2str(M),'-dt=',num2str(dt),'-β=',num2str(b),'-γ=',num2str(r),'-α=',num2str(a),'.avi'];
    else
        filename = [num2str(M),'-dt=',num2str(dt),'-β=',num2str(b),'-γ=',num2str(r),'-α=',num2str(a),'.avi'];
    end
    v = VideoWriter(filename);    %#ok<*TNMLP>
    open(v);
    writeVideo(v,RMmovie)
    close(v)
    toc
end

cd c:\
cd Users
cd okuno
cd Documents
cd MATLAB
end
