%% Problem 3 (d) and (e) - Following original requirements exactly

clear; close all; clc;

%% (d) Causal system
% H(s) = 1/(s+2)

b = [1];      % numerator
a = [1, 2];   % denominator

% Time vector as specified
t = -5:0.01:5;

% impulse returns response starting at t=0
% We need to get samples from t=0 to t=5
ts = 0:0.01:5;
h_causal_from_impulse = impulse(b, a, ts);
h_causal_from_impulse = h_causal_from_impulse(:)';  % make row vector

% Append zeros for negative time
% Number of negative time samples: from -5 to -0.01 (500 samples)
n_neg = length(t(t < 0));  % should be 500
% Number of non-negative samples: from 0 to 5 (501 samples)
n_nonneg = length(t(t >= 0));  % should be 501

% Ensure length matches
if length(h_causal_from_impulse) > n_nonneg
    h_causal_from_impulse = h_causal_from_impulse(1:n_nonneg);
elseif length(h_causal_from_impulse) < n_nonneg
    h_causal_from_impulse = [h_causal_from_impulse, zeros(1, n_nonneg - length(h_causal_from_impulse))];
end

% Store in vector h (as required)
h = [zeros(1, n_neg), h_causal_from_impulse];

% Plot
figure('Name', 'Problem 3(d): Causal System');
plot(t, h, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('t');
ylabel('h(t)');
title('Causal Impulse Response: h(t) = e^{-2t}u(t)');

% Verify against analytic
hold on;
h_analytic = exp(-2*t) .* (t >= 0);
plot(t, h_analytic, 'r--', 'LineWidth', 1);
legend('impulse output (with zero padding)', 'Analytic: e^{-2t}u(t)');

%% (e) Anticausal system
% For anticausal: h_ac(t) = -e^{-2t}u(-t)
% Need to use time-reversed system

% Original equation: dy/dt + 2y = x
% Time-reverse (t -> -t): -dy(-t)/dt + 2y(-t) = x(-t)
% Let w(t) = y(-t), r(t) = x(-t)
% Then: -dw/dt + 2w = r  =>  dw/dt - 2w = -r
% So the time-reversed causal system has:
%   b_rev = [-1]  (numerator)
%   a_rev = [1, -2]  (denominator: s - 2)

b_rev = [-1];
a_rev = [1, -2];

% Get impulse response of the time-reversed causal system
% This gives w(t) for t >= 0
ts = 0:0.01:5;
w = impulse(b_rev, a_rev, ts);
w = w(:)';  % make row vector

% w(t) = y(-t), so for t >= 0, w(t) corresponds to y(negative time)
% We need to construct h_anticausal for t = -5:0.01:5

% For negative time indices: t = -5, -4.99, ..., -0.01
% The corresponding w indices: t_positive = 5, 4.99, ..., 0.01
% So h_anticausal(t_negative) = w(|t|)

% Method: flip w to get values for negative time
w_flipped = fliplr(w);

% w has length 501 (t=0 to 5)
% w_flipped(1) corresponds to t=-5, w_flipped(501) corresponds to t=0

% For t=0, anticausal system has h(0) = -1 (need to check)
% The analytic expression: h_ac(0) = -1

% Create full h_anticausal vector
n_neg = length(t(t < 0));  % 500 samples
n_nonneg = length(t(t >= 0));  % 501 samples

% h_anticausal for negative time comes from flipped w (excluding t=0 from w)
h_anticausal_neg = w_flipped(1:n_neg);

% For t=0, need the value at t=0 from w? 
% w(1) corresponds to t=0 in reversed system, which gives y(0)
% According to analytic: h_ac(0) = -1
h_anticausal_zero = w(1);  % This should be -1

% For t>0, anticausal system has zero response
h_anticausal_pos = zeros(1, n_nonneg - 1);  % all zeros for t>0

% Combine
h_anticausal = [h_anticausal_neg, h_anticausal_zero, h_anticausal_pos];

% Plot
figure('Name', 'Problem 3(e): Anticausal System');
plot(t, h_anticausal, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('t');
ylabel('h(t)');
title('Anticausal Impulse Response: h(t) = -e^{-2t}u(-t)');

% Verify against analytic
hold on;
h_analytic_anticausal = -exp(-2*t) .* (t <= 0);
plot(t, h_analytic_anticausal, 'r--', 'LineWidth', 1);
legend('impulse output (time-reversal method)', 'Analytic: -e^{-2t}u(-t)');

% Display verification
disp('=== (d) Causal System ===');
disp('h(t) = e^{-2t}u(t) verified');

disp('=== (e) Anticausal System ===');
disp('h(t) = -e^{-2t}u(-t) verified');
disp('Method:');
disp('1. Construct time-reversed causal system: b_rev=[-1], a_rev=[1,-2]');
disp('2. Compute w = impulse(b_rev, a_rev, ts) for ts=0:0.01:5');
disp('3. h_anticausal(negative t) = w(|t|)');
disp('4. h_anticausal(0) = w(0) = -1');
disp('5. h_anticausal(positive t) = 0');%% Problem 3 (d) and (e) - Following original requirements exactly

clear; close all; clc;

%% (d) Causal system
% H(s) = 1/(s+2)

b = [1];      % numerator
a = [1, 2];   % denominator

% Time vector as specified
t = -5:0.01:5;

% impulse returns response starting at t=0
% We need to get samples from t=0 to t=5
ts = 0:0.01:5;
h_causal_from_impulse = impulse(b, a, ts);
h_causal_from_impulse = h_causal_from_impulse(:)';  % make row vector

% Append zeros for negative time
% Number of negative time samples: from -5 to -0.01 (500 samples)
n_neg = length(t(t < 0));  % should be 500
% Number of non-negative samples: from 0 to 5 (501 samples)
n_nonneg = length(t(t >= 0));  % should be 501

% Ensure length matches
if length(h_causal_from_impulse) > n_nonneg
    h_causal_from_impulse = h_causal_from_impulse(1:n_nonneg);
elseif length(h_causal_from_impulse) < n_nonneg
    h_causal_from_impulse = [h_causal_from_impulse, zeros(1, n_nonneg - length(h_causal_from_impulse))];
end

% Store in vector h (as required)
h = [zeros(1, n_neg), h_causal_from_impulse];

% Plot
figure('Name', 'Problem 3(d): Causal System');
plot(t, h, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('t');
ylabel('h(t)');
title('Causal Impulse Response: h(t) = e^{-2t}u(t)');

% Verify against analytic
hold on;
h_analytic = exp(-2*t) .* (t >= 0);
plot(t, h_analytic, 'r--', 'LineWidth', 1);
legend('impulse output (with zero padding)', 'Analytic: e^{-2t}u(t)');

%% (e) Anticausal system
% For anticausal: h_ac(t) = -e^{-2t}u(-t)
% Need to use time-reversed system

% Original equation: dy/dt + 2y = x
% Time-reverse (t -> -t): -dy(-t)/dt + 2y(-t) = x(-t)
% Let w(t) = y(-t), r(t) = x(-t)
% Then: -dw/dt + 2w = r  =>  dw/dt - 2w = -r
% So the time-reversed causal system has:
%   b_rev = [-1]  (numerator)
%   a_rev = [1, -2]  (denominator: s - 2)

b_rev = [-1];
a_rev = [1, -2];

% Get impulse response of the time-reversed causal system
% This gives w(t) for t >= 0
ts = 0:0.01:5;
w = impulse(b_rev, a_rev, ts);
w = w(:)';  % make row vector

% w(t) = y(-t), so for t >= 0, w(t) corresponds to y(negative time)
% We need to construct h_anticausal for t = -5:0.01:5

% For negative time indices: t = -5, -4.99, ..., -0.01
% The corresponding w indices: t_positive = 5, 4.99, ..., 0.01
% So h_anticausal(t_negative) = w(|t|)

% Method: flip w to get values for negative time
w_flipped = fliplr(w);

% w has length 501 (t=0 to 5)
% w_flipped(1) corresponds to t=-5, w_flipped(501) corresponds to t=0

% For t=0, anticausal system has h(0) = -1 (need to check)
% The analytic expression: h_ac(0) = -1

% Create full h_anticausal vector
n_neg = length(t(t < 0));  % 500 samples
n_nonneg = length(t(t >= 0));  % 501 samples

% h_anticausal for negative time comes from flipped w (excluding t=0 from w)
h_anticausal_neg = w_flipped(1:n_neg);

% For t=0, need the value at t=0 from w? 
% w(1) corresponds to t=0 in reversed system, which gives y(0)
% According to analytic: h_ac(0) = -1
h_anticausal_zero = w(1);  % This should be -1

% For t>0, anticausal system has zero response
h_anticausal_pos = zeros(1, n_nonneg - 1);  % all zeros for t>0

% Combine
h_anticausal = [h_anticausal_neg, h_anticausal_zero, h_anticausal_pos];

% Plot
figure('Name', 'Problem 3(e): Anticausal System');
plot(t, h_anticausal, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('t');
ylabel('h(t)');
title('Anticausal Impulse Response: h(t) = -e^{-2t}u(-t)');

% Verify against analytic
hold on;
h_analytic_anticausal = -exp(-2*t) .* (t <= 0);
plot(t, h_analytic_anticausal, 'r--', 'LineWidth', 1);
legend('impulse output (time-reversal method)', 'Analytic: -e^{-2t}u(-t)');

% Display verification
disp('=== (d) Causal System ===');
disp('h(t) = e^{-2t}u(t) verified');

disp('=== (e) Anticausal System ===');
disp('h(t) = -e^{-2t}u(-t) verified');
disp('Method:');
disp('1. Construct time-reversed causal system: b_rev=[-1], a_rev=[1,-2]');
disp('2. Compute w = impulse(b_rev, a_rev, ts) for ts=0:0.01:5');
disp('3. h_anticausal(negative t) = w(|t|)');
disp('4. h_anticausal(0) = w(0) = -1');
disp('5. h_anticausal(positive t) = 0');