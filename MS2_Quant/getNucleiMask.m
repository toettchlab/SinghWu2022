function [ mask ] = getNucleiMask( Im, emask, sig )
%getNucleiMask
%   obtain nuclei mask from surface image

% Filter image
xy  = -2*round(sig):2*round(sig);
Fxy = normpdf(xy,0,sig);
ImF = imfilter(Im,Fxy','symmetric','conv');
ImF = imfilter(ImF,Fxy,'symmetric','conv');
s2  = strel('ball',4,2);

% Segmentation steps
mask = imfill(ImF,'holes');
mask = imclose(mask,s2);
if isempty(emask)
    lev = graythresh(mask);
else
    lev = graythresh(mask(emask));
    lev = graythresh(mask(mask >= lev));
    %lev = graythresh(mask(mask >= lev));
end

mask = (mask >= lev);
mask = imfill(mask,'holes');

% d = -bwdist(~mask);
% d(~mask) = -inf;
% d = imhmin(d,1);
% mask = watershed(d);
% 
% P = regionprops(mask,'Area','PixelIdxList');
% areas = vertcat(P.Area);
% %p25 = prctile(areas,25);
% p75 = prctile(areas,75);
% 
% %Ia = p25/10 < areas & areas < 3*p75;
% Ia = areas < 3*p75;
% pixelIdx = vertcat(P(Ia).PixelIdxList);
% mask = false(size(mask));
% mask(pixelIdx) = true;

end

