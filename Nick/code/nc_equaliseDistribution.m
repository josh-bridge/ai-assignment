function [outImages, outLabels] = nc_equaliseDistribution(digit,inImages,inLabels)
% discards excess examples of images with non-digit labels
% note thst inImages is expected to be a 3D matrix.

digitLocations = find(inLabels==digit);
nondigitLocations = find(inLabels~=digit);

for i=1:length(nondigitLocations)
    
    r1 = floor(rand(1)*length(nondigitLocations))+1;
    r2 = floor(rand(1)*length(nondigitLocations))+1;
    
    temp = nondigitLocations(r1);
    nondigitLocations(r1) = nondigitLocations(r2);
    nondigitLocations(r2) = temp;
    
end

outImages = cat(3,inImages(:,:,digitLocations),inImages(:,:,nondigitLocations(1:length(digitLocations))));
outLabels = [inLabels(digitLocations); inLabels(nondigitLocations(1:length(digitLocations)))];