% 戴维南等效电路参数
Vth = 10.08;    % 戴维南电压 (V)
Rth = 510;      % 戴维南电阻 (Ω)

% 计算不同负载电流时的端口电压
I_load = linspace(0, 0.025, 100);  % 负载电流从0到30mA
V_port = Vth - I_load * Rth;      % 端口电压计算

% 绘制外特性曲线
figure;
plot(I_load * 1000, V_port, 'b-', 'LineWidth', 2);
grid on;
xlabel('电流I(mA)');
ylabel('电压V(V)');
title('戴维南等效电路外特性曲线');

% 标记关键点
hold on;

% 等效电路数据点（原有的3个点）
data_points_equiv = [
    2.41, 14.26;   % [电压, 电流(mA)]
    5.83,  7.96;
    7.40,  5.03
];

% 实验电路数据点（新的3个点）
data_points_exp = [
    4.85, 9.25;    % [电压, 电流(mA)] - 实验点1
    6.72, 6.65;    % 实验点2
    8.15, 4.01     % 实验点3
];

% 先绘制等效电路数据点（红色方形）
for i = 1:size(data_points_equiv, 1)
    V_point = data_points_equiv(i, 1);
    I_point = data_points_equiv(i, 2);
    
    % 绘制数据点
    plot(I_point, V_point, 's', 'MarkerSize', 10, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black');
    
    % 添加文本标注
    text(I_point + 1.5, V_point + 1, ...
        sprintf('等效%d(%.2fV,%.2fmA)', i, V_point, I_point), ...
        'FontSize', 8, 'BackgroundColor', 'white', 'Color', 'red');
end

% 先绘制一个等效电路图例用的点（不可见，只为图例）
h_equiv = plot(NaN, NaN, 's', 'MarkerSize', 8, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black');

% 标记实验电路数据点（绿色三角形）
for i = 1:size(data_points_exp, 1)
    V_point = data_points_exp(i, 1);
    I_point = data_points_exp(i, 2);
    
    % 绘制数据点
    plot(I_point, V_point, '^', 'MarkerSize', 10, 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'black');
    
    % 添加文本标注
    text(I_point + 0.5, V_point +1, ...
        sprintf('实验%d(%.2fV,%.2fmA)', i, V_point, I_point), ...
        'FontSize', 8, 'BackgroundColor', 'white', 'Color', 'green');
end

% 先绘制一个实验电路图例用的点（不可见，只为图例）
h_exp = plot(NaN, NaN, '^', 'MarkerSize', 8, 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'black');

% 标记理论关键点
% 开路电压点 (I=0)
plot(0, Vth, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'blue');
text(0.5, Vth+0.3, ['V_{oc} = ' num2str(Vth) 'V'], 'FontSize', 10);

% 短路电流点 (V=0)
I_sc = Vth / Rth;
plot(I_sc * 1000, 0, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'cyan');
text(I_sc * 1000 + 0.5, 0.5, ['I_{sc} = ' num2str(I_sc*1000, '%.1f') 'mA'], 'FontSize', 10);

hold off;

% 添加图例（只显示等效电路和实验电路）
legend([h_equiv, h_exp], ...
       '等效电路', ...
       '实验电路', ...
       'Location', 'best');

% 添加网格和美化
set(gca, 'GridAlpha', 0.3);