function [DCminValue]=DC_minValue_APS(my3DData,nColor)

%This function gives min dark current value to substract from raw data images for both green and red channel
[nImage,mImage,nSlice,numFiles]     =size(my3DData);
zStack                              =nSlice/nColor;

%%%if only one color image and multiple images to take average
if (nColor==1) && (numFiles==1)
 
    DCminValue=min(my3DData(:));
else
       
%%%if tow color channels and multiple images to take average first for
%%%green and red channel (use function 'twoColorZstkAvg'). Then take
%%%average value for both green and red Ch.
    [avgImg]=twoColorZstkAvg_APS(my3DData,nColor);
   [~,~,nSlice,~]=size(avgImg); 
   zStack                              =nSlice/nColor;
   for iColor=1:nColor
       DCminValue=min(min(avgImg(:,:,iColor,:)));
   end
end   
  
end