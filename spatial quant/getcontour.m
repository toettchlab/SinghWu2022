% input specifies the tif file, and the frame no.
% BWd: filled contour, BWoutline: only the outermost line
function [BWd,BWoutline] = getcontour(bro,n)

    
    I = imread(bro,n);
    [~,T] = edge(I,'sobel');
    BW = imbinarize(I,T);
    BWfill = imfill(BW,'holes'); %fill interior gap
    BW1 = bwareafilt(BWfill,1);
    seD = strel('disk',3);
    BW_open = imopen(BW1,seD);% pick the largest object
    se = strel('disk',10,0);
    kernel = se.Neighborhood / sum(se.Neighborhood(:));
    BWb = conv2(double(BW_open), kernel, 'same'); % blurring help to smooth the contour
    BW2 = imbinarize(BWb);
    BWd = imdilate(BW2,seD);
    BWoutline = bwperim(BWd); % get only outline of the contour
    imshow(imfuse(I,BWoutline)); % show overlay image of outline on the original image
    close;
   
    
    
    
