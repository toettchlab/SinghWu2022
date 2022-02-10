function  [imgGreenCh,imgRedCh]=chSplitterFF(myDataFolder,nColor,DC)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%This splits green and red channel files and subtracts the min value from
%each channels
%%% 'my3DData' has data structure as below [nImage,mImage,nSlice,numFiles]

[myImageData]           =loadStack(myDataFolder);
[imgBkgSubs]=offsetSubs(myImageData,nColor,DC);
[~,~,nSlice,numFiles]     =size(imgBkgSubs);
zStack                              =nSlice/nColor;

if nColor==1


 save ([myDataFolder,sprintf('%s_myImageData.mat',fileString)],'myImageData','-v7.3','-nocompression');


elseif nColor==2
    
    
    for iFiles=1:numFiles
%         imgGreenCh                          =zeros(nImage,mImage);
%         imgRedCh                            =zeros(nImage,mImage);
        jCounter=0;
        for jSlice=1:nSlice
            
            %odd add all the green channel images and take average
            if mod(jSlice,2)==1
                jCounter=jCounter+1;
                imgGreenCh(:,:,jCounter,iFiles)=imgBkgSubs(:,:,jSlice,iFiles);
                
                %even add all the Red channel images and take average
            else
                imgRedCh(:,:,jCounter,iFiles)=imgBkgSubs(:,:,jSlice,iFiles);
                
            end
            
        end

        Img=[{imgGreenCh},{imgRedCh}];
        
    end
    fileStr=[{'greenCh'},{'redCh'}];
    for kColor=1:nColor
    mkdir([myDataFolder,fileStr{kColor}]);
    newFolder{kColor}=strcat([myDataFolder,fileStr{kColor},filesep]);
     save ([newFolder{kColor},filesep,sprintf('%s_myImageData.mat',fileStr{kColor})],'Img','-v7.3','-nocompression');
        saveTiff(int16(Img{kColor}), [newFolder{kColor},sprintf([ 'file%s','.tif'],fileStr{kColor})]);

%   
    end 
end



end