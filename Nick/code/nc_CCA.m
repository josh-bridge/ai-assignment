function labelimage = nc_CCA(inimage)

% Performs a connected components analysis of the binary inimage.
% Written 17/02/10.
% Nick Costen


% We need to pad the image into a slightly larger one so we can consider
% the (always zero) neighbours of the outermost band.
[ny nx] = size(inimage);
midimage = zeros(ny+2,nx+2);
midimage(2:ny+1,2:nx+1) = inimage;
labelimage = zeros(size(midimage));
ambigous = zeros(size(midimage));
label = 0;

% Find the pixels which are non-zero (reduces scanning)
[py px] = find(midimage);

for i=1:length(py)
   
    % Get the area just around the pixel of interest
    subLab = labelimage(py(i)-1:py(i)+1,px(i)-1:px(i)+1);
    
    % Option 1: we have't found this region before
    if sum(sum(subLab))==0
        label = label + 1;
        labelimage(py(i),px(i)) = label;
    else
        % Option 2: we have found this region before and have given it the
        % same label each time
        if sum(sum(subLab))/length(find(subLab)) == label
            labelimage(py(i),px(i)) = label;
        else
            % Option 3: we have different labels around the pixel. Set the
            % label to whatever the lowest non-zero adjacent one is, and
            % mark this pixel as ambigous.
            thislabel = min(min(subLab(subLab~=0)));
            labelimage(py(i),px(i)) = thislabel;
            ambigous(py(i),px(i)) = 1;
        end
    end
end

% The second pass needs to be repeated for as long as there are ambiguites
% in the data.
while sum(sum(ambigous))>0
    
    % Find the current ambigous pixels
    [ay ax] = find(ambigous);
    for i=1:length(ay)

        % The area around the pixel of interest
        subLab = labelimage(ay(i)-1:ay(i)+1,ax(i)-1:ax(i)+1);
        
        % Record that we've considered this pixel
        ambigous(ay(i),ax(i)) = 0;
        
        % Now find the adjacent pixels which have a label higher than the
        % pixel of interest
        [ry rx] = find(subLab>subLab(2,2));
        % Relabel them
        labelimage(ry-2+ay(i),rx-2+ax(i)) = subLab(2,2);
        % Mark them as ambigous, so we can consider thier adjacent pixels
        % on the next pass.
        ambigous(ry-2+ay(i),rx-2+ax(i)) = 1;

    end
end

% Now the labels may not be a ordinal list...
levels = unique(unique(labelimage));
for i = 1 : length(levels)
    labelimage(labelimage==levels(i)) = i-1;
end

% Get rid of the extra pixels
labelimage = labelimage(2:ny+1,2:nx+1);

