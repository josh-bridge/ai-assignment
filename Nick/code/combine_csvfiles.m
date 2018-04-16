function combine_csvfiles(infilename1,infilename2,outfilename)

% function to combine two cvs files into a single peices of data.
% also gives the percentage of lines in the first file (useful for Weka)

[mat1,text1,raw1] = xlsread(infilename1);
[mat2,text2,raw2] = xlsread(infilename2);

percent = 100*size(mat1,1)/(size(mat1,1)+size(mat2,1));
disp('Percentage of items in first file is: ');
disp(percent);

try 
    
    
 C1 = raw1(2:end,:);
 T1 = cell2table(C1);
 T1.Properties.VariableNames = raw1(1,:);
 C2 = raw2(2:end,:);
 T2 = cell2table(C2);
 T2.Properties.VariableNames = raw2(1,:);

 T = [T1;T2];
 
 writetable(T,outfilename);
 
catch err
    
    if size(raw1,2)~=size(raw2,2)
        disp('You must have the same number of parameters in your two files. Good-bye');
    end
    
    rethrow(err);

end