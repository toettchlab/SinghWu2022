function [ mask ] = makeMask( fullEmbryo, blurSigma )
    % MAKE MASK. Takes in the stitched embryo image and produces a BW image 
    % with the recognized embryo signaled by white pixels.
    %
    % Inputs
    % 1. fullEmbryo - stitched image.
    
    mask = imfilter(double(fullEmbryo),...
        fspecial('gaussian',3,3),'replicate','conv');
    
    %norma = prctile(mask(:),95);
    norma = prctile(mask(:),90);
    mask = mask/norma;
    mask(mask>1) = 1;
        
    level = graythresh(mask);
    bw = im2bw(mask,level);
    se = strel('disk',3);
    bw = imclose(bw,se);
    bw = imfill(bw,'holes');
    bw = bwselect(bw,round(size(bw,2)/2),round(size(bw,1)/2));
    
    se = strel('disk',blurSigma);
    bw = imopen(bw,se);
    
    mask = imfilter(mat2gray(bw),...
        fspecial('gaussian',2*blurSigma,blurSigma),'replicate','conv');
    
    level = graythresh(mask);
    mask = im2bw(mask,level);
end

