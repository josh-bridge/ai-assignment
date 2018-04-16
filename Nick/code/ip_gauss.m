function [mask]=ip_gauss(sd)
%ip_diffgauss - applies a gaussian filter

%Initialise equations
%equation=sym('exp((x^2+y^2)/(-2*v))');

%Create x and ymasks
xmask=meshgrid(round(-3*sd):round(3*sd),round(-3*sd):round(3*sd));
ymask=xmask';
sdmask=ones(size(xmask)).*sd*sd;
mask = zeros(size(xmask));

%mask=subs(equation,{'x','y','v'},{xmask,ymask,sdmask});
%mask = mask/(2*pi*sd);

for i=1:size(xmask,1)
    for j = 1:size(xmask,2)
        mask(i,j) = exp((xmask(i,j)^2+ymask(i,j)^2)/(-2*sdmask(i,j)));
    end
end


%normalise filters
mask=mask/sum(sum(abs(mask)));



