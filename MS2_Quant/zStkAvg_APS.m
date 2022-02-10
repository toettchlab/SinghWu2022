function  [avgImg]=zStkAvg_APS(my3DData,nColor)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%This function takes average of all the z-slices
%%% 'my3DData' has data structure as below [nImage,mImage,nSlice,numFiles]

[nImage,mImage,nSlice,numFiles]     =size(my3DData);
zStack                              =nSlice/nColor;

if nColor==1

    
    for iFiles=1:numFiles
        imgGreenCh                          =zeros(nImage,mImage);
       
        for jSlice=1:nSlice
            
            
            imgGreenCh=imgGreenCh+double(my3DData(:,:,jSlice,iFiles));
            
        end
        imgGreenChAvg(:,:,1,iFiles)=double(imgGreenCh/zStack);
    end
    
    avgImg=imgGreenChAvg;

end 




if nColor==2
    
    
    for iFiles=1:numFiles
        imgGreenCh                          =zeros(nImage,mImage);
        imgRedCh                            =zeros(nImage,mImage);
        for jSlice=1:nSlice
            
            %odd add all the green channel images and take average
            if mod(jSlice,2)==1
                
                imgGreenCh=imgGreenCh+double(my3DData(:,:,jSlice,iFiles));
                
                %even add all the Red channel images and take average
            else
                imgRedCh=imgRedCh+double(my3DData(:,:,jSlice,iFiles));
                
            end
            
        end
        imgGreenChAvg(:,:,iFiles)=double(imgGreenCh/zStack);
        imgRedChAvg(:,:,iFiles)=double(imgRedCh/zStack);
        I(:,:,1,iFiles)=imgGreenChAvg(:,:,iFiles);
        I(:,:,2,iFiles)=imgRedChAvg(:,:,iFiles);
        avgImg=I;
        
        
    end
    
    
    
end



end