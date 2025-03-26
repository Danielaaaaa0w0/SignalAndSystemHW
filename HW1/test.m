x = [1 -1];
y = [4 2 5 1];

% 正确的卷积矩阵
X = [ 1  0  0;
     -1  1  0;
      0 -1  1;
      0  0 -1];

% 计算 h[n]
h = X \ y';  % 线性方程求解

% 计算卷积
y_check = conv(x, h);

% 显示结果
disp('h[n] = '), disp(h');
disp('conv(x, h) = '), disp(y_check');
disp('y[n] = '), disp(y');
