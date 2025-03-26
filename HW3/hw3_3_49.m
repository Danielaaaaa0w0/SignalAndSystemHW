num = [2 5]; %分子係數
den = [1 5 6]; %分母係數

H = tf(num, den); % Transfer function

figure;
impulse(H);
title('Impulse Respnose')

figure;
step(H);
title('Step Respnose')