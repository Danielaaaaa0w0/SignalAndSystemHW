clc; clear; close all;

% 定義時間範圍
t = -5:0.01:5; % 設定 t 的範圍

% 定義 unit ramp function: x(t) = t * u(t)
x_t = t .* (t >= 0); % 單位斜坡函數：t 當 t >= 0，否則為 0

% 計算 x(1-t)
x_1_t = (1-t) .* ((1-t) >= 0); % 單位斜坡函數的時間反轉變換

% 繪圖
figure;
subplot(2,1,1);
plot(t, x_t, 'b', 'LineWidth', 2);
grid on;
title('x(t) = t u(t)');
xlabel('t');
ylabel('Amplitude');
ylim([-1, max(x_t) + 1]); % 調整 y 軸範圍

subplot(2,1,2);
plot(t, x_1_t, 'r', 'LineWidth', 2);
grid on;
title('x(1-t)');
xlabel('t');
ylabel('Amplitude');
ylim([-1, max(x_t) + 1]);

sgtitle('Comparison of x(t) and x(1-t)');
