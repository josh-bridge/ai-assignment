function pcm = nc_genpc(data,keep,varargin)
%NC_GENPC	performs principal component analysis
%    [pc, variance, params] = st_pca(data,keep)
%
%    inputs:
%       data     - (E*N) data matrix, where E is the number of examples and N
%                  is the number of variables
%       keep     - fraction of variance to keep. Must be on range [0,1]
%       nmodes   - (1x2) matrix. Sets the maximum and minimum number of modes.
%                  [3 15] would mean a minimum of 3 and maximum of 15 modes.
%
%    outputs:
%       pc       - (N*M) matrix of principal components, where M is the number kept
%       variance - (1*M) vector given the variance of each pc for the input data
%       params   - (E*M) matrix giving parameterisation of the each training example
%       datamean - (1*N) vector returning the mean of the training data
%


%Check for extra arguments
[e,n] = size(data);
pcm.mean = mean(data);
nmodes=[1 e-1];
if (length(varargin) == 0)
elseif (length(varargin) == 1)
   nmodes = varargin{1};
else
   error('Too many arguments');
end


if (e<n) %if number of examples is less than number of variables
   centreddata = ( data - repmat(pcm.mean,size(data,1),1) )';
   T = (1/e).*(centreddata'*centreddata);
   [v,d] = eig(T);
   d = diag(d)';
   pcm.comp = centreddata*v;
   div = repmat( (sqrt(d.*e)),n,1);
   
   %Stop the divide by zero warning - Note: this has no effect on the 
   %result, since the corresponding columns are dropped anyway
   div(div==0) = 1.0;
   
   pcm.comp = pcm.comp ./ div;
   
else %if number of examples is more than number of variables
   centreddata = ( data - repmat(pcm.mean,size(data,1),1) )';
   S = (1/e).*(centreddata*centreddata');
   [v,d] = eig(S);
   d = diag(d)';
   pcm.comp = v;
end

%Sort the eigenvalues
[sorted_d,i] = sort(d);
sorted_d = fliplr(sorted_d);
i = fliplr(i);
cs = cumsum(sorted_d);
ts = sum(sorted_d);
nummodes = max( find(cs <= (keep*ts)) );
if(nummodes >= e)
   nummodes = e - 1;
elseif (isempty(nummodes))  %first mode holds more variance than required so return just this one
   nummodes= 1;
end

%Check nummodes lies within the mode bounds defined in nmodes
if(nummodes<nmodes(1))
   nummodes=nmodes(1);
end
if(nummodes>nmodes(2))
   nummodes=nmodes(2);
end

%Sort the eigenvectors
sorted_pc = zeros(n,nummodes);
for col = 1:nummodes
   sorted_pc(:,col) = pcm.comp(:,i(col));
end
pcm.comp = sorted_pc;   

pcm.lamb = (sorted_d(1:nummodes));
pcm.param = centreddata' * pcm.comp;
