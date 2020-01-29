function data = Spirals(noSpirals, pts, degrees, start, noise)
% Generate "two spirals" dataset with N instances.
% degrees controls the length of the spirals
% start determines how far from the origin the spirals start, in degrees
% noise displaces the instances from the spiral. 
%  0 is no noise, at 1 the spirals will start overlapping

if(nargin==0)
    data = Spirals(2,20000,360*2,90,0.2)/8;
    return;
end

    if nargin < 1
        noSpirals = 2;
    end
    if nargin < 2
        pts = 2000;
    end
    if nargin < 3
        degrees = 570;
    end
    if nargin < 4
        start = 90;
    end
    if nargin < 5
        noise = 0.2;
    end  
    
    deg2rad = (2*pi)/360;
    start = start * deg2rad;

    pts = floor(pts/noSpirals);
    N2 = pts-pts;
    
    data = [];
    for i=1:noSpirals
        n = start + sqrt(rand(pts,1)) * degrees * deg2rad;
        d1 = [-cos(n+(2*pi*i/noSpirals)).*n + rand(pts,1)*noise,sin(n+(2*pi*i/noSpirals)).*n+rand(pts,1)*noise,ones(pts,1)*i];
        %d1 = [-cos(n+(2*pi*i/noSpirals)).*n + wgn(pts,1,1)*noise,sin(n+(2*pi*i/noSpirals)).*n+wgn(pts,1,1)*noise,ones(pts,1)*i];
        data = [data;d1];
    end
end