function y = diffeqn(a,x,yn1)
% DIFFEQN 计算一阶差分方程 y[n] = a*y[n-1] + x[n] 的输出
% a    系数
% x    输入x[n]
% yn1  y[-1]

N=length(x);
y=zeros(1,N);

for n =1:N
    if n==1
        y(n)=a*yn1+x(n);
    else
        y(n)=a*y(n-1)+x(n);
    end
end

end


a=1;

yn1=0;
n=0:30;

% x1=delta[n]
x1=[zeros(1,31)];
x1(1)=1;

% x2=u[n]
x2=[ones(1,31)];

y1=diffeqn(a,x1,yn1);

y2=diffeqn(a,x2,yn1);

figure(1)


subplot(2,1,1);
stem(n,y1,"filled");
title('x1[n] = \delta [n]');
xlabel('n');
ylabel('y1[n]');
grid on;

subplot(2,1,2);
stem(n,y2,"filled");
title('x2[n] = u[n]');
xlabel('n');
ylabel('y2[n]');
grid on;

sgtitle('Problem 6:a First-Order Difference Equation');