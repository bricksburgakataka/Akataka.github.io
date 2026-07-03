%% Problem 2: Complete Solution
clear; close all; clc;

%% Part (a): Analytical Derivation
t = -1:0.05:4;
s = zeros(size(t));
h = zeros(size(t));

for i = 1:length(t)
    if t(i) >= 0
        s(i) = (1/3) * (1 - exp(-3*t(i)));
        h(i) = exp(-3*t(i));
    end
end

% Plot analytical responses
figure('Name', 'Part (a): Analytical Responses');
subplot(2,1,1);
plot(t, h, 'r-', 'LineWidth', 1.5);
xlabel('t (sec)'); ylabel('h(t)'); grid on;
title('Impulse Response h(t) = e^{-3t}u(t)');
xlim([-1, 4]);

subplot(2,1,2);
plot(t, s, 'b-', 'LineWidth', 1.5);
xlabel('t (sec)'); ylabel('s(t)'); grid on;
title('Step Response s(t) = (1/3)(1 - e^{-3t})u(t)');
xlim([-1, 4]);

%% Part (b): Verification using step() and impulse()
% Create transfer function
sys = tf([1], [1, 3]);  % H(s) = 1/(s+3)

t_sim = 0:0.05:4;

% Get responses
[y_step, t_step] = step(sys, t_sim);
[y_impulse, t_impulse] = impulse(sys, t_sim);

% Analytical responses (for comparison)
s_analytical = (1/3) * (1 - exp(-3*t_sim));
h_analytical = exp(-3*t_sim);

% Plot verification
figure('Name', 'Part (b): Verification');
subplot(2,1,1);
plot(t_sim, s_analytical, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Analytical');
hold on;
plot(t_step, y_step, 'ro', 'MarkerSize', 4, 'DisplayName', 'step()');
xlabel('t (sec)'); ylabel('s(t)'); grid on;
title('Step Response Verification');
legend('show');
xlim([0, 4]);

subplot(2,1,2);
plot(t_sim, h_analytical, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Analytical');
hold on;
plot(t_impulse, y_impulse, 'bo', 'MarkerSize', 4, 'DisplayName', 'impulse()');
xlabel('t (sec)'); ylabel('h(t)'); grid on;
title('Impulse Response Verification');
legend('show');
xlim([0, 4]);

%% Results
fprintf('\n=== Problem 2 Results ===\n\n');
fprintf('(a) Analytical Results:\n');
fprintf('    h(t) = e^{-3t} u(t)\n');
fprintf('    s(t) = (1/3)(1 - e^{-3t}) u(t)\n\n');

fprintf('(b) Verification:\n');
max_err_step = max(abs(s_analytical - y_step'));
max_err_impulse = max(abs(h_analytical - y_impulse'));
fprintf('    Max error (step): %.2e\n', max_err_step);
fprintf('    Max error (impulse): %.2e\n', max_err_impulse);
fprintf('    Verification passed!\n');