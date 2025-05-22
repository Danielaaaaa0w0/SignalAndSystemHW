% 分子與分母多項式係數（按 z 的降冪排列）
num = [1 6 1];               
den = [1 3 0 4 10];          

% 計算零點與極點
z = roots(num);              % zeros
p = roots(den);              % poles

% 顯示結果
disp('Zeros:')
disp(z)

disp('Poles:')
disp(p)
