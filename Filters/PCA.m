function [output] = PCA(inputColumns,columnNum)
%PCA Summary of this function goes here
%   Detailed explanation goes here

if(nargin==0||isempty(inputColumns))
    output = {
        {}, ...       %params
        "inNum",  ... %outNum
        "PCA "        %outPrefix
    };
return
end
        


outputFull = inputColumns*pca(inputColumns);
output = outputFull(:,columnNum);
end

