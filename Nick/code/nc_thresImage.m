function outimage = nc_thresImage(inimage,thres)

    % Binarises an image
    % Assumed to be used in lab08q2.m

    outimage = zeros(size(inimage));
    outimage(inimage>thres) = 1;

end