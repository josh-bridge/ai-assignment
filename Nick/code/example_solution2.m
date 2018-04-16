% a script to do the coding in the simplest senisble way
% a) automatic selection of distractor images
% b) automatic discarding of zero-variance pixels

% 1. load the training data
train_images = loadMNISTImages('train-images.idx3-ubyte');
train_labels = loadMNISTLabels('train-labels.idx1-ubyte');

% 2. remove the excess non-'4' images
[train_images, train_labels] = nc_equaliseDistribution(4,train_images,train_labels);

% % 3. convert the images into a 2D matrix
nparam = length(nc_processImage(train_images(:,:,1),0));
ntrainImages = size(train_images,3);
processed_params = zeros(ntrainImages,nparam);

for i = 1 : ntrainImages
    if mod(i,100) == 0
        disp(i);
    end
    processed_params(i,:) = nc_processImage(train_images(:,:,i),nparam);
end
pcm = nc_genpc(processed_params,0.98);
train_params = pcm.param'; % You might need to transpose pcm.param...

% 5. save them to a CSV file
saveMNIST_csvfile('train_data1.csv',train_params,train_labels);

% 6. now repeat that for the testing data - don't fiddle the excess
test_images = loadMNISTImages('t10k-images.idx3-ubyte');
test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');
ntestImages = size(test_images,3);
test_params = zeros(length(pcm.lamb),ntestImages);
for i = 1 : ntestImages
    if mod(i,100) == 0
        disp(i);
    end
    processed_params = nc_processImage(test_images(:,:,i),nparam); 
    test_params(:,i) = ((processed_params'-pcm.mean)*pcm.comp)'; % again be careful of the transpose
end
saveMNIST_csvfile('test_data1.csv',test_params,test_labels);


% 6. combine the files
combine_csvfiles('train_data1.csv','test_data1.csv','train_test_data1.csv');


