function [ im, x, y ] = imstitch_APS( im1, im2, PL )
    % IMAGE STITCH. Stitches two images together by calculating the
    % distance between subregions and merging the subregion overlapping
    % between both images that has the minimal difference and returning the
    % resultant composite image.
    %
    % Inputs
    % 1. im1 - First image (left).
    % 2. im2 - Second image (right).
    
    if nargin<3
        PL = 3;
    end
    
    [optimizer, metric] = imregconfig('multimodal');
    
    optimizer.InitialRadius = 0.0002;
    optimizer.Epsilon = 1.5e-4;
    optimizer.GrowthFactor = 1.0001;
    optimizer.MaximumIterations = 300;
    
    %tform = imregtform(im2,im1, 'translation', optimizer, metric);
    %tform = imregtform(im2,im1, 'similarity', optimizer, metric);
        
    A = eye(3);
    pini = 0.5*(size(im1)-size(im2));
    A(3,1:2) = [pini(2),pini(1)];
    initform = affine2d(A);
    
    tform = imregtform(im2,im1, 'translation', optimizer, metric, 'InitialTransformation',initform,'PyramidLevels',PL);
%     movingRegistered = imwarp(im2,tform,'OutputView',imref2d(size(im1)));
movingRegistered = imregister(im2, im1, 'affine', optimizer, metric);
movingRegisteredT = imwarp(im2,tform,'OutputView',imref2d(size(im1)));

% figure
% imshowpair(im1, movingRegistered,'Scaling','joint');
% figure
% imshowpair(im1, movingRegisteredT,'Scaling','joint');
    x = (round(tform.T(3,1)));
    y = round(tform.T(3,2));
    im = immerge_APS(im1,im2,x,y);
    imshow(im,[])
%     [im2,Rim2] = imwarp(im2,imref2d(size(im2)),tform);
%     [im,Rim] = imfuse(im1,imref2d(size(im1)),im2,Rim2,'blend','scaling','joint');
end

