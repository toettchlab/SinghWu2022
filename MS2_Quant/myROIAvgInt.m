%% splitting ROI in small areas and making average Intensity for the spost
function  myROIAvgInt(roiMat,pxStep,pyStep)
pxMin=roiMat(1,1);
pxMax=roiMat(1,2);
% pxStep=100;
pxRange=pxMin:pxStep:pxMax;

pyMin=roiMat(2,1);
pyMax=roiMat(2,2);
% pyStep=50;
pyRange=pyMin:pyStep:pyMax;
myCounter=0;

for iX=1:length(pxRange)-1
    for iY=1:length(pyRange)-1
        myCounter=myCounter+1;
        pYMean{myCounter}=mean([pyRange(iY),pyRange(iY+1)])';
        indXYCorFil_spots{myCounter}=find(statslist_spot(:,1)>pyRange(iY) ...
            & statslist_spot(:,1)<pyRange(iY+1) &...
statslist_spot(:,2)>pxRange(iX) & statslist_spot(:,2)<pxRange(iX+1));

 statslist_spotFilt{1,myCounter}=statslist_spot(indXYCorFil_spots{1,myCounter},:);
%  statslist_nucFilt{1,mRoi}=statslist_nuc(indXYCorFil_spots{1,mRoi},:);
    end
    
end




for gInd=1:size(indXYCorFil_spots,2)
  subPix=statslist_spot(indXYCorFil_spots{gInd},:);
 [myArrayMean02{gInd},myArrayMeanTime{gInd},myArrayStd{gInd}]...
     =singleArray2MultiPageArray_2Color(subPix);
%  subplot(2,2,[1,2])
%  hold on
%  plot((timeperimage).*myArrayMeanTime{gInd},myArrayMean02{gInd}...
%     ,'-bo','MarkerEdgeColor','none','MarkerFaceColor','c',...
%      'MarkerSize',2) 
%  hold off
% 
%  xlabel('Time (sec)', 'FontSize', 16)
% ylabel('Intensity (AU)','FontSize', 16) 
  myBinIntTime{gInd}(:,1)=myArrayMean02{gInd};
  myBinIntTime{gInd}(:,2)=myArrayMeanTime{gInd};
  myBinIntTime{gInd}(:,3)=myArrayStd{gInd};
end


%%%% arrange pixel in value in Y and Intensity and time farme
myPyIntTime(1,:)=pYMean;
% myBinIntTime{}=
myPyIntTime(2,:)=myBinIntTime;


for myPlot=1:length(myPyIntTime(2,:))
    for myPlot02=1:max(myPyIntTime{2,myPlot}(:,2))
        plot(myPyIntTime{1,myPlot},myPyIntTime{2,myPlot}(myPlot02,1),'o-')
        hold on
    end
    
end

end





