function [myImg,bw3,Stats]=segNucleiZoom9_prevSeg(imgfile)

ctrl_tmp = (imgfile);
Ig=imgaussfilt(ctrl_tmp,2);
%     ctrl_open = imopen (Ig,strel('disk',2));  %remove small background noise
ctrl_tophat = imtophat (Ig,strel('disk',16));
ctrl_tophat1 = imopen (ctrl_tophat,strel('disk',8));
%        imshow(ctrl_tophat1,[])
Img=conv2((ctrl_tophat1), DiffGauss(12,1,10), 'same');

bw=imbinarize(Img,'adaptive','ForegroundPolarity','dark');
bw2= imopen (bw,strel('disk',2));
bw2= imfill(bw2,4,'holes');
bw2= imopen (bw2,strel('disk',3));
bw2=imerode(bw2,strel('disk',3));
bw2=imerode(bw2,strel('disk',3));
bw2=imdilate(bw2,strel('disk',5));



%      bw2=imclearborder(bw2,4);
%     imshow(myImg,[]);
%     bw2=imerode(bw2,strel('disk',3));
%      bw2= imopen (bw2,strel('disk',2));
%      imshow(bw2,[]);
%      bw1=imopen (bw,strel('disk',1));imshow(bw1,[])
% imshow(Img,[])
%  ctrl_eq = adapthisteq( );
%     [bw,level]=fcmthresh( ctrl_tophat1,0);
% % %     bw=sauvola(Img, [10 10],0.3);
% % %     bw2 = bwareaopen(bw, 100);
%     bw3 = imfill(bw2,'holes');
%     imshow(bw2,[]);
D = -bwdist(~bw2);
%     imshow(D,[]);
mask = imextendedmin(D,2);
mask=imerode(mask,strel('disk',2));
mask=imdilate(mask,strel('disk',3));
% imshowpair(bw2,mask,'blend')

D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = bw2;
bw3(Ld2 == 0) = 0;
% bw4=imerode(bw3,strel('disk',2));
myImg=ctrl_tmp;
myImg((-bw3)==0)=0;
% imshow(myImg,[]);
% imshow(imoverlay(ctrl_tmp,boundarymask(bw4), 'yellow'));
 ctrl_stats = regionprops(bw3,ctrl_tmp,'Centroid','MeanIntensity','PixelValues');
%  ctrl_stats = regionprops(bw3,ctrl_tmp,'Centroid','MeanIntensity');
%    Stats=struct2cell(ctrl_stats(1));
%      Stats.MeanIntensity=ctrl_stats.MeanIntensity;
numObj = numel(ctrl_stats);
for k = 1 : numObj
  
     ctrl_stats(k).StandardDeviation = std(double(ctrl_stats(k).PixelValues));
 

end

field = 'PixelValues';
Stats = rmfield(ctrl_stats,field);




end