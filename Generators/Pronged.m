function [ pts ] = Pronged(numpts, arms, offset)
%GENPRONGEDDATA Generates toy 2D data with some number of arms.

if(nargin==0)
    pts = Pronged(2000,4,pi);
    return;
end

theta = 0:0.01:2*pi;
min = 1;
radius = (cos(theta*arms+offset)+1).^3+min;
scaling = max(radius);
radius = radius./max(radius);

%x = radius.*cos(theta);
%y = radius.*sin(theta);
%plot(x,y);

thets = zeros(numpts,1);
rhos  = zeros(numpts,1);
ind = 1;

%[thets,rhos] = cart2pol(rand(5000,1),rand(5000,1));

while(ind<=numpts)
    [th,rh] = cart2pol((rand()*2)-1,(rand()*2)-1);
    if((((cos(th*arms+offset)+1).^3+min)/scaling)>rh)
        thets(ind) = th;
        rhos(ind)  = rh;
        ind = ind+1;
    end
end

[x,y] = pol2cart(thets,rhos);
pts = [x,y];
end