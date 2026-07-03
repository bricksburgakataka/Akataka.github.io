clear;
clc;
n= 0:10 ;
delta_n=[1 zeros(1,10)];
x1=delta_n;
x2=2*delta_n;
y1=sin(pi*x1/2);
y2=sin(pi*x2/2);

figure(1);

subplot(2,1,1);
stem(n,y1,"filled");
title('y_1[n]');
    xlabel('n');
    ylabel('y_1[n]');

subplot(2,1,2);
stem(n,y2,"filled");
title('y_2[n]');
    xlabel('n');
    ylabel('y_2[n]');

sgtitle('Problem 5-1');
