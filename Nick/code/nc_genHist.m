function hist = nc_genHist(inimage)

%assume inimage is 8-bit greayscale
%assume we want one sample per grey-level

hist = zeros(1,256);
for x = 1:size(inimage,2)
    for y = 1:size(inimage,1)
        hist(inimage(y,x)+1) = hist(inimage(y,x)+1) + 1;
    end
end

end