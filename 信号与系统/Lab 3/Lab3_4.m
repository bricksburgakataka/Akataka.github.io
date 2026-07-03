%% Problem 3(g): Verify anticausal system output using lsim
% Differential equation: dy/dt + 2y = x
% Anticausal system: h(t) = -e^{-2t}u(-t)
% Input: x(t) = e^(5t/2) u(-t)
% Expected output: y(t) = (2/9)*(e^(5t/2) - e^{-2t}) u(-t)

clear; close all; clc;

%% Define time vectors
dt = 0.01;
t_neg = -5:dt:0;       % negative time (where output is nonzero)
t_pos = 0:dt:5;        % positive time (for simulation)
t_full = -5:dt:5;      % full time range

%% Input signal: x(t) = e^(5t/2) u(-t)
x = exp(5*t_neg/2);

%% Time-reversal method for anticausal system
%
% Step 1: Time-reverse the input to get r(t) for t >= 0
% r(t) = x(-t) = e^{5(-t)/2} = e^{-5t/2} for t >= 0
r = exp(-5*t_pos/2);   % note: using t_pos, not t_neg

%% Step 2: Define time-reversed causal system
% Original: dy/dt + 2y = x
% Substitute t -> -t: -dy(-t)/dt + 2y(-t) = x(-t)
% Let w(t) = y(-t), r(t) = x(-t)
% Then: -dw/dt + 2w = r  =>  dw/dt - 2w = -r
% Laplace: sW(s) - 2W(s) = -R(s)  =>  H_rev(s) = -1/(s-2)
b_rev = [-1];      % numerator: -1
a_rev = [1, -2];   % denominator: s - 2

%% Step 3: Simulate w(t) using lsim (causal system)
% w(t) is the response of the time-reversed causal system to input r(t)
w = lsim(b_rev, a_rev, r, t_pos);
w = w(:)';  % ensure row vector

%% Step 4: Time-reverse to get y(t) for original anticausal system
% w(t) = y(-t), so y(t) = w(-t)
% For t from -5 to 0, y(t) corresponds to w(|t|)
y_sim = fliplr(w);

%% Analytical output for comparison
y_analytical = (2/9)*(exp(5*t_neg/2) - exp(-2*t_neg));

%% Plot results
figure('Name', 'Problem 3(g): lsim Verification');

% Plot 1: Input signal
subplot(3,1,1);
plot(t_neg, x, 'k-', 'LineWidth', 1.5);
grid on;
xlabel('t'); ylabel('x(t)');
title('Input: x(t) = e^{5t/2}u(-t)');
xlim([-5, 1]);

% Plot 2: lsim simulation result vs analytical
subplot(3,1,2);
plot(t_neg, y_sim, 'b-', 'LineWidth', 1.5);
hold on;
plot(t_neg, y_analytical, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('t'); ylabel('y(t)');
title('Output: Anticausal System Response');
legend('lsim (time-reversal)', 'Analytical: (2/9)(e^{5t/2} - e^{-2t})', 'Location', 'best');
xlim([-5, 1]);

% Plot 3: Error between simulation and analytical
subplot(3,1,3);
error = abs(y_sim - y_analytical);
semilogy(t_neg, error, 'g-', 'LineWidth', 1.5);  % use semilogy for better visualization
grid on;
xlabel('t'); ylabel('Error');
title('Simulation Error');
xlim([-5, 1]);

%% Display results in command window
disp('=== Problem 3(g): lsim Verification ===');
disp(' ');
disp('Input: x(t) = e^(5t/2) u(-t)');
disp('Expected output: y(t) = (2/9)*(e^(5t/2) - e^{-2t}) u(-t)');
disp(' ');
disp('Time-reversal method used:');
disp('  1. r(t) = x(-t) = e^{-5t/2} for t >= 0');
disp('  2. Time-reversed causal system: dw/dt - 2w = -r');
disp('  3. Coefficients: b_rev = [-1], a_rev = [1, -2]');
disp('  4. w = lsim(b_rev, a_rev, r, t_pos)');
disp('  5. y(t) = w(-t) (time-reverse)');
disp(' ');
disp(['Maximum simulation error: ', num2str(max(error), '%e')]);

if max(error) < 1e-10
    disp('✓ Simulation matches analytical result perfectly.');
else
    disp('✗ Check time vector lengths and coefficients.');
end