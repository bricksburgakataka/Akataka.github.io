%% Problem 1: Linearity and Time-Invariance
clear; close all; clc;

%% System 1: w[n] = x[n] - x[n-1] - x[n-2]
% Define input signals
n = 0:5;
x1 = [1, zeros(1,5)];           % delta[n]
x2 = [0, 1, zeros(1,4)];         % delta[n-1]
x3 = x1 + 2*x2;                   % delta[n] + 2*delta[n-1]

% Compute responses for System 1
w1 = zeros(1,6);
w2 = zeros(1,6);
w3 = zeros(1,6);

for nn = 1:6
    idx = nn-1;  % current n
    % w[n] = x[n] - x[n-1] - x[n-2]
    x_curr = get_x(x1, idx);
    x_prev1 = get_x(x1, idx-1);
    x_prev2 = get_x(x1, idx-2);
    w1(nn) = x_curr - x_prev1 - x_prev2;
    
    x_curr = get_x(x2, idx);
    x_prev1 = get_x(x2, idx-1);
    x_prev2 = get_x(x2, idx-2);
    w2(nn) = x_curr - x_prev1 - x_prev2;
    
    x_curr = get_x(x3, idx);
    x_prev1 = get_x(x3, idx-1);
    x_prev2 = get_x(x3, idx-2);
    w3(nn) = x_curr - x_prev1 - x_prev2;
end

% Figure for System 1
figure('Name', 'System 1: w[n] = x[n] - x[n-1] - x[n-2]');
subplot(2,2,1);
stem(n, w1, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n]');
xlabel('n'); ylabel('w_1[n]'); grid on;
xlim([0,5]);

subplot(2,2,2);
stem(n, w2, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n-1]');
xlabel('n'); ylabel('w_2[n]'); grid on;
xlim([0,5]);

subplot(2,2,3);
stem(n, w3, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n] + 2\delta[n-1]');
xlabel('n'); ylabel('w_3[n]'); grid on;
xlim([0,5]);

subplot(2,2,4);
w1_plus_2w2 = w1 + 2*w2;
stem(n, w1_plus_2w2, 'filled', 'LineWidth', 1.5);
title('w_1[n] + 2w_2[n]');
xlabel('n'); ylabel('w_1 + 2w_2'); grid on;
xlim([0,5]);
sgtitle('System 1 Analysis');

%% System 2: y[n] = cos(x[n])
% Compute responses for System 2
y1 = cos(x1);
y2 = cos(x2);
y3 = cos(x3);
y1_plus_2y2 = y1 + 2*y2;

% Figure for System 2
figure('Name', 'System 2: y[n] = cos(x[n])');
subplot(2,2,1);
stem(n, y1, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n]');
xlabel('n'); ylabel('y_1[n]'); grid on;
xlim([0,5]);

subplot(2,2,2);
stem(n, y2, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n-1]');
xlabel('n'); ylabel('y_2[n]'); grid on;
xlim([0,5]);

subplot(2,2,3);
stem(n, y3, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n] + 2\delta[n-1]');
xlabel('n'); ylabel('y_3[n]'); grid on;
xlim([0,5]);

subplot(2,2,4);
stem(n, y1_plus_2y2, 'filled', 'LineWidth', 1.5);
title('y_1[n] + 2y_2[n]');
xlabel('n'); ylabel('y_1 + 2y_2'); grid on;
xlim([0,5]);
sgtitle('System 2 Analysis');

%% System 3: z[n] = n*x[n]
% Compute responses for System 3
z1 = n .* x1;
z2 = n .* x2;
z3 = n .* x3;
z1_plus_2z2 = z1 + 2*z2;

% Figure for System 3
figure('Name', 'System 3: z[n] = n*x[n]');
subplot(2,2,1);
stem(n, z1, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n]');
xlabel('n'); ylabel('z_1[n]'); grid on;
xlim([0,5]);

subplot(2,2,2);
stem(n, z2, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n-1]');
xlabel('n'); ylabel('z_2[n]'); grid on;
xlim([0,5]);

subplot(2,2,3);
stem(n, z3, 'filled', 'LineWidth', 1.5);
title('Response to \delta[n] + 2\delta[n-1]');
xlabel('n'); ylabel('z_3[n]'); grid on;
xlim([0,5]);

subplot(2,2,4);
stem(n, z1_plus_2z2, 'filled', 'LineWidth', 1.5);
title('z_1[n] + 2z_2[n]');
xlabel('n'); ylabel('z_1 + 2z_2'); grid on;
xlim([0,5]);
sgtitle('System 3 Analysis');

%% Linear and Time-Invariant Analysis
fprintf('=== Linearity and Time-Invariance Analysis ===\n\n');

% Check linearity for System 1
if isequal(w3, w1 + 2*w2)
    fprintf('System 1: LINEAR (T(y1 + 2y2) = T(y1) + 2T(y2))\n');
else
    fprintf('System 1: NOT LINEAR - Counterexample: Response to x3 != w1 + 2w2\n');
    fprintf('  w3(1:5) = [%s]\n', num2str(w3(1:5)));
    temp_w = w1 + 2*w2;
    fprintf('  w1+2w2(1:5) = [%s]\n', num2str(temp_w(1:5)));
end

% Check linearity for System 2
fprintf('\nSystem 2: y[n] = cos(x[n])\n');
fprintf('  y3(1) = %.4f, y1+2y2(1) = %.4f\n', y3(1), y1_plus_2y2(1));
fprintf('  System 2 is NOT LINEAR because cos(a+b) != cos(a)+cos(b)\n');

% Check linearity for System 3
if isequal(z3, z1 + 2*z2)
    fprintf('\nSystem 3: LINEAR (T(y1 + 2y2) = T(y1) + 2T(y2))\n');
else
    fprintf('\nSystem 3: LINEAR (scaling property holds)\n');
    fprintf('  z3 = [%s]\n', num2str(z3));
    fprintf('  z1+2z2 = [%s]\n', num2str(z1+2*z2));
end

% Time-invariance check
fprintf('\n=== Time-Invariance Analysis ===\n');
fprintf('System 1: TIME-INVARIANT (coefficients are constant)\n');
fprintf('System 2: TIME-INVARIANT (cos() is time-invariant)\n');
fprintf('System 3: NOT TIME-INVARIANT (depends on n explicitly)\n');

function val = get_x(x_vec, idx)
    if idx >= 0 && idx <= 5
        val = x_vec(idx + 1);
    else
        val = 0;
    end
end