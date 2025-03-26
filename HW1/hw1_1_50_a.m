t=-2:4;
u=0.*(t<0)+1.*(t>=0);
x=2.*t.*u;
plot(t,x);
xlabel('t');
ylabel('x(t)');
grid;
