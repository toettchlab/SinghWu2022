function [imgBkgSubs]=offsetRoiSubs(avgImg,nColor,M,offset);
[nImage,mImage,nSlice,numFiles]     =size(avgImg);
zStack                              =nSlice/nColor;
imgBkgRoi=avgImg(M(1):M(2),M(3):M(4),:,:);
meanBkgValue=mean(imgBkgRoi,[1,2]);
for iFiles=1:numFiles
    %imgGreenCh                          =zeros(nImage,mImage,nSlice,numFiles);
    %             imgRedCh                            =zeros(nImage,mImage);
    for jSlice=1:nSlice
        
        imgGreenCh=double(int64(double(avgImg(:,:,jSlice,iFiles))+offset-double(meanBkgValue(:,:,jSlice,iFiles))));
        imgBkgSubs01(:,:,jSlice)=imgGreenCh;
    end
    imgBkgSubs(:,:,:,iFiles)=imgBkgSubs01;
 
    
    
end

end