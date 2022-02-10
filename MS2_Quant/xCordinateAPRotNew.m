function [apLength, xOutAPRotSpot,xOutAPRotNuc]=xCordinateAPRotNew(point1,point2,pxSize,xCordinateSpot,xCordinateNuc)

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