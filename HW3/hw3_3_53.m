% part (a)
num_a = [1 10 0];
den_a = [1 70 1000];

sys_a = tf(num_a, den_a);
figure;
bode(sys_a);
grid on;
title('Bode Plot of H(s) for part (a)');

% part (b)
num_b = [1 1];
den_b = conv([1 20], [1 22.5 16]);

sys_b = tf(num_b, den_b);
figure;
bode(sys_b);
grid on;
title('Bode Plot of H(s) for part (b)');