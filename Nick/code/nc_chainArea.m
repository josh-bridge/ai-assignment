function area = nc_chainArea(inchain)

h = inchain.y;
area = 0;
for i=1:inchain.nlinks
    switch inchain.links(i)
        case 0     
            h = h + 1;
        case 1 
            area = area + (h-0.5);
            h = h + sqrt(2);
        case 2 
            area = area + h;
        case 3
            area = area + (h+0.5);
            h = h - sqrt(2);
        case 4
            h = h - 1;
        case 5
            area = area - (h+0.5);
            h = h - sqrt(2);
        case 6
            area = area - h;
        case 7
            area = area - (h-0.5);
            h = h + sqrt(2);
        otherwise
            error 'Impossible link';
    end
end