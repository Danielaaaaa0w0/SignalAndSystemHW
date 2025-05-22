% Problem 6.30: Compute DFT of x[n] = {1,2,0,-1,-2,1,5,4}
x = [1, 2, 0, -1, -2, 1, 5, 4];
X = fft(x);
disp(X);