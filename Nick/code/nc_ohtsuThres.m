function outimage = nc_ohtsuThres(inimage)
% perform an Ohtsu threshold on an image.
% assume that it is 8-bit.

range = (0:255);
histo = nc_genHist(inimage);
th1 = zeros(1,256);
th2 = zeros(1,256);
thres = zeros(1,256);
for i=1:256
    
    if sum(histo(1:i))>0
        th1(i) = sum(histo(1:i).*range(1:i))/sum(histo(1:i));
    else
        th1(i) = 0;
    end
    if sum(histo(i:end))>0
        th2(i) = sum(histo(i:end).*range(i:end))/sum(histo(i:end));
    else
        th2(i) = 0;
    end
    
    thres(i) = (th1(i) + th2(i))/2;
end
diffs = ((thres-range).^2).^0.5;
minthres = find(diffs==min(diffs),1);
outimage = zeros(size(inimage));
outimage(inimage>=minthres)=1;

end

