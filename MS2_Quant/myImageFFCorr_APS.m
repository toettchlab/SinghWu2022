function [myFFCorrImage,G,myMaskImg]= myImageFFCorr_APS(my3DData,DCdataFolder,FFdataFolder,nColor,mask)

[myImageData]           =loadStack(my3DData);


[myDCImage]             =loadStack(DCdataFolder,1);
[darkCurrentMinValue]   =DC_minValue_APS(myDCImage,nColor);

% [ flatFieldFinalImage ] = extractFF4_APS(FFdataFolder,nColor,DCdataFolder);
darkCurrent=-32000;
[ FF1,G ] = extractFF4x( FFdataFolder, 1024, 512, darkCurrent );



[m,n,nSlice,nFiles]      =size(myImageData);
zStack                   =nSlice/nColor;



[avgImg]                =zStkAvg_APS(myImageData,nColor);

 % mask is used for lower zoom say 2-4 zoom
 %%%---
if  (mask==1 & nColor==2)
 myBWImage=zeros(m,n,nFiles);
 for iFiles=1:nFiles

     [myBWImage(:,:,iFiles)] =myMaskCorrImg_fcmthresh(avgImg(:,:,1,iFiles),50,0);


 end


 for iFiles=1:nFiles
     for jSlice=1:nSlice

         if mod(jSlice,2)==1
             myImgDC_subs(:,:,jSlice)=double(myImageData(:,:,jSlice,iFiles)-double(darkCurrentMinValue(1)));

             myImgFFCorr= double((myImgDC_subs(:,:,jSlice))./flatFieldFinalImage(:,:,1));

         else
             myImgDC_subs(:,:,jSlice)=double(myImageData(:,:,jSlice,iFiles)-double(darkCurrentMinValue(2)));

             myImgFFCorr= double(double((myImgDC_subs(:,:,jSlice))./flatFieldFinalImage(:,:,2)));

         end

         %%% Add roimanager here to set ROI and respixels to NAn

         myImgFFCorr(~myBWImage(:,:,iFiles))=NaN;
         myImage(:,:,jSlice,iFiles) =myImgFFCorr;
         %              [myImage(:,:,jSlice,iFiles),myBWImage(:,:,jSlice,iFiles)] =myMaskCorrImg_fcmthresh(myImgFFCorr,50,0);
         %         [myImage(:,:,jSlice,iFiles),myBWImage(:,:,jSlice,iFiles)]=myMaskCorrImg_hythresh(myImgFFCorr,50,0.15,0.8,4);
     end
     myFFCorrImage= myImage;
     myBWimg=myBWImage;

 end

 
elseif (mask==0 && nColor==2)
             for iFiles=1:nFiles
                 for jSlice=1:nSlice

                     if mod(jSlice,2)==1
                         myImgDC_subs(:,:,jSlice)=double(myImageData(:,:,jSlice,iFiles)-double(darkCurrentMinValue(1)));

                         myImgFFCorr= double((myImgDC_subs(:,:,jSlice))./flatFieldFinalImage(:,:,1));


                     else
                         myImgDC_subs(:,:,jSlice)=double(myImageData(:,:,jSlice,iFiles)-double(darkCurrentMinValue(2)));

                         myImgFFCorr= double(double((myImgDC_subs(:,:,jSlice))./flatFieldFinalImage(:,:,2)));

                         %                 myImage(:,:,jSlice,iFiles) =myImgFFCorr;

                     end

                     %%% Add roimanager here to set ROI and respixels to NAn


                     myImage(:,:,jSlice,iFiles) =myImgFFCorr;
                     %              [myImage(:,:,jSlice,iFiles),myBWImage(:,:,jSlice,iFiles)] =myMaskCorrImg_fcmthresh(myImgFFCorr,50,0);
                     %         [myImage(:,:,jSlice,iFiles),myBWImage(:,:,jSlice,iFiles)]=myMaskCorrImg_hythresh(myImgFFCorr,50,0.15,0.8,4);
                 end
                 myFFCorrImage= myImage;
             end

else (mask==0 && nColor==1) 

     for iFiles=1:nFiles
         for jSlice=1:nSlice

             myImgDC_subs(:,:,jSlice)=double(myImageData(:,:,jSlice,iFiles)-double(min(myImageData(:))));

             myImgFFCorr(:,:,jSlice)= double((myImgDC_subs(:,:,jSlice))./G);

         end

             myImage(:,:,:,iFiles) =myImgFFCorr;
         %              [myImage(:,:,jSlice,iFiles),myBWImage(:,:,jSlice,iFiles)] =myMaskCorrImg_fcmthresh(myImgFFCorr,50,0);
         %         [myImage(:,:,jSlice,iFiles),myBWImage(:,:,jSlice,iFiles)]=myMaskCorrImg_hythresh(myImgFFCorr,50,0.15,0.8,4);
     end
             myFFCorrImage= myImage;



end



end