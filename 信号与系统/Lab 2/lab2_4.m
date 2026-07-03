%% Problem 2 Part (e): Response to d_a(t) = a * e^(-a*t) * u(t)
clear; close all; clc;

%% System definition
a_sys = [1, 3];  % dy/dt + 3y = x
b_sys = [1];
sys = tf(b_sys, a_sys);

%% Time vector
t = -1:0.05:4;

%% Analytical impulse response h(t) for comparison
h_analytical = zeros(size(t));
for i = 1:length(t)
    if t(i) >= 0
        h_analytical(i) = exp(-3*t(i));
    end
end

%% Values of a
a_vals = [4, 8, 16];

%% Store responses
da_values = cell(3,1);
response_values = cell(3,1);

%% Calculate area of d_a(t)
fprintf('\n=== Problem 2(e): Area of d_a(t) ===\n');
fprintf('d_a(t) = a * e^{-at} * u(t)\n');
fprintf('Area = ∫_0^∞ a e^{-at} dt = 1 (independent of a)\n\n');

%% Simulate for each a
for k = 1:3
    a = a_vals(k);
    
    % Generate d_a(t)
    da = zeros(size(t));
    for i = 1:length(t)
        if t(i) >= 0
            da(i) = a * exp(-a * t(i));
        end
    end
    da_values{k} = da;
    
    % Simulate response using lsim
    response = lsim(sys, da, t);
    response_values{k} = response;
    
    % Create figure
    figure('Name', sprintf('Response to d_a(t) with a = %d', a), 'Position', [100 + 50*(k-1), 100, 800, 500]);
    
    % Plot response and impulse response
    plot(t, response, 'b-', 'LineWidth', 1.5, 'DisplayName', sprintf('Response to d_a(t), a=%d', a));
    hold on;
    plot(t, h_analytical, 'r--', 'LineWidth', 1.5, 'DisplayName', 'h(t) = e^{-3t}u(t)');
    xlabel('t (sec)', 'FontSize', 12);
    ylabel('Amplitude', 'FontSize', 12);
    title(sprintf('Response to d_a(t) = %d e^{-%d t} u(t)', a, a), 'FontSize', 14);
    legend('show', 'Location', 'best');
    grid on;
    xlim([-0.5, 2]);
    ylim([-0.1, 1.1]);
    
    % Add inset showing d_a(t)
    axes('Position', [0.65, 0.65, 0.25, 0.2]);
    t_zoom = -0.1:0.002:1;
    da_zoom = zeros(size(t_zoom));
    for i = 1:length(t_zoom)
        if t_zoom(i) >= 0
            da_zoom(i) = a * exp(-a * t_zoom(i));
        end
    end
    plot(t_zoom, da_zoom, 'k-', 'LineWidth', 1);
    xlabel('t (sec)', 'FontSize', 8);
    ylabel('d_a(t)', 'FontSize', 8);
    title(sprintf('Input d_a(t), a=%d', a), 'FontSize', 8);
    grid on;
    xlim([-0.05, 0.5]);
end

%% Comparison plot: all responses together
figure('Name', 'Comparison of Responses for Different a', 'Position', [100, 100, 1000, 600]);
colors = {'b', 'g', 'm'};
line_styles = {'-', '-', '-'};

for k = 1:3
    plot(t, response_values{k}, colors{k}, 'LineWidth', 1.5, ...
         'DisplayName', sprintf('a = %d', a_vals(k)));
    hold on;
end
plot(t, h_analytical, 'r--', 'LineWidth', 2, 'DisplayName', 'h(t) (ideal)');
xlabel('t (sec)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
title('Comparison: Response to d_a(t) vs Ideal Impulse Response', 'FontSize', 14);
legend('show', 'Location', 'best');
grid on;
xlim([-0.5, 2]);
ylim([-0.1, 1.1]);

%% Quantitative error analysis
fprintf('=== Quantitative Analysis ===\n');
fprintf('a\t\tMax Error\t\tRMS Error\n');
fprintf('-----------------------------------------------\n');

for k = 1:3
    a = a_vals(k);
    t_pos = t >= 0;
    error = response_values{k}(t_pos) - h_analytical(t_pos);
    max_err = max(abs(error));
    rms_err = sqrt(mean(error.^2));
    fprintf('%d\t\t%.4e\t\t%.4e\n', a, max_err, rms_err);
end

%% Additional: Plot d_a(t) inputs for comparison
figure('Name', 'Input Functions d_a(t)', 'Position', [100, 100, 800, 500]);
for k = 1:3
    a = a_vals(k);
    da = da_values{k};
    plot(t, da, 'LineWidth', 1.5, 'DisplayName', sprintf('a = %d', a));
    hold on;
end
xlabel('t (sec)', 'FontSize', 12);
ylabel('d_a(t)', 'FontSize', 12);
title('Input Functions d_a(t) = a e^{-at} u(t)', 'FontSize', 14);
legend('show', 'Location', 'best');
grid on;
xlim([-0.1, 0.8]);
ylim([-0.5, 18]);

%% Observations
fprintf('\n=== Observations ===\n');
fprintf('1. d_a(t) has unit area for all a (area = 1).\n');
fprintf('2. As a increases, d_a(t) becomes narrower and taller.\n');
fprintf('3. As a increases, the response approaches h(t).\n');
fprintf('4. For a = 16, the response is practically identical to h(t).\n');
fprintf('5. This confirms that d_a(t) approximates δ(t) as a → ∞.\n');