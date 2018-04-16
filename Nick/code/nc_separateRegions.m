function outimage = nc_separateRegions(inimage)

% this separates a image into an array of separate images, one per object

    midimage = nc_CCA(inimage);
    nobjects = max(max(midimage));

    outimage = zeros(size(inimage, 1), size(inimage, 2), nobjects);
    for i=1:nobjects
        tempimage = zeros(size(inimage, 1), size(inimage, 2));
        tempimage(midimage==i) = 1;
        outimage(:,:,i)=tempimage;
    end

end