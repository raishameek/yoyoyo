clc;
close all;
clear all;
warning off;

% Check if the built-in webcam function is accessible
if exist('webcam', 'file') ~= 2
    error('The "webcam" function is being shadowed. Remove or rename any custom "webcam.m" file in your project.');
end

% Initialize a webcam object
cam = webcam; % Ensure the built-in webcam function is used

% Load the pre-trained neural network
load myNet;

% Define the region of interest for detection
x = 500; y = 0; height = 300; width = 300;
bboxes = [x y height width];

% Initialize variables
sentence = ""; % To store the formed sentence
previousLabel = "nothing"; % Track the last detected label
stableCount = 0; % Count of consecutive stable detections
stabilityThreshold = 10; % Frames required for stability
lastAppendedLabel = ""; % Track the last appended letter

disp('Starting real-time detection...');

while true
    % Capture a snapshot from the webcam
    frame = cam.snapshot;
    frame = fliplr(frame); % Flip the frame horizontally
    
    % Display the region of interest on the frame
    annotatedFrame = insertObjectAnnotation(frame, 'rectangle', bboxes, 'Processing Area');
    
    % Crop and resize the region of interest
    croppedFrame = imcrop(frame, bboxes);
    resizedFrame = imresize(croppedFrame, [227 227]); % Resize to match network input size
    
    % Classify the gesture
    label = classify(myNet1, resizedFrame);
    currentLabel = char(label);
    
    % Check if the label is stable over multiple frames
    if currentLabel == previousLabel
        stableCount = stableCount + 1;
    else
        stableCount = 0; % Reset count if the label changes
    end
    
    % Add to sentence if the label is stable, not "nothing," and not a repeat
    if stableCount >= stabilityThreshold && currentLabel ~= "nothing" && currentLabel ~= lastAppendedLabel
        if currentLabel == "space"
            sentence = strcat(sentence, " "); % Add a space for "space" label
        else
            sentence = strcat(sentence, currentLabel); % Append the detected letter
        end
        lastAppendedLabel = currentLabel; % Update the last appended letter
        stableCount = 0; % Reset stability count after appending
    end
    
    % Update the previous label
    previousLabel = currentLabel;
    
    % Display the current frame, detected letter, and sentence
    imshow(annotatedFrame);
    title(['Detected Letter: ', currentLabel, ' | Sentence: ', sentence]);
    drawnow;
    
    % Break loop on key press (optional)
    pause(0.1); % Adjust for frame rate
end

% Release the webcam
clear cam;
