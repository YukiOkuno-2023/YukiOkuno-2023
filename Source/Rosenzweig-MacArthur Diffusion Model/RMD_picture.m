function main
tic
clear all;
close all;
cd c:\
cd Users
cd okuno
cd Documents
cd MATLAB

global Size
Size = 400;
dt = 0.05;
T = input('steps:');
Time = round(2000/dt);
obsT = round(T/dt);

U = zeros(Size,Size);
V = zeros(Size,Size);
x0 = RM_ld_default;

for n=1:Time
    if n==1
        for i=1:Size
            for j=1:Size
                U(i,j) = x0(1,i,j);
                V(i,j) = x0(2,i,j);
            end
        end
    elseif n==2
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
    
    if n == obsT
        figure(1)
        imagesc(U);
        colormap(jet);
        title('prey,',num2str(T),' steps')
        caxis([0,1])
        colorbar
    
        figure(2)
        imagesc(V);
        colormap(jet);
        title('predator',num2str(T),' steps')
        caxis([0,4])
        colorbar
    end
end
toc
end
