% Problem 6.29: Plot |X(Ω)| of DTFT of x[n] = a^|n|
a = 0.75;
Omega = linspace(0, 2*pi, 500);  % Frequency range
X = (1 - a^2) ./ (1 - 2*a*cos(Omega) + a^2);
figure;
plot(Omega, abs(X));
title('|X(Ω)| for x[n] = a^{|n|}, a = 0.75');
xlabel('Ω (rad/sample)');
ylabel('|X(Ω)|');
