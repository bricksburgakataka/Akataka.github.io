syms t T
x = sin(2*pi*t/T);
x5 = subs(x, T, 5);

figure(1);
fplot(x5, [0, 10], 'b-', 'LineWidth', 2);  % 使用 fplot 替代 ezplot
title('Problem 7:x(t)=sin(2\pi t/5)');
xlabel('t');
ylabel('x(t)');
grid on;
ylim([-1.2, 1.2]);  % 设置y轴范围