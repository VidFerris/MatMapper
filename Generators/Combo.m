function [output] = Combo()
%GENCOMBO Summary of this function goes here
%   Detailed explanation goes here
output=[(Pronged(1000,3,-pi/2)+[0,1.5]);(Pronged(1000,4,pi)+[0,0]);(Pronged(1000,5,pi/2)+[1.5,1.5]);(Annular(2000,0.7,0.9,3,pi/4,0.15)+[2,-0.5])];

end

