function [intROIPool,intTimeData]=spatialIntPlotX(roiPlotsAlongX,statslist_spot,yRangeNew01,yRangeNew02,...
    statslist_nuc,timePerF,xAxisOffset,indexGolaySmooth)


%%% sort particle ID incrasing order
%%% roiPlotsAlongX roi pixel coordinates along x axis
%%% yRangeNew01 roi pixel range y axis


for mRoi=1:size(roiPlotsAlongX,2)
    if mRoi<max(size(roiPlotsAlongX,2))
indXYCorFil_spots{1,mRoi}=find(statslist_spot(:,1)>roiPlotsAlongX(mRoi)...
    & statslist_spot(:,1)<roiPlotsAlongX(mRoi+1) &...
statslist_spot(:,2)>yRangeNew01 & statslist_spot(:,2)<yRangeNew02);

indXYCorFil_nuc{1,mRoi}=find(statslist_nuc(:,1)>roiPlotsAlongX(mRoi)...
    & statslist_nuc(:,1)<roiPlotsAlongX(mRoi+1) &...
statslist_nuc(:,2)>yRangeNew01 & statslist_nuc(:,2)<yRangeNew02);

statslist_spotFilt{1,mRoi}=statslist_spot(indXYCorFil_spots{1,mRoi},:);
 statslist_nucFilt{1,mRoi}=statslist_nuc(indXYCorFil_nuc{1,mRoi},:);
myStatData{:,1}=statslist_spotFilt;
myStatData{:,2}=statslist_nucFilt;
for iColor=1:size(myStatData,2)
for iPlots = 1:max(myStatData{1,iColor}{1,mRoi}(:,7))

% %   
    index01 = ((myStatData{1,iColor}{1,mRoi}(:,7)) == iPlots);
      trackposTT{iPlots,iColor}{1,mRoi} = myStatData{1,iColor}{1,mRoi}(index01,:);
%     trackposTT_nuc = myStatData{1,iColor}{1,mRoi}(index01,:);
%     GG{iPlots}=trackposTT; 
%     GS{iPlots}{1,mRoi}=sortrows(GG{iPlots},6);  % sorts the row increasing x value
 intTimeData{iColor}{1,mRoi}(iPlots,1)=iPlots;
 intTimeData{iColor}{1,mRoi}(iPlots,2)=iPlots*timePerF-xAxisOffset;
% % 
% % 
  intTimeData{iColor}{1,mRoi}(iPlots,3) =mean(trackposTT{iPlots,iColor}...
      {1,mRoi}(:,3));
intTimeData{iColor}{1,mRoi}(iPlots,4)   =std(trackposTT{iPlots,iColor}...
    {1,mRoi}(:,3));
 intTimeData{iColor}{1,mRoi}(iPlots,5)  =std(trackposTT{iPlots,iColor}...
     {1,mRoi}(:,3))./(sqrt(length(trackposTT{iPlots,iColor}{1,mRoi}(:,3))));
 
 intTimeData{iColor}{1,mRoi}(iPlots,6)=sum((trackposTT{iPlots,iColor}...
      {1,mRoi}(:,6)));
  
%   if  isempty(size(trackposTT{iPlots,iColor}{1,mRoi},1)) 
%        intTimeData{iColor}{1,mRoi}(iPlots,11)=NaN;
 
%   if (size(trackposTT{iPlots,iColor}{1,mRoi},1)<1)
%   intTimeData{iColor}{1,mRoi}(iPlots,11)=NaN;
   

  if (size(trackposTT{iPlots,iColor}{1,mRoi},1)==1 ...
          || size(trackposTT{iPlots,iColor}{1,mRoi},1)>1) 
        intTimeData{iColor}{1,mRoi}(iPlots,11)=size(trackposTT{iPlots,iColor}{1,mRoi},1);

  else
      intTimeData{iColor}{1,mRoi}(iPlots,11)=NaN;
  %%% smoothing data to avoid sudden jump
  end
 intTimeData{iColor}{1,mRoi}(iPlots,7)=smoothdata((intTimeData{iColor}{1,mRoi}(iPlots,2)),...
     'sgolay','Degree',3,'samplepoints',...
     (intTimeData{iColor}{1,mRoi}(iPlots,1)));
 
  intTimeData{iColor}{1,mRoi}(iPlots,8)=smoothdata((intTimeData{iColor}{1,mRoi}(iPlots,5)),...
     'sgolay','Degree',3,'samplepoints',...
     (intTimeData{iColor}{1,mRoi}(iPlots,1)));




    
end

%%% smoothing data and replaced within index values

 intTimeData{iColor}{1,mRoi}(:,9) = intTimeData{iColor}{1,mRoi}(:,2);
 intTimeData{iColor}{1,mRoi}(:,10) = intTimeData{iColor}{1,mRoi}(:,5);
   intTimeData{iColor}{1,mRoi}(indexGolaySmooth,9) = intTimeData{iColor}{1,mRoi}(indexGolaySmooth,6);
   intTimeData{iColor}{1,mRoi}(indexGolaySmooth,10) = intTimeData{iColor}{1,mRoi}(indexGolaySmooth,7);

end

    end

end



for kjColor=1:size(intTimeData,2)
  
    for kjRoi=1:size(intTimeData{1,kjColor},2)
    for kjFrame=1:max(intTimeData{1,kjColor}{1,kjRoi}(:,1))
        intROIPool{1,kjColor}{1,kjFrame}{kjRoi}=intTimeData{1,kjColor}{1,kjRoi}(kjFrame,:);
    end
   end
end



end
