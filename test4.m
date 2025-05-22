% Define the DFT values
X = [1, 1 + 1j*2, 1 - 1j, 1 + 1j, 1 - 1j*2];

% Compute the inverse DFT to get x[n]
x = ifft(X);

% Display the result
disp('x[n] =');
disp(x);
