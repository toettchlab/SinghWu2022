function [imgBkgSubs]=offsetSubs(avgImg,nColor,DC);
[nImage,mImage,nSlice,numFiles]     =size(avgImg);
zStack                              =nSlice/nColor;

for iFiles=1:numFiles
    %imgGreenCh                          =zeros(nImage,mImage,nSlice,numFiles);
    %             imgRedCh                            =zeros(nImage,mImage);
    for jSlice=1:nSlice
        
        imgGreenCh=double(int64(double(avgImg(:,:,jSlice,iFiles))-double(DC)));
        imgBkgSubs01(:,:,jSlice)=imgGreenCh;
    end
    imgBkgSubs(:,:,:,iFiles)=imgBkgSubs01;
 
    
    
end

end