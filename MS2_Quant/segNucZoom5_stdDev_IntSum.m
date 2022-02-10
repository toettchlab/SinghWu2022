function [myImg,bw3,Stats]=segNucZoom5_stdDev_IntSum(imgfile,nucOffset)

ctrl_tmp = imgfile;
% Ig=imgaussfilt(ctrl_tmp,2.5);
Ig=smoothn(ctrl_tmp,'robust');
%  bw2=imerode(Ig,strel('disk',3));
%  bw2= imfill(bw2,4,'holes');
%   bw2=imerode(bw2,strel('disk',2));
  ctrl_tophat = imtophat (Ig,strel('disk',8));
   ctrl_tophat1 = imopen (ctrl_tophat,strel('disk',6));
 bw2=ctrl_tophat1>nucOffset;
% Img=conv2((ctrl_tophat1), DiffGauss(10,8,5), 'same');
%   bw2= imopen(ctrl_tophat,strel('disk',8));
%   [bw2,level]=fcmthresh(bw2,1);

%     bw2=imerode(bw2,strel('disk',2));
%      bw2= imfill(bw2,4,'holes');

%   bw2=imerode(bw2,strel('disk',5));
% 
% bw2=imdilate(bw2,strel('disk',2));
% 
% LB = 50;
% UB = 650;
% bw2 = xor(bwareaopen(bw2 , LB) , bwareaopen(bw2 , UB)); 
% % imshowpair(Ig,bw2);
%     ctrl_open = imopen (Ig,strel('disk',2));  %remove small background noise




D = -bwdist(~bw2);
%     imshow(D,[]);
mask = imextendedmin(D,1);
% mask=imerode(mask,strel('disk',2));
% mask=imdilate(mask,strel('disk',2));
%  imshowpair(bw2,mask,'blend')

D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = bw2;
bw3(Ld2 == 0) = 0;
 bw3=imerode(bw3,strel('disk',1));

 bwObj = bwconncomp(bw3);
% bw4=imerode(bw3,strel('disk',2));
myImg=ctrl_tmp;
myImg((-bw3)==0)=0;
% imshow(myImg,[]);
% imshow(imoverlay(ctrl_tmp,boundarymask(bw4), 'yellow'));
 ctrl_stats = regionprops(bwObj,ctrl_tmp,'Centroid','MeanIntensity','PixelValues');
%  ctrl_stats = regionprops(bw3,ctrl_tmp,'Centroid','MeanIntensity');
%    Stats=struct2cell(ctrl_stats(1));
%      Stats.MeanIntensity=ctrl_stats.MeanIntensity;
numObj = numel(ctrl_stats);
% C(:,:,:,:)=zeros(numObj,4);

for k = 1 : numObj
  ctrl_stats(k).offsetMeanInt=ctrl_stats(k).MeanIntensity;
     ctrl_stats(k).StandardDeviation = std(double(ctrl_stats(k).PixelValues));
     ctrl_stats(k).integratedGrayValues = sum(ctrl_stats(k).PixelValues);
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