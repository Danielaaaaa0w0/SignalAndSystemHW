fs = 500;   % Sampling rate (Hz)
f1 = 60;    % First notch frequency (Hz)
f2 = 120;   % Second notch frequency (Hz)

% Normalized frequencies
w1 = 2*pi*f1/fs;
w2 = 2*pi*f2/fs;

% Place zeros at e^(±jw1) and e^(±jw2)
zeros = [exp(1i*w1), exp(-1i*w1), exp(1i*w2), exp(-1i*w2)];

% Construct FIR filter coefficients (numerator)
b = poly(zeros); % Coefficients of H(z)
a = 1;           % Denominator (FIR filter)

% Compute frequency response using 1024-point FFT
N = 1024;
[H, freq] = freqz(b, a, N, fs);

% Magnitude in linear and dB scales
mag_linear = abs(H);
mag_dB = 20*log10(abs(H));

% Plot in linear scale
figure;
subplot(2,1,1);
plot(freq, mag_linear, 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (Linear)');
title('Magnitude Response (Linear Scale)');
xlim([0 fs/2]); % Show up to Nyquist frequency (250 Hz)
ylim([0 1.1]);

% Plot in dB scale
subplot(2,1,2);
plot(freq, mag_dB, 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Magnitude Response (Logarithmic Scale)');
xlim([0 fs/2]);
ylim([-60 5]); % Adjust dB range for better visualization