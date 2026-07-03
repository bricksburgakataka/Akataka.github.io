%% Problem 3(p): Parallel Realization for Stable Noncausal System
clear; close all; clc;

%% Get partial fraction expansion from part (i)
b = [1, 7, 21];
a = [1, 1, 24, -26];
[r, p, k] = residue(b, a);

% Sort poles by real part
[real_poles, idx] = sort(real(p));
p_sorted = p(idx);
r_sorted = r(idx);

% Separate poles
lhp_poles = p_sorted(real_poles < 0);   % left-half plane (causal)
rhp_poles = p_sorted(real_poles > 0);   % right-half plane (anticausal)
lhp_residues = r_sorted(real_poles < 0);
rhp_residues = r_sorted(real_poles > 0);

% Combine causal part
[b1, a1] = residue(lhp_residues, lhp_poles, 0);
b1 = real(b1);
a1 = real(a1);

%% (p) Simulation
% Time vector (must be monotonically increasing)
t = -10:0.01:10;

% Input signal: x(t) = 1 for -3 <= t <= 2, 0 otherwise
x = zeros(size(t));
x(t >= -3 & t <= 2) = 1;

%% Causal part H1(s): simulate directly
y1 = lsim(b1, a1, x, t);

%% Anticausal part H2(s): time-reversal method
% IMPORTANT: lsim requires monotonically increasing time vector

% Step 1: Create monotonically increasing time vector for reversed system
t_rev_forward = 0:0.01:20;  % from 0 to 20 (covers |t| from 0 to 10)

% Step 2: Time-reverse input to get r(t) for t >= 0
% x(t) is defined on [-10,10], x_rev(t) = x(-t) for t in [0,20]
x_rev = zeros(size(t_rev_forward));
for i = 1:length(t_rev_forward)
    orig_t = -t_rev_forward(i);  % map t_rev to original t
    % Find corresponding x value
    idx = find(abs(t - orig_t) < 0.005, 1);
    if ~isempty(idx)
        x_rev(i) = x(idx);
    end
end

% Step 3: Time-reversed causal system: H_rev(s) = -r1/(s + p1)
r1 = rhp_residues(1);
p1 = rhp_poles(1);
b_rev = [-r1];
a_rev = [1, p1];

% Step 4: Simulate reversed system (causal, t >= 0)
w = lsim(b_rev, a_rev, x_rev, t_rev_forward);
w = w(:)';

% Step 5: Time-reverse to get y2(t) for original time
% w(t) corresponds to y2(-t), so y2(t) = w(|t|)
y2 = zeros(size(t));
for i = 1:length(t)
    if t(i) <= 0
        idx = find(abs(t_rev_forward - (-t(i))) < 0.005, 1);
        if ~isempty(idx)
            y2(i) = w(idx);
        end
    end
end

%% Total output
y = y1 + y2;

%% Plot results
figure('Name', 'Problem 3(p): Parallel Realization');

subplot(4,1,1);
plot(t, x, 'k-', 'LineWidth', 1.5);
grid on; ylabel('x(t)');
title('Input: x(t) = 1 for -3 \leq t \leq 2, 0 otherwise');
xlim([-10, 10]); ylim([-0.5, 1.5]);

subplot(4,1,2);
plot(t, y1, 'b-', 'LineWidth', 1.5);
grid on; ylabel('y_1(t)');
title('Causal Part Output (H_1(s))');
xlim([-10, 10]);

subplot(4,1,3);
plot(t, y2, 'r-', 'LineWidth', 1.5);
grid on; ylabel('y_2(t)');
title('Anticausal Part Output (H_2(s))');
xlim([-10, 10]);

subplot(4,1,4);
plot(t, y, 'g-', 'LineWidth', 1.5);
grid on; ylabel('y(t)');
title('Total Output: y(t) = y_1(t) + y_2(t)');
xlabel('t');
xlim([-10, 10]);

disp('Simulation complete.');