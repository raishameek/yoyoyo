clc;
clear all;
close all;
warning off;

% Define the input size for the AlexNet architecture
inputSize = [227 227 3];

% Load the AlexNet architecture and replace the last layers
g = alexnet;
layers = g.Layers;
layers(end-2) = fullyConnectedLayer(29); % Adjust for 29 classes
layers(end) = classificationLayer;

% Define the dataset paths
datasetPaths = { ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\C', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\D', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\del', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\E', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\F', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\G', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\H', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\I', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\J', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\K', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\L', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\M', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\N', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\nothing', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\O', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\P', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\Q', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\R', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\S', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\space', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\T', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\U', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\V', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\W', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\X', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\Y', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\Z', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\A', ...
    'F:\SCEM\Mini project\archive\asl_alphabet_train\asl_alphabet_train\B'};

% Create the imageDatastore for all subfolders
allImages = imageDatastore(datasetPaths, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

% Display unique labels to confirm correct labeling
disp(unique(allImages.Labels));

% Resize the images while keeping labels
augmentedImages = augmentedImageDatastore(inputSize(1:2), allImages);

% Define training options
opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.01, ...  % Higher learning rate
    'MaxEpochs', 10, ...           % Reduced epochs
    'MiniBatchSize', 128, ...      % Larger mini-batch size
    'ExecutionEnvironment', 'gpu', ...  % Explicit GPU usage
    'Verbose', false);             % Disable verbose output

% Train the network
myNet1 = trainNetwork(augmentedImages, layers, opts);

% Save the trained network
save myNet;
