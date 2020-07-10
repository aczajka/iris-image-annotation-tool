function [xc,yc,r] = circfit(x,y)
x = x(:); 
y = y(:);
a = [x y ones(size(x))]\[-(x.^2+y.^2)];
xc = -.5*a(1);
yc = -.5*a(2);
r = sqrt((a(1)^2+a(2)^2)/4-a(3));