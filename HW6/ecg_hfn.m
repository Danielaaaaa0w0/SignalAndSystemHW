% MATLAB PROGRAM ecg_hfn_modified.m
clear all               % clears all active variables
close all

% Load the ECG signal
ecg = load('ecg_hfn.dat');
fs_orig = 1000; % Original sampling rate = 1000 Hz
slen_orig = length(ecg);
t_orig = (0:slen_orig-1) / fs_orig; % Corrected time vector

% Plot the original ECG signal
figure;
plot(t_orig, ecg);
axis tight;
xlabel('Time in seconds');
ylabel('ECG Amplitude');
title('Original ECG Signal (fs = 1000 Hz)');

% --- 1. Downsample the signal by 5 (manual method) ---
% Keep only every 5th sample
% x_d[n] = x[5n]
downsample_factor = 5;
ecg_manual_downsampled = ecg(1:downsample_factor:end);
fs_downsampled = fs_orig / downsample_factor; % New sampling rate = 1000 Hz / 5 = 200 Hz
slen_manual_down = length(ecg_manual_downsampled);
t_manual_down = (0:slen_manual_down-1) / fs_downsampled;

% --- 3. Plot the manually downsampled signal ---
figure;
plot(t_manual_down, ecg_manual_downsampled);
axis tight;
xlabel('Time in seconds');
ylabel('ECG Amplitude');
title(['Manually Downsampled ECG Signal (fs = ', num2str(fs_downsampled), ' Hz)']);

% --- 2. Apply the function of resample in Matlab ---
% Y = resample(X, P, Q) resamples X at P/Q times the original sample rate
% To downsample by 5, P=1 and Q=5.
P = 1;
Q = downsample_factor; % which is 5
ecg_resampled = resample(ecg, P, Q); %
slen_resampled = length(ecg_resampled);
t_resampled = (0:slen_resampled-1) / fs_downsampled; % Time vector for resampled signal

% Plot the resampled signal
figure;
plot(t_resampled, ecg_resampled);
axis tight;
xlabel('Time in seconds');
ylabel('ECG Amplitude');
title(['ECG Signal Resampled using resample() (fs = ', num2str(fs_downsampled), ' Hz)']);

% --- 7. Compare the results with the original signals in time domain ---
figure;
subplot(3,1,1);
plot(t_orig, ecg);
axis tight;
title('Original ECG Signal');
ylabel('Amplitude');

subplot(3,1,2);
plot(t_manual_down, ecg_manual_downsampled);
axis tight;
title('Manually Downsampled ECG (Every 5th Sample)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t_resampled, ecg_resampled);
axis tight;
title('ECG Downsampled using resample()');
ylabel('Amplitude');
xlabel('Time in seconds');

% --- 7. Compare the results with the original signals in frequency responses ---
% Function to compute and plot FFT
function plot_fft(signal, fs, title_str)
    L = length(signal);
    Y = fft(signal);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = fs*(0:(L/2))/L;
    plot(f, P1);
    title(title_str);
    xlabel('Frequency (Hz)');
    ylabel('|P1(f)|');
    axis tight;
end

figure;
subplot(3,1,1);
plot_fft(ecg, fs_orig, 'Frequency Response of Original ECG');

subplot(3,1,2);
plot_fft(ecg_manual_downsampled, fs_downsampled, 'Frequency Response of Manually Downsampled ECG');

subplot(3,1,3);
plot_fft(ecg_resampled, fs_downsampled, 'Frequency Response of ECG Downsampled with resample()');

sgtitle('Frequency Domain Comparison'); % Main title for the figure

disp('Processing complete. Figures show time and frequency domain comparisons.');