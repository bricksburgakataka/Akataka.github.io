%% 非因果系统演示：y[n] = x[n] + x[n+1]
clear; clc; close all;

%% 定义输入信号区间
n_x = -5:9;              % 输入的时间范围：-5 ≤ n ≤ 9
N_x = length(n_x);       % 输入长度 = 15

%% 创建输入信号 x[n] = u[n]（单位阶跃）
x = zeros(1, N_x);
x(n_x >= 0) = 1;         % 当 n ≥ 0 时，x[n] = 1

%% 计算输出信号
% 输出区间：-6 ≤ n ≤ 9
n_y = -6:9;               % 输出时间范围
N_y = length(n_y);        % 输出长度 = 16

y = zeros(1, N_y);

% 计算每个输出点
for i = 1:N_y
    current_n = n_y(i);
    
    % y[n] = x[n] + x[n+1]
    % 需要找到 x 中对应 n 和 n+1 的索引
    
    % 找 x 中对应 current_n 的索引
    idx_n = find(n_x == current_n);
    % 找 x 中对应 current_n+1 的索引
    idx_n1 = find(n_x == current_n + 1);
    
    % 如果索引存在，取值；否则为0（超出定义域）
    x_n = 0;
    x_n1 = 0;
    
    if ~isempty(idx_n)
        x_n = x(idx_n);
    end
    
    if ~isempty(idx_n1)
        x_n1 = x(idx_n1);
    end
    
    y(i) = x_n + x_n1;
end



%% 绘制信号
figure('Position', [100, 100, 1000, 600]);

% 子图1：输入信号
subplot(2,1,1);
stem(n_x, x, 'filled', 'LineWidth', 1.5, 'MarkerSize', 8, 'Color', 'b');
title('x[n] = u[n]', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('n', 'FontSize', 12);
ylabel('x[n]', 'FontSize', 12);
xlim([-7, 10]);
ylim([-0.1, 1.5]);
grid on;
xticks(-7:10);


% 子图2：输出信号
subplot(2,1,2);
stem(n_y, y, 'filled', 'LineWidth', 1.5, 'MarkerSize', 8, 'Color', 'r');
title('y[n] = x[n] + x[n+1]', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('n', 'FontSize', 12);
ylabel('y[n]', 'FontSize', 12);
xlim([-7, 10]);
ylim([-0.1, 2.5]);
grid on;
xticks(-7:10);


hold on;


sgtitle('Problem5-2：y[n] = x[n] + x[n+1]', 'FontSize', 16, 'FontWeight', 'bold');