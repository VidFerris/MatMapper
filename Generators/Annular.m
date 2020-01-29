function [ pts ] = Annular(numpts,innerRad,outerRad,arms,offset,min)
%GENPRONGEDDATA Generates toy 2D annular data.
if(nargin==0)
    pts = Annular(2000,0.7,0.9,0,2,0.15);
    return;
end


theta = 0:0.01:2*pi;
%min = 2;
radius = ((sin(theta*arms+offset)+1)/2).^4+min;
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
    if(((((cos(th*arms+offset)+1)/2).^4+min)/scaling)>rh||innerRad<rh&&rh<outerRad)
        thets(ind) = th;
        rhos(ind)  = rh;
        ind = ind+1;
    end
end

[x,y] = pol2cart(thets,rhos);
pts = [x,y];
%scatter(x,y);
end