function [ im ] = immerge_APS( im1, im2, x, y )
    % IMAGE MERGE. Merge image 1 (left) with image 2 (right) based upon
    % averaging over the subregion defined by coordinates x and y (same
    % convention as used in imstitch algorithm).
    %
    % Inputs
    % 1. im1 - Left image.
    % 2. im2 - Right image.
    % 3. x - Horizontal coordinate of subregion.
    % 4. y - Vertical coordinate of subregion.
    
    y1 = size(im1,1);
    y2 = size(im2,1);
    x1 = size(im1,2);
    x2 = size(im2,2);
    % assumption: im1 larger than im2, x>=0
    
    if y<0
        im = zeros(y1-y,max(x1,x2+x),class(im1));
        im1ext = im;
        im2ext = im;
        
        im1ext((1:y1)+abs(y),1:x1) = im1;
        im2ext(1:y2,x+(1:x2)) = im2;           
    else
        im = zeros(max(y1,y2+y),max(x1,x2+x),class(im1));
        im1ext = im;
        im2ext = im;
        
        im1ext(1:y1,1:x1) = im1;
        im2ext((1:y2)+y,x+(1:x2)) = im2;
    end
    
    I = false(size(im));
    I(im1ext>0 & im2ext>0) = true;
    im(~I) = im1ext(~I) + im2ext(~I);
    im(I)  = 0.5*(im1ext(I)+im2ext(I));
end

