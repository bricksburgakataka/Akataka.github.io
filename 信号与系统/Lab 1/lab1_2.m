N=6;
n=0:4*N;
n1=0:48;
figure(1);


subplot(3, 1, 1);
x1=cos(2*pi*n/N)+2*cos(3*pi*n/N);
stem(n,x1,"filled")
title('x_1[n]');
    xlabel('n');
    ylabel('x_1[n]');

subplot(3, 1, 2);
x2=2*cos(2*n/N)+cos(3*n/N);
stem(n,x2,"filled")
title('x_2[n]');
    xlabel('n');
    ylabel('x_2[n]');
subplot(3, 1, 3);

x3=cos(2*pi*n1/N)+3*sin(2.5*pi*n1/N);
stem(n1,x3,"filled")
title('x_3[n]');
    xlabel('n');
    ylabel('x_3[n]');

%%x3的周期是24 一开始只画了一个周期
sgtitle('Problem 2');
