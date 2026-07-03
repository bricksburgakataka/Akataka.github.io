n=0:31;
figure(1);

subplot(3, 1, 1);
x1=sin(pi*n/4).*cos(pi*n/4);
stem(n,x1);
title('x_1[n]');
    xlabel('n');
    ylabel('x_1[n]');
grid on;

subplot(3, 1, 2);
x2=cos(pi*n/4).*cos(pi*n/4);
stem(n,x2);
title('x_2[n]');
    xlabel('n');
    ylabel('x_2[n]');
grid on;

subplot(3, 1, 3);
x3=sin(pi*n/4).*cos(pi*n/8);
stem(n,x3);
title('x_3[n]');
xlabel('n');
ylabel('x_3[n]');
grid on;

sgtitle('Problem 3');