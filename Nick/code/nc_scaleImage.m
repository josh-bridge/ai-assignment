function [scaled] = nc_scaleImage(nx,ny,inimage)
%NC_SCALEIMAGE Scale an image in x and y
%    [interpolated] = nc_scaleImage(xn,yn,inimage)
%
%    inputs:
%       nx       - Number of pixels in x
%       ny       - Number of pixels in y
%       inimage       - The image from which to sample.
%
%    outputs:
%       scaled  - ((nx)x(ny)) scaled image
%
%    notes:
%       See also the built-in Matlab functions 'interp' and 'interp2'
%


[y,x,z] = size(inimage);
[xi,yi] = meshgrid(1:x,1:y);
[xo, yo] = meshgrid(1:(x-1)/(nx-1):x,1:(y-1)/(ny-1):y);

scaled = zeros(ny,nx,z);
for i=1:z
   scaled(:,:,i)  = interp2(xi,yi,squeeze(inimage(:,:,i)),xo,yo,'*linear');     
end

