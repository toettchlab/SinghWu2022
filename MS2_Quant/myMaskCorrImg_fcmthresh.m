function [bw]=myMaskCorrImg_fcmthresh(myimg,n,sw)
myImg = imtophat((myimg),strel('disk',20));
myImg=padarray(myImg,[n,n]);
[bw1,level]=fcmthresh((myImg),sw);

% bw=edge(bw,'canny');

bw2=imfill(bw1,8,'holes');

%  img3=imgaussfilt(bw,2);

se = strel('disk',5);

bw3=imdilate(bw2,se);

bw4=imerode(bw3,strel('disk',10));

 

bw=imdilate(bw4,strel('disk',15));

%  bw=imclearborder(bw5,4);
bw=bw(n+1:end-n,n+1:end-n);
% myimg(~bw)=NaN;
% myMasCorrImg=myimg;
end



