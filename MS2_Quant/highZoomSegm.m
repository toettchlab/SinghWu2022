function [bw2,myGreenImg,stats]=highZoomSegm(imgG,imgR)
myImg=imgR;
I=imgaussfilt(myImg,2);
I=imgaussfilt(I,4);
level = multithresh(I,4);

seg_I = imquantize(I,level(1));

  bw2= imtophat (seg_I,strel('disk',50));
  bw2=imopen(bw2,strel('disk',15));
  bw2=imerode(bw2,strel('disk',5));
  bw2=imdilate(bw2,strel('disk',8));
bw2=imclearborder(bw2);
bw2=imerode(bw2,strel('disk',5));



myGImg=imgG;

myGImg((bw2)==0)=0;
 segGreenCh=myGImg;

bw3 = imfill(bw2,'holes');
 D = -bwdist(~bw2);
% % %     imshow(D,[]);
 mask = imextendedmin(D,5);

 D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw4 = bw3;
 bw4(Ld2 == 0) = 0;
myGreenImg=imgG;
  myGreenImg(bw4 == 0) = 0;
  CC = bwconncomp(bw4);
  
 stats = regionprops(CC,myGreenImg,{'Centroid','MeanIntensity','PixelValues'});

numObj = numel(stats);


for k = 1 : numObj
  
     stats(k).StandardDeviation = std(double(stats(k).PixelValues));

end

field = 'PixelValues';
stats = rmfield(stats,field);

end