function chain = nc_chainCode(inimage)

% Generates a chain structure, describing the links between adjacent pixels
% at the edge of an image.
% The image should be binary and have at least one single-pixel wide ring
% of non-zero pixels.
% If two or more rings are present, only the top left ring is processed.
% This is defined by reference to the top left pixel of the ring(s).
% A value of 0 for chain.closed implies the object is a single line.

% Find the starting point of the chain
midimage = inimage;
[y,x] = find(midimage);
chain.x = x(find(y==min(y),1));
chain.y = min(y);
[midimage, link, cont] = nextlink(midimage,chain.y,chain.x,-1);
chain.links = link;
chain.nlinks = 1;
chain.closed = cont;

currpos = [chain.y chain.x];
for i=1:length(x)
    if size(chain.links,2) < chain.nlinks
        break;
    end

    lastlink = chain.links(chain.nlinks);
    currpos = nextpix(currpos(1),currpos(2),lastlink);
    [midimage, link, cont] = nextlink(midimage,currpos(1),currpos(2),lastlink);
    chain.links = [chain.links link];
    chain.nlinks = chain.nlinks+1;   
    
    if currpos == [chain.y chain.x]
        break;
        % this ensures we don't try to process edge pixels in a different
        % (perhaps enclosed) object
    end
    if cont == 0
        chain.closed = cont;
        break;
        % this ensures we terminate prompty if the edge is not closed
    end
end
chain.nlinks = chain.nlinks-1;

function [outimage, link, cont] = nextlink(inimage,y,x,lastlink)

% If we're just starting, we need to set the current pixel to black
outimage = inimage;
if lastlink~=-1
    outimage(y,x) = 0;
end

% Find out where the edge pixels are, ignoring the current pixel
subimage = outimage(y-1:y+1,x-1:x+1);
[ind] = find(subimage);
if ~isempty(find(ind==5,1))
    ind5 = find(ind==5);
    if ind5~=1 && ind5~=length(ind)
        ind = [ind(1:find(ind==5)-1)'  ind(find(ind==5)+1:end)']; 
    elseif ind5==1
        ind = ind(2:end);
    else
        ind = ind(1:end-1);
    end
end

%cont says if we've got any other pixels to find - we won't if the edge
%isn't a loop.
cont = ~isempty(find(subimage, 1));

% Convert indexes to links 
links = zeros(size(ind));
links(ind==1) = 7;
links(ind==4) = 0;
links(ind==7) = 1;
links(ind==8) = 2;
links(ind==9) = 3;
links(ind==6) = 4;
links(ind==3) = 5;
links(ind==2) = 6;

% Update the last-link value, if we're not on the first link
if lastlink~=-1
    lastlink = lastlink+4;
    if lastlink>7
        lastlink = lastlink-8;
    end
    links = links(links~=lastlink); 
end

% Finally choose the lowest numbered even link (cardinal direction)
% before the lowest odd link (non-cardinal);
if ~isempty(find(mod(links,2)==0, 1))
        link = min(links(mod(links,2)==0));
else
        link = min(links(mod(links,2)~=0));
end

    
function pos = nextpix(y,x,link)

switch link
    case 0
        y = y-1;
    case 1
        y = y-1;
        x = x+1;
    case 2
        x = x+1;
    case 3
        y = y+1;
        x = x+1;
    case 4
        y = y+1;
    case 5
        y = y+1;
        x = x-1;
    case 6
        x = x-1;
    case 7
        y = y-1;
        x = x-1;
    otherwise
        error 'Wrong link number'
end
pos = [y x];

        
