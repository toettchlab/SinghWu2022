function [point1,point2,apLength, xOutAPRotSpot,xOutAPRotNuc]=...
            xCordinateAPTipRot(fullEmbImg,scaleFactor,rotAngle,...
                antTipImg,pxSize,xCordinateSpot,xCordinateNuc)
            
  %%%%% this function takes full embryo image and caluclates total AP length 
  %%%%% of an embryo 
im01=mat2gray((fullEmbImg));


% sz = size(im,[]);
% myData.Units = 'pixels';
% myData.MaxValue = hypot(sz(1),sz(2));
% myData.Colormap = hot;
% myData.ScaleFactor = 1;
 im01=imresize(((im01)),scaleFactor);
im02=imrotate(im01,rotAngle);

imshow(mat2gray(im02),[]);
 

roi1 = drawpoint('Color','r');
point1=roi1.Position;
roi2= drawpoint('Color','b');
point2=roi2.Position;
close all
%%%--- Anterior tip point selection-----%%%%%%

figure(2);
imshow(mat2gray(antTipImg),[]);
roiTip1 = drawpoint('Color','g');
pointTip1=roiTip1.Position;
close all



% theta = atan((point2(2)-point2(1))/(point1(2)-point1(1)));
close all
 if point1(1)>point2(1)
     apLength=round(norm(point1-point2)*pxSize); %length in microns

xOutAPRotSpot(:,1)=(pointTip1(1)-xCordinateSpot)*pxSize./(apLength);
xOutAPRotNuc(:,1)=(pointTip1(1)-xCordinateNuc)*pxSize./(apLength);

 elseif point1(1)<point2(1)
          apLength=round(norm(point1-point2)*pxSize); %length in microns

xOutAPRotSpot(:,1)=((pointTip1(1)-xCordinateSpot)*pxSize./(apLength));
xOutAPRotNuc(:,1)=((pointTip1(1)-xCordinateNuc)*pxSize./(apLength));
 end
end