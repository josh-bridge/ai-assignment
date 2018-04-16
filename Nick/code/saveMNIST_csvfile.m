function saveMNIST_csvfile(filename,imagedata,labels)

% saveMNIST_CSVfile saves a pair of MATLAB data-itesm to a single comma 
% separated value file. The file can then be passed to Weka for
% discrimination.
%
% Arguments:    filename - this is the name of the file to which the data 
%               will be saved.
%               imagedata - this is a M x N matrix, where M is the samples
%               per image and N is the number of images. If you are just 
%               writing out the un-processed digit-images, M will be 784, 
%               while N will vary with the data loaded.
%               labels - this is a vector of N integers, each stating the
%               digit writen in the corresponding image.
%
%
% Outputs:      None - data will be saved.
%
% Operation:    The labels will be mapped so that '4' digits have a value 
%               of 1 and all others have a value of 0. The two data inputs 
%               will be concatenated so that the labels preceed the image 
%               samples for each image. The combined data will then be 
%               saved as a CSV file.  





in_labels = zeros(size(labels));
in_labels(labels==4) = 1;
imagedata = imagedata';

try 
    in_data = [in_labels imagedata];
    
    fid = fopen(filename,'w');
    
    for j=1:size(imagedata,2)
        fprintf(fid,'p%d, ',j);
    end
    fprintf(fid,'label \n');
          
    for i=1:size(imagedata,1)
        if mod(i,1000)==0
            disp(i);
        end
        for j = 1:size(imagedata,2)
            fprintf(fid,'%f,',imagedata(i,j));
        end
        if(in_labels(i))
            fprintf(fid,'one \n');
        else
            fprintf(fid,'zero \n');
        end
    end

    fclose(fid);
    
catch err
    
    if size(imagedata,2)~=length(labels)
        disp('You must have the same number of images and labels. Good-bye');
    end
    
    rethrow(err);

end
