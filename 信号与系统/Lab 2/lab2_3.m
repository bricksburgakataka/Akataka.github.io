%% Problem 3: Echo Cancellation
% Using lineup.mat file

clear; close all; clc;

%% Parameters
N = 1000;      % Echo delay (samples)
alpha = 0.5;   % Echo amplitude
fs = 8192;     % Sampling frequency (Hz)

%% ==================== Part (a) ====================
he = zeros(1, N+1);
he(1) = 1;
he(N+1) = alpha;

figure('Name', 'Part (a): Echo System Impulse Response');
stem(0:N, he, 'filled', 'LineWidth', 1.5);
xlabel('n (samples)');
ylabel('h_e[n]');
title(sprintf('Impulse Response: h_e[n] = δ[n] + %.1f δ[n-%d]', alpha, N));
grid on;
xlim([-50, 1050]);
ylim([-0.2, 1.2]);

fprintf('\n=== Part (a) ===\n');
fprintf('Impulse response stored in vector he (length %d)\n', length(he));

%% ==================== Part (b) ====================
fprintf('\n=== Part (b) ===\n');
fprintf('Echo system: y[n] = x[n] + α x[n-%d]\n', N);
fprintf('Inverse system: z[n] + α z[n-%d] = y[n]\n', N);
fprintf('Substituting: z[n] + α z[n-%d] = x[n] + α x[n-%d]\n', N, N);
fprintf('∴ z[n] = x[n] is a valid solution.\n');

%% ==================== Part (c) ====================
a_inv = zeros(1, N+1);
a_inv(1) = 1;
a_inv(N+1) = alpha;
b_inv = 1;

d = [1, zeros(1, 4000)];
her = filter(b_inv, a_inv, d);

figure('Name', 'Part (c): Inverse System Impulse Response');

subplot(2,1,1);
stem(0:200, her(1:201), 'filled', 'LineWidth', 0.8);
xlabel('n (samples)');
ylabel('h_{inv}[n]');
title('Inverse System Impulse Response (First 201 samples)');
grid on;

subplot(2,1,2);
max_k = floor((length(her) - 1) / N);
n_plot = 0:N:max_k*N;
h_plot = zeros(1, length(n_plot));
for k = 0:max_k
    idx = k * N + 1;
    if idx <= length(her)
        h_plot(k+1) = her(idx);
    end
end
stem(n_plot, h_plot, 'filled', 'LineWidth', 1.5);
xlabel('n (samples)');
ylabel('h_{inv}[n]');
title(sprintf('Impulse Response (Multiples of N=%d)', N));
grid on;

fprintf('\n=== Part (c) ===\n');
fprintf('Pattern: h_inv[k*%d] = (-α)^k\n', N);
fprintf('  h_inv[0] = %.2f\n', her(1));
fprintf('  h_inv[%d] = %.2f\n', N, her(N+1));

%% ==================== Part (d) ====================
% Load the speech file
load('lineup.mat');

fprintf('\n=== Part (d) ===\n');
fprintf('Loaded lineup.mat successfully.\n');
fprintf('Signal length: %d samples (%.2f seconds)\n', length(y), length(y)/fs);

% Implement echo removal
z = filter(b_inv, a_inv, y);

% Time vector
t = (0:length(y)-1) / fs;

% Plot full signal
figure('Name', 'Part (d): Echo Removal Result', 'Position', [100, 100, 1000, 600]);

subplot(2,1,1);
plot(t, y, 'b-');
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Original Signal with Echo');
grid on;

subplot(2,1,2);
plot(t, z, 'r-');
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Signal After Echo Removal');
grid on;

% Zoomed view (using valid range based on signal length)
figure('Name', 'Part (d): Zoomed View', 'Position', [100, 100, 1000, 600]);

% Adjust zoom range based on signal length
signal_duration = length(y) / fs;
if signal_duration >= 1.0
    start_time = 0.5;
    end_time = 1.0;
else
    start_time = 0;
    end_time = signal_duration;
end

start_sample = max(1, round(start_time * fs));
end_sample = min(length(y), round(end_time * fs));
t_zoom = t(start_sample:end_sample);

subplot(2,1,1);
plot(t_zoom, y(start_sample:end_sample), 'b-', 'LineWidth', 0.8);
xlabel('Time (seconds)');
ylabel('Amplitude');
title(sprintf('Original Signal with Echo (Zoomed: %.2f-%.2f sec)', start_time, end_time));
grid on;

% Mark echo locations
hold on;
for k = 1:3
    echo_sample = start_sample + k * N;
    if echo_sample <= end_sample
        xline(t(echo_sample), 'r--', sprintf('Echo %d', k));
    end
end
hold off;

subplot(2,1,2);
plot(t_zoom, z(start_sample:end_sample), 'r-', 'LineWidth', 0.8);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Signal After Echo Removal (Zoomed)');
grid on;

% Play audio
fprintf('\nPlaying original signal with echo...\n');
sound(y, fs);
pause(3);

fprintf('Playing signal after echo removal...\n');
sound(z, fs);

% Save audio file
audiowrite('echo_removed.wav', z, fs);
fprintf('\nOutput saved to echo_removed.wav\n');

fprintf('\n=== Problem 3 Complete ===\n');