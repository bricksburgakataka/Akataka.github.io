%% Problem 2 Parts (c) and (d): Pulse Response Simulation
clear; close all; clc;

%% System Definition
% System: dy/dt + 3y = x
a = [1, 3];
b = [1];
sys = tf(b, a);

%% Time vector
t = -1:0.05:4;  % Include negative times to show causality

%% Part (c): Response to delta^Delta(t)
Delta_values = [0.1, 0.2, 0.4];
h_pulse_results = cell(3,1);
d_pulse_values = cell(3,1);

% Analytical impulse response for comparison
h_analytical = zeros(size(t));
for i = 1:length(t)
    if t(i) >= 0
        h_analytical(i) = exp(-3*t(i));
    end
end

figure('Name', 'Part (c): Pulse Response for Different Delta', 'Position', [100, 100, 1200, 800]);

for k = 1:3
    Delta = Delta_values(k);
    
    % Generate delta^Delta(t) pulse
    d_pulse = zeros(size(t));
    for i = 1:length(t)
        if t(i) >= 0 && t(i) < Delta
            d_pulse(i) = 1/Delta;  % Unit area pulse
        end
    end
    d_pulse_values{k} = d_pulse;
    
    % Note: delta^Delta(Delta) = 0 as specified
    % Our loop condition t(i) < Delta ensures this
    
    % Simulate response using lsim
    h_pulse = lsim(sys, d_pulse, t);
    h_pulse_results{k} = h_pulse;
    
    % Create separate figure for each Delta
    figure('Name', sprintf('Pulse Response for Delta = %.1f', Delta), 'Position', [100 + 50*(k-1), 100, 800, 500]);
    
    % Plot h^Delta(t) and h(t)
    plot(t, h_pulse, 'b-', 'LineWidth', 1.5, 'DisplayName', sprintf('h^{\\Delta}(t), \\Delta=%.1f', Delta));
    hold on;
    plot(t, h_analytical, 'r--', 'LineWidth', 1.5, 'DisplayName', 'h(t) = e^{-3t}u(t)');
    xlabel('t (sec)', 'FontSize', 12);
    ylabel('Amplitude', 'FontSize', 12);
    title(sprintf('Response to \\delta^{\\Delta}(t) with \\Delta = %.1f', Delta), 'FontSize', 14);
    legend('show', 'Location', 'best');
    grid on;
    xlim([-0.5, 2]);
    ylim([-0.1, 1.1]);
    
    % Add inset showing the pulse shape
    axes('Position', [0.65, 0.65, 0.25, 0.2]);
    t_pulse_zoom = -0.2:0.005:Delta+0.2;
    d_zoom = zeros(size(t_pulse_zoom));
    for i = 1:length(t_pulse_zoom)
        if t_pulse_zoom(i) >= 0 && t_pulse_zoom(i) < Delta
            d_zoom(i) = 1/Delta;
        end
    end
    plot(t_pulse_zoom, d_zoom, 'k-', 'LineWidth', 1);
    xlabel('t (sec)'); ylabel('\delta^{\Delta}(t)');
    title(sprintf('Input Pulse (\\Delta=%.1f)', Delta));
    grid on;
    xlim([-0.1, Delta+0.1]);
end

%% Plot all responses together for comparison
figure('Name', 'Comparison of Pulse Responses', 'Position', [100, 100, 1000, 600]);
colors = {'b', 'g', 'm'};
line_styles = {'-', '-', '-'};

for k = 1:3
    plot(t, h_pulse_results{k}, colors{k}, 'LineWidth', 1.5, ...
         'DisplayName', sprintf('\\Delta = %.1f', Delta_values(k)));
    hold on;
end
plot(t, h_analytical, 'r--', 'LineWidth', 2, 'DisplayName', 'h(t) (ideal)');
xlabel('t (sec)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
title('Comparison: Pulse Responses vs Ideal Impulse Response', 'FontSize', 14);
legend('show', 'Location', 'best');
grid on;
xlim([-0.5, 2]);
ylim([-0.1, 1.1]);

%% Quantitative Analysis
fprintf('\n=== Problem 2(c): Quantitative Analysis ===\n\n');
fprintf('Delta\t\tMax Error\t\tRMS Error\n');
fprintf('-----------------------------------------------\n');

for k = 1:3
    Delta = Delta_values(k);
    t_pos = t >= 0;  % Only consider t >= 0 for comparison
    error = h_pulse_results{k}(t_pos) - h_analytical(t_pos);
    max_err = max(abs(error));
    rms_err = sqrt(mean(error.^2));
    fprintf('%.1f\t\t%.4e\t\t%.4e\n', Delta, max_err, rms_err);
end

%% Part (d): Why unit area is necessary
fprintf('\n=== Problem 2(d): Importance of Unit Area ===\n\n');

% Generate D^Delta(t) pulse (unit height, area = Delta)
figure('Name', 'Part (d): Response to D^{Delta}(t)', 'Position', [100, 100, 1200, 800]);

for k = 1:3
    Delta = Delta_values(k);
    
    % Generate D^Delta(t) pulse (height = 1, area = Delta)
    D_pulse = zeros(size(t));
    for i = 1:length(t)
        if t(i) >= 0 && t(i) < Delta
            D_pulse(i) = 1;  % Height = 1, not 1/Delta
        end
    end
    
    % Simulate response
    h_D = lsim(sys, D_pulse, t);
    
    % Create figure
    figure('Name', sprintf('Response to D^{Delta}(t) with Delta = %.1f', Delta), 'Position', [100 + 50*(k-1), 100, 800, 500]);
    
    % Plot response and scaled impulse response
    plot(t, h_D, 'b-', 'LineWidth', 1.5, 'DisplayName', sprintf('Response to D^{\\Delta}(t)'));
    hold on;
    plot(t, Delta * h_analytical, 'r--', 'LineWidth', 1.5, 'DisplayName', sprintf('\\Delta \\cdot h(t) = %.1f e^{-3t}', Delta));
    plot(t, h_analytical, 'g:', 'LineWidth', 1.5, 'DisplayName', 'h(t) (ideal)');
    xlabel('t (sec)', 'FontSize', 12);
    ylabel('Amplitude', 'FontSize', 12);
    title(sprintf('Response to D^{\\Delta}(t) (Area = %.1f) with \\Delta = %.1f', Delta, Delta), 'FontSize', 14);
    legend('show', 'Location', 'best');
    grid on;
    xlim([-0.5, 2]);
    
    % Add explanation text
    annotation('textbox', [0.15, 0.8, 0.3, 0.1], ...
               'String', sprintf('Area of D^{\\Delta}(t) = %.1f\nResponse ≈ %.1f × h(t)', Delta, Delta), ...
               'FontSize', 10, 'BackgroundColor', 'w', 'EdgeColor', 'k');
end

%% Explanation of why unit area is necessary
fprintf('\nExplanation:\n');
fprintf('========================================\n');
fprintf('The pulse δ^Δ(t) has unit area by design:\n');
fprintf('  ∫ δ^Δ(t) dt = 1\n\n');
fprintf('When Δ → 0, δ^Δ(t) → δ(t), so the response approaches h(t).\n\n');
fprintf('If we use D^Δ(t) (height = 1, area = Δ):\n');
fprintf('  ∫ D^Δ(t) dt = Δ\n\n');
fprintf('Then the response is approximately Δ·h(t), not h(t).\n');
fprintf('This is because for a linear system:\n');
fprintf('  Response to scaled input = scaled response\n');
fprintf('  T{Δ·δ(t)} = Δ·T{δ(t)} = Δ·h(t)\n\n');
fprintf('Therefore, to approximate the impulse response accurately,\n');
fprintf('the pulse must have unit area. Otherwise, the response is\n');
fprintf('scaled by the area of the pulse.\n');