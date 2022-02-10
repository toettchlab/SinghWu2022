function spotCountFinal=activeSpotCountTime(roiPlots,statslist_spot)
%%%Active nucleus in all the ROI vs time

% timePerF=0.33;

for mRoi=1:size(roiPlots,1)
indXYCorFil_spots{1,mRoi}=find(statslist_spot(:,1)>roiPlots(mRoi,1) & statslist_spot(:,1)<roiPlots(mRoi,2) &...
statslist_spot(:,2)>40 & statslist_spot(:,2)<488);

statslist_spotFilt{1,mRoi}=statslist_spot(indXYCorFil_spots{1,mRoi},:);
%  statslist_nucFilt{1,mRoi}=statslist_nuc(indXYCorFil_spots{1,mRoi},:);


% 
% for iColor=1:size(myStatData,2)
 for iPlots = min(statslist_spotFilt{1,mRoi}(:,6)):max(statslist_spotFilt{1,mRoi}(:,6))
% 
% %   
     index01 = ((statslist_spotFilt{1,mRoi}(:,6)) == iPlots);
      trackposTT{iPlots,mRoi} = statslist_spotFilt{1,mRoi}(index01,:);
      spotCount{iPlots,mRoi}=(size(trackposTT{iPlots,mRoi},1));
% %     trackposTT_nuc = myStatData{1,iColor}(index01,:);
% %     GG{iPlots}=trackposTT; 
% %     GS{iPlots}{1,mRoi}=sortrows(GG{iPlots},6);  % sorts the row increasing x value
%  intTimeData{iColor}{1,mRoi}(iPlots,1)=iPlots*timePerF;
% % 
% % 
%   intTimeData{iColor}{1,mRoi}(iPlots,2) =mean(trackposTT{iPlots,iColor}...
%       {1,mRoi}(:,4));
% intTimeData{iColor}{1,mRoi}(iPlots,3)   =std(trackposTT{iPlots,iColor}...
%     {1,mRoi}(:,4));
%  intTimeData{iColor}{1,mRoi}(iPlots,4)  =std(trackposTT{iPlots,iColor}...
%      {1,mRoi}(:,4))./(sqrt(length(trackposTT{iPlots,iColor}{1,mRoi}(:,4))));
%  
% %  intTimeData{iColor}{1,mRoi}(:,5)=smoothdata((intTimeData{iColor}{1,mRoi}(:,2)),...
% %      'sgolay','Degree',3,'samplepoints',...
% %      (intTimeData{iColor}{1,mRoi}(:,1)));
%  
% 
% 
% 
%  
% %  intTimeData{iColor}{1,mRoi}(iPlots,5)(indexGolaySmooth,:) = intTimeData{iColor}{1,mRoi}(indexGolaySmooth:);
%  
%  
% % %  intTimeData(4,iPlots)=std(GS{1,iPlots}(:,3))./(sqrt(length(GS{1,iPlots}(:,3))));
% % %  intTimeData(5,iPlots)=length(GS{1,iPlots}(:,4)).*mean(GS{1,iPlots}(:,4));
% % % intWeightSum(1,iPlots)=sum(length(GS{1,iPlots}(:,4)));
% % %  hold on
% % %      plot(iPlots,mean2(GS{1,iPlots}(:,3)),'-ro','MarkerSize',2,'Linewidth',0.2)
% % % 
% % %            plot(iPlots,(GS{1,iPlots}(:,3)),'-ko','MarkerSize',2,'Linewidth',0.2)
% % %     errorbar(iPlots*1./3,mean2(GS{1,iPlots}(:,3)),std2(GS{1,iPlots}(:,3)).*0.25,'-ko','MarkerSize',2,'Linewidth',0.2);
% % %     
% % 
% % % % k
% % % x=GS{1,1}.XCor;
% % % y=GS{1,1}.YCor;
% % % z=GS{1,1}.Int;
% % % xi = unique(x) ; yi = unique(y) ;
% % % [X,Y] = meshgrid(xi,yi) ;
% % % Z = repmat(z,1,size(X,1)) ;
% % % figure
% % % surf(X,Y,Z)
% % 
% % % [X,Y,Z] = xyz2grd(x,y,z); 
% % % surf(X,Y,Z) 
% % % shading flat
% % 
% % 
% % % 
% % 
% % 
% % % 
% % % 
% % % 
% % % 
% % % % 
% % %         xlim([50,974]);
% % %         ylim([50,25000]);
% % 
% % %              scatter(GG{i}(:,1),GG{i}(:,3),c(i),'LineWidth',1.5);
% %     %         % %     text(trackpos(:,1),trackpos(:,2),num2str(trackpos(:,4)),'Color','red','FontSize',10);
% %     %         % %     fname = sprintf('frame%d.jpg', i);
% %     %         % %     print(fname, '-djpeg')
% %        
% %     

empties = cellfun('isempty',spotCount);
% Now change all the empty cells in A from empty strings '' to double NaN
spotCount(empties) = {NaN};
spotCountFinal(iPlots,1)=iPlots;
spotCountFinal(:,1+mRoi)=cell2mat(spotCount(:,mRoi));

spotCountFinalPerc(iPlots,mRoi)=100.*(spotCountFinal(iPlots,mRoi))./sum(spotCountFinal(iPlots,:));
 end
% end



end

end
