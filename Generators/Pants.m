function [ pts ] = Pants( overlap, spiral, randomAngle, randomNoise)
%genPants Generates a 3D "Pants Function".
%   A gradual intersection of 2 circles.

if(nargin==0)
    pts = Pants(0.7,pi/3,0,0);
    return;
end

pts = [];
rad = 1;

if(nargin<2)
    spiral = 0;
    randomAngle = 0;
end

%Vary over height.
for z = 0:0.01:5
    xC1 = (cos(z*pi)+1)*rad*overlap;
    xC2 = -xC1;
    yC1 = 0;
    yC2 = 0;
    for theta = 0:0.1:2*pi
        x = xC1+sin(theta+spiral*z+rand()*randomAngle)*rad;
        y = yC1+cos(theta+spiral*z+rand()*randomAngle)*rad;
        %only add if not within other.
        if(pdist2([x,y],[xC2,yC2])>rad-0.01)
            pts(size(pts,1)+1,1:3)=[x,y,z];
        end
        x = xC2+sin(theta-spiral*z+rand()*randomAngle)*rad;
        y = yC2+cos(theta-spiral*z+rand()*randomAngle)*rad;
        if(pdist2([x,y],[xC1,yC1])>rad-0.01)
            pts(size(pts,1)+1,1:3)=[x,y,z];
        end
    end
end

pts = pts + rand(size(pts))*randomNoise;


end

