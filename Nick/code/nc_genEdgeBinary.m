function outimage = nc_genEdgeBinary(inimage)

% this implements my preferred morphological transfom 
% to give an outer ring of pixels.

    struc = [0 1 0; 1 1 1; 0 1 0];

    midimage = nc_imerode(inimage,struc);
    outimage = inimage - midimage;


end