clc;
close all;
clear all;
warning off       

% initialize webcam object
c=webcam;         
% set initial x-coordinate for rectangle
x=0;              
% set initial y-coordinate for rectangle
y=0;              
% set height of rectangle
height=200;       
% set width of rectangle
width=200;        
% create a bounding box around the rectangle
bboxes=[x y height width];   
% set a counter for the loop
temp=0;           

% loop for 1000 iterations
while temp<=3000   
    % capture a snapshot from the webcam
    e=c.snapshot;  
    % insert a rectangle with a label into the snapshot image
    IFaces = insertObjectAnnotation(e,'rectangle',bboxes,'Processing Area'); 
    % show the image with the rectangle and label
    imshow(IFaces); 
    % create a filename for the cropped image
    filename=strcat(num2str(temp),'.bmp');  
    % crop the snapshot to the size of the rectangle
    es=imcrop(e,bboxes);  
    % resize the cropped image
    es=imresize(es,[227 227]);  
    % save the cropped and resized image to file
    imwrite(es,filename);  
    % increment the counter
    temp=temp+1;   
    % update the display
    drawnow;       
end

% clear the webcam object from memory
clear c;