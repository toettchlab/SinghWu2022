function [point1,point2,apLength, xOutAPRotSpot,xOutAPRotNuc]=xCordinateAPRot(fullEmbImg,scaleFactor,rotAngle,pxSize,xCordinateSpot,xCordinateNuc)
im01=mat2gray((fullEmbImg));


% sz = size(im,[]);
% myData.Units = 'pixels';
% myData.MaxValue = hypot(sz(1),sz(2));
% myData.Colormap = hot;
% myData.ScaleFactor = 1;
 im01=imresize(((im01)),scaleFactor);
im02=imrotate(im01,rotAngle);
figure(1);
gridImage(im02,100);
 
% obj = imfuse(im01,im02);


figure(2);
imshow(im02,[]);
roi1 = drawpoint('Color','r');
point1=roi1.Position;
roi2= drawpoint('Color','b');
point2=roi2.Position;
% theta = atan((point2(2)-point2(1))/(point1(2)-point1(1)));
close all
 if point1(1)>point2(1)
     apLength=round(norm(point1-point2)*pxSize); %length in microns

xOutAPRotSpot(:,1)=(point1(1)-512-xCordinateSpot)*pxSize./(apLength);
xOutAPRotNuc(:,1)=(point1(1)-512-xCordinateNuc)*pxSize./(apLength);

 elseif point1(1)<point2(1)
          apLength=round(norm(point1-point2)*pxSize); %length in microns

xOutAPRotSpot(:,1)=((point2(1)-512-xCordinateSpot)*pxSize./(apLength));
xOutAPRotNuc(:,1)=((point2(1)-512-xCordinateNuc)*pxSize./(apLength));
 end
end