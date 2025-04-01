num = [2 5]; %分子係數
den = [1 5 6]; %分母係數

t = 0:0.1:16;

figure;
impulse(num, den, t);
title('Impulse Respnose')

figure;
step(num, den, t);
title('Step Respnose')