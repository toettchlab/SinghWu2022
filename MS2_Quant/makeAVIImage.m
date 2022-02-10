function makeAVIImage(img,dataFolder,fileString)
close all
Img=mat2gray(img);
v = VideoWriter([dataFolder,sprintf('%s_AvgImg.avi',fileString)]);
open(v)
% v.FrameRate = 10;
[~,~,numFiles]=size(Img);
for iFiles=1:numFiles
    
        
         imshow(Img(:,:,iFiles),[]);
    CurrFrame=getframe;
        writeVideo(v,CurrFrame);
  
    
end

close(v);

end
