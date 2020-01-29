function [ pointDensities ] = DENSITY( inputPoints, col)
%POINTDENSITY Summary of this function goes here
%   Detailed explanation goes here

if(nargin==0||isempty(inputPoints))
    pointDensities = {
        {}, ...        %params
        "1",  ...      %outNum
        "Density"      %outPrefix
    };
return
end


pointDensities = zeros(size(inputPoints,1),1);

for i=1:length(inputPoints)
    for j=1:length(inputPoints)
        if(i~=j)
            pointDensities(i)=pointDensities(i)+exp(-(norm(inputPoints(i,:)-inputPoints(j,:)))^2);
        end
    end
end

end

function params = optionalParams()
    params = ["density"];
end

