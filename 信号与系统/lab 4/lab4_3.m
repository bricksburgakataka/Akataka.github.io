%% Problem 3 - Fourier Series Representation of Periodic Signals
clear; clc; close all;

%% (a)-(c) 合成周期 N=5 的信号
N = 5;
n = 0:N-1;

% (b) 定义 DTFS 系数 a0 到 a4
a0 = 1;
a1 = 0;
a2 = exp(1j*pi/4);
a3 = conj(a2);  % a3 = a_{-2}^* = e^{-j*pi/4}
a4 = 2*exp(1j*pi/3);

a = [a0, a1, a2, a3, a4];

% (c) 用合成公式计算 x[n]
x = zeros(1, N);
for n_idx = 0:N-1
    for k = 0:N-1
        x(n_idx+1) = x(n_idx+1) + a(k+1) * exp(1j*2*pi*k*n_idx/N);
    end
end

% 去除舍入误差产生的微小虚部
x = real(x);

figure(1);
stem(0:N-1, x, 'filled', 'LineWidth', 1.5);
xlabel('n');
ylabel('x[n]');
title('Problem 3(c): Synthesized Signal x[n] (N=5)');
grid on;

%% (d) 定义三个方波信号
% x1: N=8, 前8个点为1 (一个完整周期)
N1 = 8;
x1_period = ones(1, 8);

% x2: N=16, 前8个点为1
N2 = 16;
x2_period = [ones(1,8), zeros(1,8)];

% x3: N=32, 前8个点为1
N3 = 32;
x3_period = [ones(1,8), zeros(1,24)];

% 重复信号以覆盖 0-63 范围
n_range = 0:63;
x1 = repmat(x1_period, 1, ceil(64/N1));
x1 = x1(1:64);
x2 = repmat(x2_period, 1, ceil(64/N2));
x2 = x2(1:64);
x3 = repmat(x3_period, 1, ceil(64/N3));
x3 = x3(1:64);

figure(2);
subplot(3,1,1);
stem(n_range, x1, 'LineWidth', 1);
title('x_1[n] (N=8)');
xlabel('n'); ylabel('幅度');
grid on;
xlim([0,63]);

subplot(3,1,2);
stem(n_range, x2, 'LineWidth', 1);
title('x_2[n] (N=16)');
xlabel('n'); ylabel('幅度');
grid on;
xlim([0,63]);

subplot(3,1,3);
stem(n_range, x3, 'LineWidth', 1);
title('x_3[n] (N=32)');
xlabel('n'); ylabel('幅度');
grid on;
xlim([0,63]);

%% (e) 用 FFT 计算 DTFS 系数
% x1
a1_coef = (1/N1) * fft(x1_period, N1);
% x2
a2_coef = (1/N2) * fft(x2_period, N2);
% x3
a3_coef = (1/N3) * fft(x3_period, N3);

% 绘制幅度谱
k1 = 0:N1-1;
k2 = 0:N2-1;
k3 = 0:N3-1;

figure(3);
subplot(3,1,1);
stem(k1, abs(a1_coef), 'filled', 'LineWidth', 1);
title('|a_k| for x_1[n] (N=8)');
xlabel('k'); ylabel('|a_k|');
grid on;

subplot(3,1,2);
stem(k2, abs(a2_coef), 'filled', 'LineWidth', 1);
title('|a_k| for x_2[n] (N=16)');
xlabel('k'); ylabel('|a_k|');
grid on;

subplot(3,1,3);
stem(k3, abs(a3_coef), 'filled', 'LineWidth', 1);
title('|a_k| for x_3[n] (N=32)');
xlabel('k'); ylabel('|a_k|');
grid on;

% 验证直流分量
fprintf('直流分量 a0:\n');
fprintf('x1: 预测 = 1, 实际 = %.4f\n', a1_coef(1));
fprintf('x2: 预测 = 0.5, 实际 = %.4f\n', a2_coef(1));
fprintf('x3: 预测 = 0.25, 实际 = %.4f\n', a3_coef(1));

%% (f)-(h) 部分系数合成 x3
% 全部系数合成（-15 到 16）
x_all = zeros(1, N3);
for k = -15:16
    if k >= 0
        k_idx = k + 1;
    else
        k_idx = N3 + k + 1;
    end
    x_all = x_all + a3_coef(k_idx) * exp(1j*2*pi*k*(0:N3-1)/N3);
end
x_all = real(x_all);

% 部分合成：k = -2 到 2
x_2 = zeros(1, N3);
for k = -2:2
    if k >= 0
        k_idx = k + 1;
    else
        k_idx = N3 + k + 1;
    end
    x_2 = x_2 + a3_coef(k_idx) * exp(1j*2*pi*k*(0:N3-1)/N3);
end
x_2 = real(x_2);

% 部分合成：k = -8 到 8
x_8 = zeros(1, N3);
for k = -8:8
    if k >= 0
        k_idx = k + 1;
    else
        k_idx = N3 + k + 1;
    end
    x_8 = x_8 + a3_coef(k_idx) * exp(1j*2*pi*k*(0:N3-1)/N3);
end
x_8 = real(x_8);

% 部分合成：k = -12 到 12
x_12 = zeros(1, N3);
for k = -12:12
    if k >= 0
        k_idx = k + 1;
    else
        k_idx = N3 + k + 1;
    end
    x_12 = x_12 + a3_coef(k_idx) * exp(1j*2*pi*k*(0:N3-1)/N3);
end
x_12 = real(x_12);

% 绘制部分合成结果
figure(4);
subplot(4,1,1);
stem(0:N3-1, x_2, 'LineWidth', 0.5);
title('x_{3-2}[n] (k = -2 to 2)');
xlabel('n'); ylabel('幅度');
ylim([-0.5, 1.2]);
grid on;

subplot(4,1,2);
stem(0:N3-1, x_8, 'LineWidth', 0.5);
title('x_{3-8}[n] (k = -8 to 8)');
xlabel('n'); ylabel('幅度');
ylim([-0.5, 1.2]);
grid on;

subplot(4,1,3);
stem(0:N3-1, x_12, 'LineWidth', 0.5);
title('x_{3-12}[n] (k = -12 to 12)');
xlabel('n'); ylabel('幅度');
ylim([-0.5, 1.2]);
grid on;

subplot(4,1,4);
stem(0:N3-1, x_all, 'LineWidth', 0.5);
title('x_{3-all}[n] (k = -15 to 16)');
xlabel('n'); ylabel('幅度');
ylim([-0.5, 1.2]);
grid on;

%% 观察吉布斯现象
% 在边缘附近放大观察过冲 (n=7 附近是跳变点)
edge_region = 5:12;

figure(5);
plot(edge_region, x3_period(edge_region+1), 'b-o', 'LineWidth', 2); hold on;
plot(edge_region, x_all(edge_region+1), 'r-s', 'LineWidth', 2);
plot(edge_region, x_12(edge_region+1), 'g--^', 'LineWidth', 1.5);
xlabel('n');
ylabel('幅度');
title('吉布斯现象: 边缘附近的过冲');
legend('原始方波', '全部系数合成 (k=-15 to 16)', '部分系数合成 (k=-12 to 12)', 'Location', 'best');
grid on;

% 计算过冲（在 n=8 附近的最大值减去1）
overshoot_region = 7:10;
overshoot = max(x_all(overshoot_region+1)) - 1;
fprintf('\n吉布斯过冲: %.4f (理论值 ~0.09)\n', overshoot);

% 验证全部系数合成与原始信号一致
x3_reconstructed = real(N3 * ifft(a3_coef));
max_diff = max(abs(x3_reconstructed - x3_period));
fprintf('全部系数合成与原始信号的误差: %.2e\n', max_diff);