%% Problem 2: Amplitude Demodulation and Receiver Synchronization
% Lab 5 - Complete Clean Version
clear; close all; clc;

%% ========================================================================
% Load Speech Signal
% ========================================================================
load origbl;            % Load speech signal (sampled at fs=8192 Hz)
fs = 8192;              % Sampling frequency (Hz)
x = x(:);               % Ensure column vector
N = length(x);          % Signal length
t = (0:N-1)/fs;         % Time vector (column vector)
t = t(:);

fprintf('Signal length: N = %d samples (%.2f seconds)\n', N, N/fs);

% Play original speech
disp('Playing original speech...');
sound(x, fs);
pause(2);

%% ========================================================================
% (a) CTFT of Original Speech Signal
% ========================================================================
X = fftshift(fft(x, N));
f = linspace(-fs/2, fs/2 - fs/N, N);

figure('Name', '(a) Original Speech Spectrum', 'Position', [100, 100, 800, 600]);

subplot(2,1,1);
plot(f, abs(X), 'b', 'LineWidth', 1);
title('(a) CTFT Magnitude of Original Speech Signal');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-2000, 2000]);

subplot(2,1,2);
plot(f, abs(X), 'b', 'LineWidth', 1);
title('(a) Zoom: Speech is bandlimited to ~1000 Hz');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-1500, 1500]);
ylim([0, max(abs(X)) * 0.1]);

%% ========================================================================
% (b) AM Modulation (A = 0)
% ========================================================================
fc = 1500;              % Carrier frequency (Hz)
wc = 2 * pi * fc;       % Carrier angular frequency (rad/s)

% y(t) = x(t) * cos(wc * t)
y = x .* cos(wc * t);

Y = fftshift(fft(y, N));

figure('Name', '(b) Modulated Signal', 'Position', [100, 100, 800, 400]);
plot(f, abs(Y), 'r', 'LineWidth', 1);
title('(b) CTFT Magnitude of Modulated Signal y(t) (fc=1500 Hz)');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');
grid on;
xlim([-3000, 3000]);

%% ========================================================================
% (c) Synchronous Demodulation (Perfect Synchronization)
% ========================================================================
% w(t) = y(t) * cos(wc * t)
w = y .* cos(wc * t);
v = w;  % Store in v as specified

W = fftshift(fft(w, N));

figure('Name', '(c) Demodulated Signal', 'Position', [100, 100, 800, 400]);
plot(f, abs(W), 'g', 'LineWidth', 1);
title('(c) CTFT Magnitude of Demodulated Signal w(t)');
xlabel('Frequency (Hz)');
ylabel('|W(f)|');
grid on;
xlim([-3000, 3000]);

%% ========================================================================
% (d) Lowpass Filter Design
% ========================================================================
fc_lpf = 1500;          % Cutoff frequency (Hz)
L = 41;                 % Filter length (odd)

% Time shift to make filter causal: T = 40/(2*fs) = 20/fs
T_shift = 20 / fs;

% Time indices
n_h = 0:L-1;
t_h = n_h / fs - T_shift;

% Ideal impulse response: h(t) = 2*fc * sinc(2*fc*t)
h = 2 * fc_lpf * sinc(2 * fc_lpf * t_h);

% Apply Hamming window
h = h .* hamming(L)';

% Ensure row vector
h = h(:)';

% Plot impulse response
figure('Name', '(d) Lowpass Filter', 'Position', [100, 100, 800, 600]);

subplot(2,1,1);
stem(t_h, h, 'filled', 'LineWidth', 1);
title('(d) Impulse Response h(t) (41 taps, Hamming windowed)');
xlabel('Time (s)');
ylabel('h(t)');
grid on;
xlim([-0.006, 0.006]);

% CTFT of filter
H = fftshift(fft(h, N));

subplot(2,1,2);
plot(f, abs(H), 'm', 'LineWidth', 1);
title('(d) CTFT Magnitude of Lowpass Filter');
xlabel('Frequency (Hz)');
ylabel('|H(f)|');
grid on;
xlim([-3000, 3000]);
ylim([0, max(abs(H)) * 1.1]);

% Mark cutoff frequency
hold on;
plot([fc_lpf, fc_lpf], [0, max(abs(H)) * 1.1], 'r--', 'LineWidth', 1.5);
plot([-fc_lpf, -fc_lpf], [0, max(abs(H)) * 1.1], 'r--', 'LineWidth', 1.5);
legend('|H(f)|', 'Cutoff ±1500 Hz');
hold off;

%% ========================================================================
% (e) Filter and Recover Speech
% ========================================================================
z = filter(h, 1, w);
z = z(:);  % Ensure column vector

Z = fftshift(fft(z, N));

figure('Name', '(e) Recovered Speech', 'Position', [100, 100, 800, 400]);
plot(f, abs(Z), 'k', 'LineWidth', 1);
title('(e) CTFT Magnitude of Recovered Speech z(t)');
xlabel('Frequency (Hz)');
ylabel('|Z(f)|');
grid on;
xlim([-2000, 2000]);

% Play recovered speech
disp('Playing recovered speech (perfect sync)...');
sound(z, fs);
pause(2);

%% ========================================================================
% (f) Phase Mismatch Effects
% ========================================================================
phi_vals = [0, pi/4, pi/2];
colors = {'b', 'r', 'g'};
legend_str = {};

figure('Name', '(f) Phase Errors', 'Position', [100, 100, 800, 400]);
hold on;

for i = 1:length(phi_vals)
    phi = phi_vals(i);
    w_phi = y .* cos(wc * t + phi);
    W_phi = fftshift(fft(w_phi, N));
    plot(f, abs(W_phi), colors{i}, 'LineWidth', 1);
    legend_str{i} = sprintf('\\phi = %.2f rad', phi);
end

hold off;
title('(f) CTFT Magnitude for Different Phase Errors');
xlabel('Frequency (Hz)');
ylabel('|W(f)|');
legend(legend_str, 'Location', 'best');
grid on;
xlim([-2000, 2000]);

% Play each version
fprintf('\n--- Playing with different phase errors ---\n');
for i = 1:length(phi_vals)
    phi = phi_vals(i);
    w_phi = y .* cos(wc * t + phi);
    z_phi = filter(h, 1, w_phi);
    z_phi = z_phi(:);
    fprintf('Playing with phi = %.2f rad...\n', phi);
    sound(z_phi, fs);
    pause(2);
end

%% ========================================================================
% (g) Phase-Locked Loop (PLL) for Phase Estimation
% ========================================================================
fprintf('\n--- Part (g): PLL Phase Estimation ---\n');

A = 10;                 % DC offset
phi_true = pi/4;        % True phase offset

% Modulated signal with phase offset
y_pll = (A + x) .* cos(wc * t + phi_true);

% PLL parameters
alpha = 0.05;
phihat = zeros(N, 1);
phihat(1) = 0;

% PLL loop
for k = 1:N-1
    chat_est = A * cos(wc * t(k) + phihat(k));
    phihat(k+1) = phihat(k) + alpha * (y_pll(k) - chat_est);
end

% Plot results
figure('Name', '(g) PLL Performance', 'Position', [100, 100, 800, 600]);

subplot(2,1,1);
plot(t, phi_true * ones(N, 1), 'r--', 'LineWidth', 1.5);
hold on;
plot(t, phihat, 'b', 'LineWidth', 1);
hold off;
title('(g) Phase Estimate vs True Phase');
xlabel('Time (s)');
ylabel('Phase (rad)');
legend('True phase \phi', 'Estimated \phi_{hat}');
grid on;

subplot(2,1,2);
plot(t, phi_true - phihat, 'k', 'LineWidth', 1);
title('(g) Phase Error (\phi - \phi_{hat}) vs Time');
xlabel('Time (s)');
ylabel('Phase Error (rad)');
grid on;

% Demodulate using estimated phase
w_pll = y_pll .* cos(wc * t + phihat);
z_pll = filter(h, 1, w_pll);
z_pll = z_pll(:);

disp('Playing recovered speech with PLL phase estimate...');
sound(z_pll, fs);
pause(2);

%% ========================================================================
% (h) Random Phase Jitter
% ========================================================================
fprintf('\n--- Part (h): Random Phase Jitter ---\n');

% Generate random phase drift
rms_jitter = 0.01;
phin = cumsum(randn(N, 1) * rms_jitter);

% Received signal with random phase drift
y_jitter = (A + x) .* cos(wc * t + phin);

% Plot phase drift
figure('Name', '(h) Phase Jitter', 'Position', [100, 100, 800, 600]);

subplot(2,1,1);
plot(t, phin, 'b', 'LineWidth', 1);
title('(h) Random Phase Drift \phi_n(t)');
xlabel('Time (s)');
ylabel('Phase (rad)');
grid on;

% PLL for random phase
phihat_jitter = zeros(N, 1);
phihat_jitter(1) = 0;

for k = 1:N-1
    chat_est = A * cos(wc * t(k) + phihat_jitter(k));
    phihat_jitter(k+1) = phihat_jitter(k) + alpha * (y_jitter(k) - chat_est);
end

subplot(2,1,2);
plot(t, phin, 'b', 'LineWidth', 1);
hold on;
plot(t, phihat_jitter, 'r', 'LineWidth', 1);
hold off;
title('(h) True Phase Drift vs PLL Estimate');
xlabel('Time (s)');
ylabel('Phase (rad)');
legend('True \phi_n', 'Estimated \phi_{hat}');
grid on;

% Demodulate using PLL estimate
w_jitter = y_jitter .* cos(wc * t + phihat_jitter);
z_jitter = filter(h, 1, w_jitter);
z_jitter = z_jitter(:);

disp('Playing recovered speech with random phase jitter (PLL compensated)...');
sound(z_jitter, fs);
pause(2);

%% ========================================================================
% Parameter Exploration for PLL
% ========================================================================
fprintf('\n--- Parameter Exploration ---\n');

% Define parameters to test
alpha_test = [0.01, 0.05, 0.1, 0.5];
A_test = [5, 10, 20];

% Generate a new random phase drift for fair comparison
phin_exp = cumsum(randn(N, 1) * rms_jitter);
y_jitter_exp = (A + x) .* cos(wc * t + phin_exp);

% Ensure column vectors
y_jitter_exp = y_jitter_exp(:);
t_exp = t(:);

% Test different alpha values
figure('Name', 'Parameter Study: Alpha', 'Position', [100, 100, 800, 400]);
hold on;

for i = 1:length(alpha_test)
    alpha_i = alpha_test(i);
    phihat_test = zeros(N, 1);
    
    for k = 1:N-1
        chat_est = A * cos(wc * t_exp(k) + phihat_test(k));
        phihat_test(k+1) = phihat_test(k) + alpha_i * (y_jitter_exp(k) - chat_est);
    end
    
    plot(t_exp, phihat_test, 'LineWidth', 1.5);
end

hold off;
title('PLL Phase Estimates for Different \alpha Values');
xlabel('Time (s)');
ylabel('Estimated Phase (rad)');
legend(arrayfun(@(a) sprintf('\\alpha = %.2f', a), alpha_test, 'UniformOutput', false));
grid on;

% Test different A values
figure('Name', 'Parameter Study: A', 'Position', [100, 100, 800, 400]);
hold on;

for i = 1:length(A_test)
    A_i = A_test(i);
    y_test = (A_i + x) .* cos(wc * t + phin_exp);
    y_test = y_test(:);
    
    phihat_test = zeros(N, 1);
    
    for k = 1:N-1
        chat_est = A_i * cos(wc * t_exp(k) + phihat_test(k));
        phihat_test(k+1) = phihat_test(k) + alpha * (y_test(k) - chat_est);
    end
    
    plot(t_exp, phihat_test, 'LineWidth', 1.5);
end

hold off;
title('PLL Phase Estimates for Different A Values');
xlabel('Time (s)');
ylabel('Estimated Phase (rad)');
legend(arrayfun(@(a) sprintf('A = %.0f', a), A_test, 'UniformOutput', false));
grid on;

%% ========================================================================
% Summary
% ========================================================================
fprintf('\n========== Problem 2 Complete ==========\n');
fprintf('All audio files have been played.\n');
fprintf('Check all figures for results.\n');