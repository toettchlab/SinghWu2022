function [maskRing,myEmbRing]=twoImageStitch(im)

imG=imgaussfilt(im,8);
thresh = multithresh(imG,3);
seg_I1 = imquantize(im,thresh(2));
seg_I1=imfill(seg_I1,'holes');

imTopHat=imtophat (seg_I1,strel('disk',20));

bw2=imopen(imTopHat,strel('disk',6));

bw2=imfill(bw2,'holes');

    seD = strel('disk',3);
    BW_open = imopen(bw2,seD);
    imDil=imdilate(BW_open,strel('disk',10));
     imDil=imdilate(BW_open,strel('disk',10));
 seg_I2=imfill(imDil,'holes');
 BW2 = imbinarize(seg_I2);
 BW2 = bwareafilt(BW2,400);
 CH = bwconvhull(BW2,'objects');
 mask1=imdilate(CH,strel('disk',5));
 mask1=imerode(CH,strel('disk',10));
 mask2=imerode(mask1,strel('disk',30));
  maskRing=mask1-mask2;
%   imshow(maskRing,[])
myImg=im;
myImg((maskRing)==0)=0;
 myEmbRing=myImg;
end