w=10;
v=1/w;
t=0:1e-3:10;
g=exp(-i.*w.*t-(t-5).*(t-5).*0.5.*v.*v);
plot(imag(g))
