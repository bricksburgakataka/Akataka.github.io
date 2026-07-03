function xr=sreal(x)
xr=real(x);
end




syms t 
x = exp(i*2*pi*t/16)+exp(i*2*pi*t/8);
xr=sreal(x);



figure(1);
fplot(xr, [0, 32], 'b-', 'LineWidth', 2);  % 使用 fplot 替代 ezplot
title('Problem 8');
xlabel('t');
ylabel('x(t)');
grid on;
ylim([-1.2, 1.2]);  % 设置y轴范围