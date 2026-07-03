% 变量创建
omega_0=2*pi*1000;
fs=8192;
T=1/fs;
n=0:fs-1;
t=n*T;
x=sin(omega_0*t);

%(a)(b)
% 提取前50个样本
num_samples = 50;
n_first = n(1:num_samples);
t_first = t(1:num_samples);
x_first = x(1:num_samples);

% 创建并排的两个子图
figure(1);

% 子图1: 离散序列 (stem)
subplot(2, 1, 1);
stem(n_first, x_first, 'filled', 'LineWidth', 1.5);
title('离散时间信号 x[n] 的前50个样本');
xlabel('样本索引 n');
ylabel('x[n]');
grid on;

% 子图2: 连续时间采样点 (plot)
subplot(2, 1, 2);
plot(t_first, x_first, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
title('连续时间信号 x(t) 的前50个采样点');
xlabel('时间 t (秒)');
ylabel('x(t)');
grid on;

%(c)
[X, w] = ctfts(x, T);
figure(2);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 1000 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

%(d)(E)repeat(a)-(c)
omega_0=2*pi*1500;
x=sin(omega_0*t);


num_samples = 50;
n_first = n(1:num_samples);
t_first = t(1:num_samples);
x_first = x(1:num_samples);
%sound(x,1/T);

% 创建并排的两个子图
figure(3);

% 子图1: 离散序列 (stem)
subplot(2, 1, 1);
stem(n_first, x_first, 'filled', 'LineWidth', 1.5);
title('离散时间信号 x[n] 的前50个样本');
xlabel('样本索引 n');
ylabel('x[n]');
grid on;

% 子图2: 连续时间采样点 (plot)
subplot(2, 1, 2);
plot(t_first, x_first, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
title('连续时间信号 x(t) 的前50个采样点');
xlabel('时间 t (秒)');
ylabel('x(t)');
grid on;

%(c)
[X, w] = ctfts(x, T);
figure(4);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 1500 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

omega_0=2*pi*2000;
x=sin(omega_0*t);


num_samples = 50;
n_first = n(1:num_samples);
t_first = t(1:num_samples);
x_first = x(1:num_samples);
%sound(x,1/T);

% 创建并排的两个子图
figure(5);

% 子图1: 离散序列 (stem)
subplot(2, 1, 1);
stem(n_first, x_first, 'filled', 'LineWidth', 1.5);
title('离散时间信号 x[n] 的前50个样本');
xlabel('样本索引 n');
ylabel('x[n]');
grid on;

% 子图2: 连续时间采样点 (plot)
subplot(2, 1, 2);
plot(t_first, x_first, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
title('连续时间信号 x(t) 的前50个采样点');
xlabel('时间 t (秒)');
ylabel('x(t)');
grid on;

%(c)
[X, w] = ctfts(x, T);
figure(6);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 2000 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

%(F)
omega_0=2*pi*3500;
x=sin(omega_0*t);


x_first = x(1:num_samples);
%sound(x,1/T);



[X, w] = ctfts(x, T);
figure(7);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 3500 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

omega_0=2*pi*4000;
x=sin(omega_0*t);


x_first = x(1:num_samples);
%sound(x,1/T);


%(c)
[X, w] = ctfts(x, T);
figure(8);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 4000 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

omega_0=2*pi*4500;
x=sin(omega_0*t);


x_first = x(1:num_samples);
%sound(x,1/T);


%(c)
[X, w] = ctfts(x, T);
figure(9);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 4500 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

omega_0=2*pi*5000;
x=sin(omega_0*t);


x_first = x(1:num_samples);
%sound(x,1/T);


%(c)
[X, w] = ctfts(x, T);
figure(10);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 5000 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

omega_0=2*pi*5500;
x=sin(omega_0*t);


x_first = x(1:num_samples);
%sound(x,1/T);


%(c)
[X, w] = ctfts(x, T);
figure(11);

plot(w, abs(X), 'LineWidth', 1.5);
title('重建信号 x_r(t) 的 CTFT 幅度谱 (f0 = 5500 Hz, fs = 8192 Hz)');
xlabel('频率 \omega (rad/s)');
ylabel('|X(j\omega)|');
grid on;
xlim([-2*pi*2000, 2*pi*2000]); % 聚焦在 ±2000 Hz 范围

%(G)

omega_0=2*pi*3000;
beta=2000;
x=sin(omega_0*t+0.5*beta*(t.^2));
%sound(x,1/T);


%(j)
fs=8192;
T=1/fs;
n=0:10*fs-1;
t=n*T;
omega_0=2*pi*3000;
beta=2000;
x=sin(omega_0*t+0.5*beta*(t.^2));
sound(x,1/T);
