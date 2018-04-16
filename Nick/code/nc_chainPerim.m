function perim = nc_chainPerim(inchain)

perim = 0;
for i=1:inchain.nlinks
    if mod(inchain.links(i),2)==0
        perim = perim + 1;
    else
        perim = perim + sqrt(2);
    end
end