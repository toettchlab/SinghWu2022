function [ im2 ] = imnormalize(im, width) 
    % IMAGE NORMALIZE. Returns a normalized, blurred image.
    %
    % Inputs
    % 1. im - Image to be normalized.
    % 2. width - size of gaussian filter. Optional.
    
    if (nargin == 1)
        width = 80;
    end
    
    im = double(im);
    im = im - imfilter(im, fspecial('average', width)); %mean normalize
    im = im ./ (sqrt(imfilter(im .* im, fspecial('average', width))));
    im = im / std(im(:));
    im2 = double(im);     
end
