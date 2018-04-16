function params = nc_parameterRegions(inimage)

    sepRegions = nc_separateRegions(inimage);
    nRegions = size(sepRegions,3);

    params = zeros(nRegions,4);
    for i = 1:nRegions

        edge = nc_genEdgeBinary(sepRegions(:,:,i));
        chain = nc_chainCode(edge);
        params(i,1) = nc_chainPerim(chain);
        params(i,2) = nc_chainArea(chain);
        params(i,3) = nc_chainPerim(chain)^2 / nc_chainArea(chain); 
        params(i,4) = chain.closed;

    end

end
