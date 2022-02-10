function [imgOut,bw]=roiManager(img)

%%%% Date- 11/01/2019

%%% This function takes image and provides bw mask of the object and
%%% detects object and creates outside pixels to NAn (not a number).

background = imopen(img,strel('disk',50));
imgt = ((img-background));
% [centroids, bboxes, mask] = detectObjects(imgt)


% img2=imadjust(imgt);
 img3=imgaussfilt(imgt,20);
%  img3=imgaussfilt(img3,10);
 imborder = imclearborder(img3,4);
se = strel('disk',20);
img4=imdilate(imborder,se);

 level=thresholdLocally(img4);
% level=multithresh(img4);
bw=imbinarize(bw, 0.3*level);
% bw = imclearborder(bw,4);
% bw=imquantize(img4,level);
bw=imdilate(bw,strel('disk',10));
% bw2=imdilate(bw2,strel('disk',5));
% visboundaries(bw2,'Color','green')
I=((img).*bw);
I(bw == 0) = NaN;
imgOut=I;

end