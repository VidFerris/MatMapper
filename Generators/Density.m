function [output] = Density()
%GENDENSITY Summary of this function goes here
%   Detailed explanation goes here
output = [normrnd(0,1,300,2);normrnd(0,1,300,2)+[2.5,2.5];normrnd(0,1,500,2).*[2,1]+[2,-4]];
end

