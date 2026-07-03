%% Problem 3 (h) through (l): Third-Order System
% Equation: d^3y/dt^3 + d^2y/dt^2 + 24dy/dt - 26y = d^2x/dt^2 + 7dx/dt + 21x

clear; close all; clc;

%% (h) System function, poles, zeros, ROC, stability
% H(s) = (s^2 + 7s + 21) / (s^3 + s^2 + 24s - 26)

b = [1, 7, 21];
a = [1, 1, 24, -26];

% Find poles and zeros
zeros_h = roots(b);
poles_h = roots(a);

disp('=== (h) Third-Order System Analysis ===');
disp('Zeros:');
disp(zeros_h);
disp('Poles:');
disp(poles_h);

% Plot pole-zero diagram
figure('Name', 'Problem 3(h): Pole-Zero Diagram');
plot(real(zeros_h), imag(zeros_h), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
hold on;
plot(real(poles_h), imag(poles_h), 'bx', 'MarkerSize', 8, 'LineWidth', 1.5);
grid on;
axis equal;
xlabel('Real'); ylabel('Imag');
title('Pole-Zero Diagram for H(s) = (s^2+7s+21)/(s^3+s^2+24s-26)');
legend('Zeros', 'Poles', 'Location', 'best');

% Determine ROC for stability
real_poles = sort(real(poles_h));
disp(' ');
disp('Real parts of poles (sorted):');
disp(real_poles);
disp(' ');
disp('Possible ROCs:');
disp(['1. Re(s) > ', num2str(max(real_poles), '%.2f'), ' (causal, UNSTABLE)']);
disp(['2. ', num2str(real_poles(2), '%.2f'), ' < Re(s) < ', num2str(real_poles(3), '%.2f'), ' (noncausal, STABLE)']);
disp(['3. Re(s) < ', num2str(min(real_poles), '%.2f'), ' (anticausal, UNSTABLE)']);
disp(' ');
disp(['Stable system ROC: ', num2str(real_poles(2), '%.2f'), ' < Re(s) < ', num2str(real_poles(3), '%.2f')]);

%% (i) Partial fraction expansion using residue
disp('=== (i) Partial Fraction Expansion ===');
[r, p, k] = residue(b, a);
disp('Residues:');
disp(r);
disp('Poles:');
disp(p);
disp('Constant term (k):');
disp(k);

% Display partial fraction form
disp('Partial fraction expansion:');
for i = 1:length(r)
    if imag(r(i)) == 0
        fprintf('  %.4f / (s - %.4f)\n', r(i), p(i));
    else
        fprintf('  %.4f + %.4fi / (s - %.4f + %.4fi)\n', real(r(i)), imag(r(i)), real(p(i)), imag(p(i)));
    end
end

% Impulse responses for different ROCs
disp(' ');
disp('Impulse responses for each ROC:');
disp('1. ROC: Re(s) > max(p) (causal, unstable):');
disp('   h(t) = sum(r_i * e^{p_i t}) u(t)');
disp('2. ROC: middle region (stable, noncausal):');
disp('   - Terms with poles in left half-plane: causal');
disp('   - Terms with poles in right half-plane: anticausal');
disp('3. ROC: Re(s) < min(p) (anticausal, unstable):');
disp('   h(t) = -sum(r_i * e^{p_i t}) u(-t)');

%% (j) Causal system verification using impulse
disp('=== (j) Causal Impulse Response ===');
t_causal = 0:0.01:5;
h_causal = impulse(b, a, t_causal);

figure('Name', 'Problem 3(j): Causal Impulse Response (Unstable)');
plot(t_causal, h_causal, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('t'); ylabel('h(t)');
title('Causal Impulse Response (Unstable System)');
disp('Auxiliary conditions for causal system: Initial rest');
disp('  y(t) = 0 for t < t0 (all derivatives zero at t0)');

%% (k) Anticausal system verification using impulse
disp('=== (k) Anticausal Impulse Response ===');
% Time-reversal method for anticausal system
% H_rev(s) = H(-s) = (s^2 - 7s + 21) / (-s^3 + s^2 - 24s - 26)
% Multiply numerator and denominator by -1 to make leading coefficient positive
b_rev = [1, -7, 21];
a_rev = [-1, 1, -24, -26];
a_rev = -a_rev;  % Now a_rev = [1, -1, 24, 26]

% Compute impulse response of time-reversed causal system
t_pos = 0:0.01:5;
w = impulse(b_rev, a_rev, t_pos);
w = w(:)';

% Time-reverse to get anticausal impulse response
% w(t) = y(-t), so y(t) = w(-t) for t <= 0
t_neg = -5:0.01:0;
% Map: y(t) for negative t corresponds to w(|t|)
n_neg = length(t_neg);
if length(w) >= n_neg
    h_anticausal = fliplr(w(1:n_neg));
else
    h_anticausal = [fliplr(w), zeros(1, n_neg - length(w))];
end

figure('Name', 'Problem 3(k): Anticausal Impulse Response');
plot(t_neg, h_anticausal, 'r-', 'LineWidth', 1.5);
grid on;
xlabel('t'); ylabel('h(t)');
title('Anticausal Impulse Response (Unstable System)');
disp('Auxiliary conditions for anticausal system: Final rest');
disp('  y(t) = 0 for t > t0 (all derivatives zero at t0)');

%% (l) Parallel realization for stable (noncausal) system
disp('=== (l) Parallel Realization for Stable System ===');

% For stable system, ROC is between poles: p_middle < Re(s) < p_max
% Decompose H(s) into causal part (left-half plane poles) and 
% anticausal part (right-half plane poles)

% From partial fraction expansion:
% H(s) = r1/(s-p1) + r2/(s-p2) + r3/(s-p3)
% where p1 is the positive real pole (unstable), p2,p3 are complex with negative real part

% Sort poles by real part
[real_poles_sorted, idx] = sort(real(poles_h));
p_sorted = poles_h(idx);
r_sorted = r(idx);

% Find which poles are in left half-plane (real part < 0) and right half-plane (real part > 0)
lhp_poles = p_sorted(real_poles_sorted < 0);  % left-half plane poles (stable)
rhp_poles = p_sorted(real_poles_sorted > 0);  % right-half plane poles (unstable)

lhp_residues = r_sorted(real_poles_sorted < 0);
rhp_residues = r_sorted(real_poles_sorted > 0);

disp('Left-half plane poles (causal part):');
disp(lhp_poles);
disp('Right-half plane poles (anticausal part):');
disp(rhp_poles);

% Combine causal part (left-half plane poles) into a single rational function
[b_causal, a_causal] = residue(lhp_residues, lhp_poles, 0);

% For anticausal part (right-half plane poles), we need time-reversed system
% H_anticausal(s) with left-sided ROC
% Time-reversed: H_rev(s) = H_anticausal(-s)
% For a single pole: r/(s-p) with Re(s) < Re(p) becomes -r/(s+p) causal

b_anticausal_rev = [];
a_anticausal_rev = [1];
for i = 1:length(rhp_poles)
    % Each term: r/(s-p) with left-sided ROC
    % After time-reversal: -r/(s+p) causal
    b_term = [-rhp_residues(i)];
    a_term = [1, rhp_poles(i)];  % s + p
    % Combine (for parallel, we sum - but for simulation we'll do separately)
    if i == 1
        b_anticausal_rev = b_term;
        a_anticausal_rev = a_term;
    else
        % For parallel combination, we would need to add rational functions
        % For simplicity, we'll simulate each term separately or use lsim with state-space
        disp(['Term ', num2str(i), ': ', num2str(-rhp_residues(i)), '/(s + ', num2str(rhp_poles(i)), ')']);
    end
end

% Create test input for simulation
t_test = -5:0.01:5;
% Test input: a pulse or decaying signal
x_test = exp(-abs(t_test)/2);

% Compute causal part output
y_causal = lsim(b_causal, a_causal, x_test, t_test);

% Compute anticausal part using time-reversal method
% For anticausal part: H_ac(s) = sum(r_i/(s-p_i)) with left-sided ROC
% Step 1: Time-reverse input
x_rev = fliplr(x_test);
t_rev = fliplr(t_test);

% Step 2: Simulate time-reversed causal system
% For each term in anticausal part: H_rev(s) = -r/(s+p)
% Combine all terms
b_ac_rev = [];
a_ac_rev = [1];
for i = 1:length(rhp_poles)
    b_term = [-rhp_residues(i)];
    a_term = [1, rhp_poles(i)];
    if i == 1
        b_ac_rev = b_term;
        a_ac_rev = a_term;
    else
        % Add rational functions: b1/a1 + b2/a2 = (b1*a2 + b2*a1)/(a1*a2)
        b_new = conv(b_ac_rev, a_term) + conv(b_term, a_ac_rev);
        a_new = conv(a_ac_rev, a_term);
        b_ac_rev = b_new;
        a_ac_rev = a_new;
    end
end

% Simulate time-reversed anticausal part
w_anticausal = lsim(b_ac_rev, a_ac_rev, x_rev, t_rev);
w_anticausal = w_anticausal(:)';

% Time-reverse to get anticausal part output
y_anticausal = fliplr(w_anticausal);

% Total output
y_total = y_causal + y_anticausal;

% Plot parallel realization results
figure('Name', 'Problem 3(l): Parallel Realization for Stable System');

subplot(4,1,1);
plot(t_test, x_test, 'k-', 'LineWidth', 1.5);
grid on; xlabel('t'); ylabel('x(t)');
title('Input Signal');

subplot(4,1,2);
plot(t_test, y_causal, 'b-', 'LineWidth', 1.5);
grid on; xlabel('t'); ylabel('y_{causal}(t)');
title('Causal Part Output');

subplot(4,1,3);
plot(t_test, y_anticausal, 'r-', 'LineWidth', 1.5);
grid on; xlabel('t'); ylabel('y_{anticausal}(t)');
title('Anticausal Part Output');

subplot(4,1,4);
plot(t_test, y_total, 'g-', 'LineWidth', 1.5);
grid on; xlabel('t'); ylabel('y_{total}(t)');
title('Total Output (Causal + Anticausal)');

disp(' ');
disp('Parallel realization complete.');
disp('Stable noncausal system implemented as:');
disp('  H(s) = H_causal(s) + H_anticausal(s)');
disp('  - Causal part: left-half plane poles (simulated directly with lsim)');
disp('  - Anticausal part: right-half plane poles (simulated using time-reversal)');