wc = 0.4;                 % 截止频率（以 π 归一化）
n1 = 10; n2 = 4; n3 = 12;

% 滤波器1：Butterworth（IIR，无限冲激响应）
[b1, a1] = butter(n1, wc);

% 滤波器2：FIR，阶数4
a2 = 1;
b2 = remez(n2, [0 wc-0.04 wc+0.04 1], [1 1 0 0]);

% 滤波器3：FIR，阶数12
a3 = 1;
b3 = remez(n3, [0 wc-0.04 wc+0.04 1], [1 1 0 0]);

% 计算频率响应（使用 512 个点获得平滑曲线）
[H1, w] = freqz(b1, a1, 512);
[H2, w] = freqz(b2, a2, 512);
[H3, w] = freqz(b3, a3, 512);

% 绘制幅度响应
figure;
subplot(2,1,1);
plot(w/pi, abs(H1), 'b', w/pi, abs(H2), 'r', w/pi, abs(H3), 'g');
xlabel('频率 (\times \pi rad)');
ylabel('幅度');
legend('Butterworth (n=10)', 'FIR (n=4)', 'FIR (n=12)');
title('幅度响应');
grid on;

% 绘制相位响应
subplot(2,1,2);
plot(w/pi, angle(H1), 'b', w/pi, angle(H2), 'r', w/pi, angle(H3), 'g');
xlabel('频率 (\times \pi rad)');
ylabel('相位 (rad)');
legend('Butterworth', 'FIR (n=4)', 'FIR (n=12)');
title('相位响应');
grid on;

n = 0:20;
u = ones(size(n));

% 计算阶跃响应
step1 = filter(b1, a1, u);
step2 = filter(b2, a2, u);
step3 = filter(b3, a3, u);

% 绘制
figure;
subplot(3,1,1);
stem(n, step1);
title('Butterworth (n=10) 阶跃响应');
ylabel('幅度');
grid on;

subplot(3,1,2);
stem(n, step2);
title('FIR (n=4) 阶跃响应');
ylabel('幅度');
grid on;

subplot(3,1,3);
stem(n, step3);
title('FIR (n=12) 阶跃响应');
xlabel('n');
ylabel('幅度');
grid on;

figure(2);

% 计算过冲
overshoot1 = max(step1) - step1(end);
overshoot2 = max(step2) - step2(end);
overshoot3 = max(step3) - step3(end);

fprintf('过冲值:\n');
fprintf('Butterworth: %.4f\n', overshoot1);
fprintf('FIR (n=4):   %.4f\n', overshoot2);
fprintf('FIR (n=12):  %.4f\n', overshoot3);


%% Problem 2 - Image Processing with 1D Filters
% 从 (d) 到 (h)

clear; clc; close all;

%% 加载图像
load plus;  % 加载 x 和 xn

%% 设计三个滤波器 (a部分)
wc = 0.4;                 % 截止频率（以 pi 归一化）
n1 = 10; n2 = 4; n3 = 12;

[b1, a1] = butter(n1, wc);           % 滤波器1: Butterworth (IIR)
a2 = 1;                              % 滤波器2: FIR, 阶数4
b2 = remez(n2, [0 wc-0.04 wc+0.04 1], [1 1 0 0]);
a3 = 1;                              % 滤波器3: FIR, 阶数12
b3 = remez(n3, [0 wc-0.04 wc+0.04 1], [1 1 0 0]);

%% (b) 频率响应分析
[H1, w] = freqz(b1, a1, 512);
[H2, w] = freqz(b2, a2, 512);
[H3, w] = freqz(b3, a3, 512);

figure(1);
subplot(2,1,1);
plot(w/pi, abs(H1), 'b-', 'LineWidth', 1.5); hold on;
plot(w/pi, abs(H2), 'r-', 'LineWidth', 1.5);
plot(w/pi, abs(H3), 'g-', 'LineWidth', 1.5);
xlabel('频率 (\times \pi rad)');
ylabel('幅度');
title('幅度响应');
legend('Butterworth (n=10)', 'FIR (n=4)', 'FIR (n=12)');
grid on;

subplot(2,1,2);
plot(w/pi, angle(H1), 'b-', 'LineWidth', 1.5); hold on;
plot(w/pi, angle(H2), 'r-', 'LineWidth', 1.5);
plot(w/pi, angle(H3), 'g-', 'LineWidth', 1.5);
xlabel('频率 (\times \pi rad)');
ylabel('相位 (rad)');
title('相位响应');
legend('Butterworth', 'FIR (n=4)', 'FIR (n=12)');
grid on;

%% (c) 阶跃响应分析
n_step = 0:20;
u = ones(size(n_step));

step1 = filter(b1, a1, u);
step2 = filter(b2, a2, u);
step3 = filter(b3, a3, u);

figure(2);
subplot(3,1,1);
stem(n_step, step1, 'b', 'LineWidth', 1.5);
title('Butterworth (n=10) 阶跃响应');
ylabel('幅度');
grid on;

subplot(3,1,2);
stem(n_step, step2, 'r', 'LineWidth', 1.5);
title('FIR (n=4) 阶跃响应');
ylabel('幅度');
grid on;

subplot(3,1,3);
stem(n_step, step3, 'g', 'LineWidth', 1.5);
title('FIR (n=12) 阶跃响应');
xlabel('n');
ylabel('幅度');
grid on;

% 计算过冲
overshoot1 = max(step1) - step1(end);
overshoot2 = max(step2) - step2(end);
overshoot3 = max(step3) - step3(end);
fprintf('过冲值:\n');
fprintf('Butterworth: %.4f\n', overshoot1);
fprintf('FIR (n=4):   %.4f\n', overshoot2);
fprintf('FIR (n=12):  %.4f\n', overshoot3);

%% (d) 单列非因果滤波（滤波器1）
[M, N] = size(x);
x16 = x(:, 16);  % 取第16列

% 确定 d 值
d1 = (length(a1) - 1) / 2;  % Butterworth 滤波器
if mod(length(a1), 2) == 0
    d1 = length(a1) / 2;
end

% 非因果滤波：补零再截取
x16_padded = [x16; zeros(d1, 1)];
y16_temp = filter(b1, a1, x16_padded);
y16 = y16_temp(end-length(x16)+1:end);

figure(3);
subplot(2,1,1);
stem(0:31, x16, 'b', 'LineWidth', 1);
title('原始信号 x_{16}[m]');
xlabel('m');
ylabel('幅度');
grid on;

subplot(2,1,2);
stem(0:31, y16, 'r', 'LineWidth', 1);
title('滤波后信号 y_{16}[m] (Butterworth)');
xlabel('m');
ylabel('幅度');
grid on;

%% (e) 滤波器2和3的单列响应
% 滤波器2的 d 值
d2 = (length(b2) - 1) / 2;

% 滤波器3的 d 值
d3 = (length(b3) - 1) / 2;

% 滤波器2
x16_padded2 = [x16; zeros(d2, 1)];
y16_temp2 = filter(b2, a2, x16_padded2);
y16_2 = y16_temp2(end-length(x16)+1:end);

% 滤波器3
x16_padded3 = [x16; zeros(d3, 1)];
y16_temp3 = filter(b3, a3, x16_padded3);
y16_3 = y16_temp3(end-length(x16)+1:end);

figure(4);
plot(0:31, x16, 'k-', 'LineWidth', 2); hold on;
plot(0:31, y16, 'b-', 'LineWidth', 1.5);
plot(0:31, y16_2, 'r-', 'LineWidth', 1.5);
plot(0:31, y16_3, 'g-', 'LineWidth', 1.5);
xlabel('m');
ylabel('幅度');
title('不同滤波器对 x_{16} 的响应');
legend('原始', 'Butterworth', 'FIR (n=4)', 'FIR (n=12)');
grid on;

%% (f) 二维滤波函数 filt2d
% 函数定义在文件末尾

%% (g) 显示滤波后的图像
% 对整幅图像进行二维滤波
y1 = filt2d(b1, a1, round(d1), x);
y2 = filt2d(b2, a2, d2, x);
y3 = filt2d(b3, a3, d3, x);

figure(5);
colormap(gray);

subplot(2,2,1);
image(64 * x);
title('原始图像');
axis equal tight;

subplot(2,2,2);
image(64 * y1);
title('Butterworth 滤波后');
axis equal tight;

subplot(2,2,3);
image(64 * y2);
title('FIR (n=4) 滤波后');
axis equal tight;

subplot(2,2,4);
image(64 * y3);
title('FIR (n=12) 滤波后');
axis equal tight;

%% (h) 分析失真 - 计算均方误差
mse1 = mean((x(:) - y1(:)).^2);
mse2 = mean((x(:) - y2(:)).^2);
mse3 = mean((x(:) - y3(:)).^2);

fprintf('\n均方误差 (MSE):\n');
fprintf('Butterworth: %.6f\n', mse1);
fprintf('FIR (n=4):   %.6f\n', mse2);
fprintf('FIR (n=12):  %.6f\n', mse3);

% 观察对称性破坏（检查图像中心区域）
center = 15:18;
fprintf('\n中心区域像素值 (位置 [15,16,17,18]):\n');
fprintf('原始图像:     %s\n', mat2str(x(center, center)));
fprintf('Butterworth:  %s\n', mat2str(y1(center, center), 3));
fprintf('FIR (n=4):    %s\n', mat2str(y2(center, center), 3));
fprintf('FIR (n=12):   %s\n', mat2str(y3(center, center), 3));

%% ==================== 函数定义 ====================

function y = filt2d(b, a, d, x)
    % 二维可分离非因果滤波
    % 输入:
    %   b, a - 一维滤波器系数
    %   d    - 滤波器延迟（阶数的一半）
    %   x    - 输入图像矩阵
    % 输出:
    %   y    - 滤波后图像（与 x 尺寸相同）
    
    [M, N] = size(x);
    
    % 步骤1: 对每一列进行滤波
    z = zeros(M, N);
    for col = 1:N
        col_data = [x(:, col); zeros(d, 1)];
        temp = filter(b, a, col_data);
        z(:, col) = temp(end-M+1:end);
    end
    
    % 步骤2: 对每一行进行滤波
    y = zeros(M, N);
    for row = 1:M
        row_data = [z(row, :)'; zeros(d, 1)];
        temp = filter(b, a, row_data);
        y(row, :) = temp(end-N+1:end)';
    end
end
