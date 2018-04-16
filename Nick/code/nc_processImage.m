function outparams = nc_processImage(inimage,nparam)

% Real context is up to you!
% I might suggest..

% c) increase the resolution (nc_scaleImage)
scaled = nc_scaleImage(60,60,inimage);

% a) perhaps blur the image with a Guassian (see lab 9)
blurred = ip_conv2(scaled,ip_gauss(2));

% b) threshold the image via Ohtsu - gives a binary image (see lab 8)
ohtsu = nc_ohtsuThres(int8(blurred * 255));

% d) erode the image (with a little cross) to get the edge (see lab 10)
% e) use a chain code to describe the size and compactness of the digit (see lab 11)
% f) use CCA to count the number of loops (see lab 11)
regions = nc_parameterRegions(ohtsu);

% normalize values by dividing by number of pixels in scaled image
npixels = size(scaled,1) * size(scaled,2);
regions(1,1) = regions(1,1) / npixels;
regions(1,2) = regions(1,2) / npixels;
regions(1,3) = regions(1,3) / npixels;

% only use the first shape found by CCA (the others are rarely meaningful)
regions = reshape(regions(1), size(regions(1), 1) * size(regions(1), 2), 1);

% g) use co-occurence matrices to describe the texture (see lab 12)
cooccur = nc_cooccur(inimage,[0 1],8);
paramCol = reshape(cooccur, size(cooccur, 1) * size(cooccur, 2), 1);

% h) combine the different parameters (perhaps with a low-resolution image) into a single vector
out = nc_scaleImage(10,10,ohtsu);
outimage = reshape(out, size(out, 1) * size(out, 2), 1);

params = [regions ; paramCol ; outimage];

% if output vector is too small - pad with 0s
if nparam ~= 0 && size(params,1) < nparam
    dif = nparam - size(params,1);
    params = padarray(params, dif, 0, 'post');
end

outparams = params;
