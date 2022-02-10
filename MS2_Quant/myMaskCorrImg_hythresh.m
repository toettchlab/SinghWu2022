function[myMasCorrImg,bw]=myMaskCorrImg_hythresh(myimg,n,lowTh,highTh,Conn)

img = imtophat((myimg),strel('disk',20));
myImg=padarray(img,[n,n]);
[bw,level]=hysteresis3d(myImg,lowTh,highTh,Conn);

bw1=imfill(bw,8,'holes');

%  img3=imgaussfilt(bw,2);

se = strel('disk',5);

bw2=imdilate(bw1,se);

bw3=imerode(bw2,strel('disk',15));

 

bw4=imdilate(bw3,strel('disk',25));

bw5=imclearborder(bw4,4);

bw=bw5(n+1:end-n,n+1:end-n);
myimg(~bw)=NaN;
myMasCorrImg=myimg;

end