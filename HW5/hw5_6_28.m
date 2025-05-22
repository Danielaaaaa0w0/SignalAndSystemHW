% Problem 6.28: FFT and plot |X(k)| for each case
figure;

% (a) x[n] = 1, 0 ≤ n ≤ 12
n = 0:12;
x = ones(size(n));
X = fft(x);
subplot(2,2,1);
stem(0:length(X)-1, abs(X));
title('|X(k)| for x[n] = 1, 0 ≤ n ≤ 12');
xlabel('k'); ylabel('|X(k)|');

% (b) x[n] = n, 0 ≤ n ≤ 10
n = 0:10;
x = n;
X = fft(x);
subplot(2,2,2);
stem(0:length(X)-1, abs(X));
title('|X(k)| for x[n] = n, 0 ≤ n ≤ 10');
xlabel('k'); ylabel('|X(k)|');

% (c) x[n] = 1/n for n = 1 to 10, x[0] = 1, else 0
n = 0:10;
x = zeros(size(n));
x(1) = 1;
x(2:end) = 1 ./ n(2:end);
X = fft(x);
subplot(2,2,3);
stem(0:length(X)-1, abs(X));
title('|X(k)| for x[n] = 1/n');
xlabel('k'); ylabel('|X(k)|');

% (d) x[n] = n*(0.8)^n, 0 ≤ n ≤ 10
n = 0:10;
x = n .* (0.8).^n;
X = fft(x);
subplot(2,2,4);
stem(0:length(X)-1, abs(X));
title('|X(k)| for x[n] = n*(0.8)^n');
xlabel('k'); ylabel('|X(k)|');
