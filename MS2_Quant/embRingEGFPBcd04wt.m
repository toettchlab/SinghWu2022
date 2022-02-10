function [BW2,bw3,Stats]=embRingEGFPBcd04wt(imgR,imgG)
myImg=imgR;
I=imgaussfilt(myImg,1);
% I = imclearborder(I);
 Iflatfield = imflatfield(I,20);
 Imtop = imtophat (Iflatfield,strel('disk',5));
[BW] = edge(Imtop,'Canny');
%     BW = imbinarize(I,T);
%     BW = imbinarize(Iflatfield,T);
    BWfill = imfill(BW,'holes'); %fill interior gap
    BW1 = bwareafilt(BWfill,1);
    seD = strel('disk',3);
    BW_open = imopen(BW1,seD);% pick the largest object
    se = strel('disk',5,0);
    kernel = se.Neighborhood / sum(se.Neighborhood(:));
    BWb = conv2(double(BW_open), kernel, 'same'); % blurring help to smooth the contour
    BW2 = imbinarize(BWb);
    BWd = imdilate(BW2,seD);
    BWoutline = bwperim(BWd); % get only outline of the contour
    %imshow(imfuse(I,BWoutline)); % show overlay image of outline on the original image
BW2=imerode(BW2,strel('disk',7,0));
    BW3=imerode(BW2,strel('disk',20,0));

 myMask=BW2-BW3;
myImg((myMask)==0)=0;
 myEmbRing=myImg;


ctrl_tmp = imflatfield(imgR,40);
%  Ig=imgaussfilt(ctrl_tmp,0.1);
Ig=imgaussfilt(ctrl_tmp,0.1);
%      ctrl_open = imopen (Ig,strel('disk',2));  %remove small background noise
%  ctrl_tophat = imtophat (Ig,strel('disk',2));
 ctrl_open = imopen (uint16(Ig),strel('disk',2));
%  ctrl_open = imerode(ctrl_open,strel('disk',2));
 ctrl_open((myMask)==0)=0;
B = locallapfilt(ctrl_open,0.8,0.6);

[filteredImage,estDoS] = imnlmfilt(B);
% imshow(filteredImage,[])
%    [bw,level]=fcmthresh( double(filteredImage),1);
 bw = single(ctrl_open > 1800 & ctrl_open<20000);;
% imshowpair(bw,binaryImage);
% T = adaptthresh(filteredImage, 0.6);
% bw = imbinarize(filteredImage,T);
% BW = imbinarize(ctrl_tophat1, 'adaptive');
% bw = im2bw(ctrl_tophat1, graythresh(ctrl_tophat1));
% [bw,level]=fcmthresh( ctrl_tophat1,1);
% E = stdfilt(ctrl_tophat1,ones(5));

%        imshow(ctrl_tophat1,[])
%  Img=conv2((ctrl_tophat1), DiffGauss(1,1,0.2), 'same');

% bw=imbinarize(ctrl_tophat1,'adaptive');

bw2= imopen (bw,strel('disk',2));
% bw2 = bwareafilt(bw2,[10 40]);
%    bw2=imerode(bw2,strel('disk',2));
% bw2= imfill(bw2,4,'holes');
% bw2= imopen (bw2,strel('disk',3));
% bw2=imerode(bw2,strel('disk',3));
% bw2=imerode(bw2,strel('disk',3));
% bw2=imdilate(bw2,strel('disk',5));



%      bw2=imclearborder(bw2,4);
%     imshow(myImg,[]);
%     bw2=imerode(bw2,strel('disk',3));
%      bw2= imopen (bw2,strel('disk',2));
%      imshow(bw2,[]);
%      bw1=imopen (bw,strel('disk',1));imshow(bw1,[])
% imshow(Img,[])
%  ctrl_eq = adapthisteq( );
%     [bw,level]=fcmthresh( ctrl_tophat1,1);
% % %     bw=sauvola(Img, [10 10],0.3);
% % %     bw2 = bwareaopen(bw, 100);
%     bw3 = imfill(bw2,'holes');
%     imshow(bw2,[]);
D = -bwdist(~bw2);
%     imshow(D,[]);
mask = imextendedmin(D,2);

% mask=imerode(mask,strel('disk',2));
% mask=imdilate(mask,strel('disk',1));
% imshowpair(bw2,mask,'blend')

D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = bw;
bw3(Ld2 == 0) = 0;
% bw4=imerode(bw3,strel('disk',2));

ctrl_tmp((-bw3)==0)=0;
% imshow(myImg,[]);
% imshow(imoverlay(ctrl_tmp,boundarymask(bw4), 'yellow'));
 ctrl_stats = regionprops(bw3,imgG,'Centroid','MeanIntensity','PixelValues');
%  ctrl_stats = regionprops(bw3,ctrl_tmp,'Centroid','MeanIntensity');
%    Stats=struct2cell(ctrl_stats(1));
%      Stats.MeanIntensity=ctrl_stats.MeanIntensity;
numObj = numel(ctrl_stats);
% C(:,:,:,:)=zeros(numObj,4);

for k = 1 : numObj
  
     ctrl_stats(k).StandardDeviation = std(double(ctrl_stats(k).PixelValues));
%  ctrl_stats(k).meanIn = mean(double(ctrl_stats(k).PixelValues));
%  x=ctrl_stats(k).Centroid(:,1);
%  y=ctrl_stats(k).Centroid(:,2);
%  C(k,1)=x;
%  C(k,2)=y;
%  C(k,3)=ctrl_stats(k).MeanIntensity;
%   C(k,4)=ctrl_stats(k).StandardDeviation;
% % histogram(ctrl_stats(k).PixelValues, 100);
% % hold on
end

field = 'PixelValues';
Stats = rmfield(ctrl_stats,field);

end