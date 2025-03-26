t=-2:0.01:4;
u=0.*(t<0)+1.*(t>=0);
y=5.*exp(-2.*t).*u;
plot(t,y);
xlabel('t');
ylabel('y(t)');
grid;
