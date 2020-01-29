function [output] = RADIAL(inputColumns,columnNum)
%RADIAL Summary of this function goes here
%   Detailed explanation goes here

if(nargin==0||isempty(inputColumns))
    output = {
        {}, ... %params
        "1",  ...            %outNum
        "Radial"       %outPrefix
    };
return
end

output = pdist2(inputColumns,zeros(1,size(inputColumns,2)));
end

