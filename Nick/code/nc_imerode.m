function outimage = nc_imerode(inimage,struc)

% this just makes sure the image has values 0 and 1
if max(max(inimage))==255
    inimage = inimage/255;
end

% and this does the actual erosion
numelems = sum(sum(struc));
outimage = zeros(size(inimage));
off = floor(size(struc)/2);
numelems = sum(sum(struc));
for i=1+off(1):size(inimage,1)-off(1)
    for j=1+off(2):size(inimage,2)-off(2) 
      sub = inimage(i-off(1):i+off(1),j-off(2):j+off(2));
      outimage(i,j) = (sum(sum(struc .* sub)) == numelems);
    end
end

