n = 0:1:30;
u = ones(size(n));  % u[n]
x = cos(n.*pi./6).*u; % x[n]
h = (0.6).^n .* u;  % h[n]
y = conv(x, h); 

n_y = 0:length(y)-1;  % y[n]

stem(n_y, y);
xlabel('n');
ylabel('y[n]');
grid;
