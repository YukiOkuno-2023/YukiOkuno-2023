function x = D2(xm)
% X(1,x,y,t)をU ,X(2,x,y,t)をVとする
global Size a b r dt

DU = 0.01;
DV = 1.0;
dt = 0.05; % D*dt/(dx)^2 且つ D*dt/(dy)^2
dx = 1;
dy = 1;

a = 0.3;
b = 14.0;
r = 0.7;

x = zeros(2,Size+1,Size+1);
for i = 2:Size
    for j = 2:Size
        x(1,i,j) = xm(1,i,j) + a.*dt.*xm(1,i,j).*(1-xm(1,i,j)-xm(2,i,j)./(1+b.*xm(1,i,j))) + dt.*DU.*((xm(1,i+1,j)+xm(1,i-1,j)-2.*xm(1,i,j))./dx.^2 + (xm(1,i,j+1)+xm(1,i,j-1)-2.*xm(1,i,j))./dy.^2);
        x(2,i,j) = xm(2,i,j) + dt.*xm(2,i,j).*((b.*xm(1,i,j))./(1+b.*xm(1,i,j))-r)         + dt.*DV.*((xm(2,i+1,j)+xm(2,i-1,j)-2.*xm(2,i,j))./dx.^2 + (xm(2,i,j+1)+xm(2,i,j-1)-2.*xm(2,i,j))./dy.^2);
    end
end

for j=1:Size % xの境界
        x(1,Size,j) = xm(1,Size,j) + a.*dt.*xm(1,Size,j).*(1-xm(1,Size,j)-xm(2,Size,j)./(1+b.*xm(1,Size,j))) + (dt./dx.^2).*DU.*(xm(1,1,j) + xm(1,Size-1,j) -2.*xm(1,Size,j));
        x(1,1,j)    = xm(1,1,j) + a.*dt.*xm(1,1,j).*(1-xm(1,1,j)-xm(2,1,j)./(1+b.*xm(1,1,j)))                + (dt./dx.^2).*DU.*(xm(1,2,j) + xm(1,Size,j)   -2.*xm(1,1,j));
        x(2,Size,j) = xm(2,Size,j) + dt.*xm(2,Size,j).*((b.*xm(1,Size,j))./(1+b.*xm(1,Size,j))-r)            + (dt./dx.^2).*DU.*(xm(2,1,j) + xm(2,Size-1,j) -2.*xm(2,Size,j));
        x(2,1,j)    = xm(2,1,j) + dt.*xm(2,1,j).*((b.*xm(1,1,j))./(1+b.*xm(1,1,j))-r)                        + (dt./dx.^2).*DU.*(xm(2,2,j) + xm(2,Size,j)   -2.*xm(2,1,j));
end

for  i=1:Size % yの境界
        x(1,i,Size) = xm(1,i,Size) + a.*dt.*xm(1,i,Size).*(1-xm(1,i,Size)-xm(2,i,Size)./(1+b.*xm(1,i,Size))) + (dt./dy.^2).*DU.*(xm(1,i,1) + xm(1,i,Size-1) -2.*xm(1,i,Size));
        x(1,i,1)    = xm(1,i,1) + a.*dt.*xm(1,i,1).*(1-xm(1,i,1)-xm(2,i,1)./(1+b.*xm(1,i,1)))                + (dt./dy.^2).*DU.*(xm(1,i,2) + xm(1,i,Size)   -2.*xm(1,i,1));
        x(2,i,Size) = xm(2,i,Size) + dt.*xm(2,i,Size).*((b.*xm(1,i,Size))./(1+b.*xm(1,i,Size))-r)            + (dt./dy.^2).*DU.*(xm(2,i,1) + xm(2,i,Size-1) -2.*xm(2,i,Size));
        x(2,i,1)    = xm(2,i,1) + dt.*xm(2,i,1).*((b.*xm(1,i,1))./(1+b.*xm(1,i,1))-r)                        + (dt./dy.^2).*DU.*(xm(2,i,2) + xm(2,i,Size)   -2.*xm(2,i,1));
end

end
