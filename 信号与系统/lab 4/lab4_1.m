
% (a)
x = [1 0 1];
n_x = [0 1 2];
h = [2 0 -2];
n_h = [-1 0 1];

y = conv(x,h);
ny = (n_x(1)+n_h(1)) : (n_x(end)+n_h(end));

figure(1);
stem(ny, y);
title('y[n] = h[n] * x[n]');
xlabel('n'); ylabel('y[n]');

% (b) 通用索引公式
% 假设 nh = [a:b], nx = [c:d]
a = 0; b = 2; c = 1; d = 4;   % 举例
nh = a:b; nx = c:d;
h = ones(size(nh));
x = ones(size(nx));
y = conv(h, x);
ny = (a+c) : (b+d);
figure(2);
stem(ny, y);

%(c)
a = 0; b = 24; c = 0; d = 14;
nx = a:b; nh = c:d;
h = ones(size(nh));
x = (1/2).^(nx-2) .* (nx >= 2);
y = conv(h, x);
ny = (a+c) : (b+d);
figure(3);
stem(ny, y);

% (d) 直接卷积
n = 0:99;
h = 0.9.^n .* (n < 10);
x = cos(n.^2) .* sin(2*pi*n/5);

y = conv(h, x);
ny = (0+0) : (length(h)-1 + length(x)-1);
figure(4);
stem(ny, y); 
xlim([0, 120]);

% (e) 重叠相加法
L = 50;
x0 = x(1:L);
x1 = x(L+1:end);

y0 = conv(h, x0);
y1 = conv(h, x1);

% 叠加
y_block = zeros(1, length(y0) + L);
y_block(1:length(y0)) = y0;
y_block(L+1 : L+length(y1)) = y_block(L+1 : L+length(y1)) + y1;

figure(5);
stem(ny, y); 
xlim([0, 120]);
