function h = circf(x,y,r,color)

N = 200;
THETA = linspace(0,2*pi,N);
RHO = ones(1,N)*r;
[px,py] = pol2cart(THETA,RHO);
h=fill(px+x,py+y,color);