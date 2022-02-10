function timePlots(roiPlots,statslist_spot,statslist_nuc,yRange01,yRange02,...
    timePerF,indexGolaySmooth,lightOn1,lightOff1,uL1,myString,dataFolder,...
    lightOn2,lightOff2,uL2,xAxisOffset,BcdGreen,lightBcdGreen,mCherry,...
    lightmCh,xAxisStart,xAxisEnd,spotDark,spotLight)



for mRoi=1:size(roiPlots,1)
indXYCorFil_spots{1,mRoi}=find(statslist_spot(:,1)>roiPlots(mRoi,1) & statslist_spot(:,1)<roiPlots(mRoi,2) &...
statslist_spot(:,2)>yRange01 & statslist_spot(:,2)<yRange02);

indXYCorFil_nuc{1,mRoi}=find(statslist_nuc(:,1)>roiPlots(mRoi,1) & statslist_nuc(:,1)<roiPlots(mRoi,2) &...
statslist_nuc(:,2)>yRange01 & statslist_nuc(:,2)<yRange02);

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
 intTimeData{iColor}{1,mRoi}(iPlots,1)=iPlots*timePerF;
% % 
% % 
  intTimeData{iColor}{1,mRoi}(iPlots,2) =mean(trackposTT{iPlots,iColor}...
      {1,mRoi}(:,3));
intTimeData{iColor}{1,mRoi}(iPlots,3)   =std(trackposTT{iPlots,iColor}...
    {1,mRoi}(:,3));
 intTimeData{iColor}{1,mRoi}(iPlots,4)  =std(trackposTT{iPlots,iColor}...
     {1,mRoi}(:,3))./(sqrt(length(trackposTT{iPlots,iColor}{1,mRoi}(:,3))));
 
 intTimeData{iColor}{1,mRoi}(iPlots,5)=sum(mean(trackposTT{iPlots,iColor}...
      {1,mRoi}(:,6)));
 
  %%% smoothing data to avoid sudden jump
  
 intTimeData{iColor}{1,mRoi}(iPlots,6)=smoothdata((intTimeData{iColor}{1,mRoi}(iPlots,2)),...
     'sgolay','Degree',3,'samplepoints',...
     (intTimeData{iColor}{1,mRoi}(iPlots,1)));
 
  intTimeData{iColor}{1,mRoi}(iPlots,7)=smoothdata((intTimeData{iColor}{1,mRoi}(iPlots,5)),...
     'sgolay','Degree',3,'samplepoints',...
     (intTimeData{iColor}{1,mRoi}(iPlots,1)));
 



    
end

%%% smoothing data and replaced within index values

 intTimeData{iColor}{1,mRoi}(:,8) = intTimeData{iColor}{1,mRoi}(:,2);
 intTimeData{iColor}{1,mRoi}(:,9) = intTimeData{iColor}{1,mRoi}(:,5);
   intTimeData{iColor}{1,mRoi}(indexGolaySmooth,8) = intTimeData{iColor}{1,mRoi}(indexGolaySmooth,6);
   intTimeData{iColor}{1,mRoi}(indexGolaySmooth,9) = intTimeData{iColor}{1,mRoi}(indexGolaySmooth,7);

end



end

% %%
% plot(intTimeData{1}{1,3}(:,4))



% intTimeData data structure
% intTimeData(:,1)   time
% intTimeData(:,2)   mean intensity
% intTimeData(:,3)   std dev
% intTimeData(:,4)   sem
% intTimeData(:,5)   smooth of mean int
% intTimeData(:,6)   smooth corrected and replaced in certain range given
% by filter range

% for mRoi=1:size(roiPlots,1)
% for iColor=1:size(myStatData,2)
%  intTimeData{iColor}{1,mRoi}(:,7)=...
%     intTimeData{iColor}{1,mRoi}(:,2);
%  
% intTimeData{iColor}{1,mRoi}(indexGolaySmooth,6)=...
%     intTimeData{iColor}{1,mRoi}(indexGolaySmooth,5);
% 
% 
% end
% end


figure(1)
subplot(2,1,1) 
hold on
   ha1 = area([(lightOn1) (lightOff1)], [uL1 uL1]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha1.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha1.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha1.EdgeColor = 'none';
 
    ha2 = area([(lightOn2) (lightOff2)], [uL1 uL1]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha2.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha2.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha2.EdgeColor = 'none';
 
 
errorbar((intTimeData{1}{1,1}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,1}(:,8)),...
    intTimeData{1}{1,1}(:,4),'-o','MarkerSize',3,'Color',BcdGreen);


errorbar((intTimeData{1}{1,2}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,2}(:,8)),...
    intTimeData{1}{1,2}(:,4),'-o','MarkerSize',3,'Color',lightBcdGreen );

errorbar((intTimeData{1}{1,3}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,3}(:,8)),...
    intTimeData{1}{1,3}(:,4),'-ok','MarkerSize',3,'Color',BcdGreen);





 xline3=xline(lightOff1,'--',{'Off'});
xline3.LineWidth = 2;
xline3.Color='b'
 xline3.Alpha = 0.8;
 
 xline4=xline(0,'',{'C14'});
xline4.LineWidth = 1;
xline4.Color='k'
 xline4.Alpha = 0.3;
 
 ylim([4000,uL1])
xlim([xAxisStart,xAxisEnd])
 xlabel('Time [min]');
 ylabel('Spot intensity [au]')
%   xEx=[7.56,21.84,43.8,90];
%  yEx=[1200,1260,1370,1550];
% xx=intTimeData{1}{1,3}(:,1);
%  yy = spline(xEx,yEx,xx);
% plot(xx,yy,'--','Color', '#969696','LineWidth',1)
 hold off
 
 %%%%-----mCherry Signal----%%%%%%%
 
subplot(2,1,2) 
hold on
    ha1 = area([(lightOn1) (lightOff1)], [uL1 uL1]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha1.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha1.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha1.EdgeColor = 'none';
 
 
     ha2 = area([(lightOn2) (lightOff2)], [uL1 uL1]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha2.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha2.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha2.EdgeColor = 'none';

errorbar((intTimeData{2}{1,1}(:,1))-xAxisOffset,...
    (intTimeData{2}{1,1}(:,8)),...
    intTimeData{2}{1,1}(:,4),'-o','MarkerSize',3,'Color',mCherry);


errorbar((intTimeData{2}{1,2}(:,1))-xAxisOffset,...
    (intTimeData{2}{1,2}(:,8)),...
    intTimeData{2}{1,2}(:,4),'-o','MarkerSize',3,'Color',lightmCh );

errorbar((intTimeData{2}{1,3}(:,1))-xAxisOffset,...
    (intTimeData{2}{1,3}(:,8)),...
    intTimeData{2}{1,3}(:,4),'-ok','MarkerSize',3,'Color',mCherry);



errorbar((intTimeData{1}{1,1}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,1}(:,8)),...
    intTimeData{1}{1,1}(:,4),'-o','MarkerSize',3,'Color',BcdGreen);


errorbar((intTimeData{1}{1,2}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,2}(:,8)),...
    intTimeData{1}{1,2}(:,4),'-o','MarkerSize',3,'Color',lightBcdGreen );

errorbar((intTimeData{1}{1,3}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,3}(:,8)),...
    intTimeData{1}{1,3}(:,4),'-ok','MarkerSize',3,'Color',BcdGreen);

ylim([1000,uL1])
xlim([xAxisStart,xAxisEnd])

xline3=xline(lightOff1,'--',{'Off'});
xline3.LineWidth = 2;
xline3.Color='b'
 xline3.Alpha = 0.8;
 
 xline4=xline(0,'',{'C14'});
xline4.LineWidth = 4;
xline4.Color=[0.5,0.5,0.5];
 xline4.Alpha = 0.1;
 
  xline5=xline(0,'--');
  xline5.LineWidth = 0.5;
  xline5.Color='k'
 xlabel('Time [min]');
 ylabel('Intensity [au]')
 
 


file_name = sprintf('%s_intTimeData.mat',myString);
save([dataFolder ,file_name],'intTimeData','-v7.3','-nocompression');

saveas(gcf,[dataFolder,sprintf('%s_SpotintTimeData.emf',myString)]); 
saveas(gcf,[dataFolder,sprintf('%s_SpotintTimeData.jpg',myString)]); 
saveas(gcf,[dataFolder,sprintf('%s_SpotintTimeData.svg',myString)]); 

% intTimeData(2:5,1:memMark)=NaN;
% intWeightSum(1,1:memMark)=NaN;
%  errorbar((intTimeData(1,:)-memMark)/3,intTimeData(2,:),intTimeData(3,:))
% subplot(1,2,1)
%   errorbar((intTimeData{1,1}(:,1)),intTimeData{1,1}(:,2),intTimeData{1,1}(:,4))

% plot((intTimeData{1,1}(:,1)),smoothn(intTimeData{1,1}(:,2)),'-o','MarkerSize',5,'Color', BcdGreen)
%  plot((intTimeData{1,1}(:,1)),smoothn(intTimeData{1,1}(:,2)),'-r')
% % plot((intTimeData{1,1}(:,1)),(intTimeData{1,1}(:,2)),'-c')
% % plot((intTimeData{1,1}(:,1)),medfilt1(intTimeData{1,1}(:,2),3),'-g')



figure(2)
subplot(2,1,1) 
hold on
   ha1 = area([(lightOn1) (lightOff1)], [uL2 uL2]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha1.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha1.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha1.EdgeColor = 'none';
 
    ha2 = area([(lightOn2) (lightOff2)], [uL2 uL2]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha2.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha2.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha2.EdgeColor = 'none';
 
 
errorbar((intTimeData{1}{1,1}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,1}(:,9)),...
    intTimeData{1}{1,1}(:,3),'-o','MarkerSize',3,'Color',BcdGreen);


errorbar((intTimeData{1}{1,2}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,2}(:,9)),...
    intTimeData{1}{1,2}(:,3),'-o','MarkerSize',3,'Color',lightBcdGreen );

errorbar((intTimeData{1}{1,3}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,3}(:,9)),...
    intTimeData{1}{1,3}(:,3),'-ok','MarkerSize',3,'Color',BcdGreen);







xline3=xline(lightOff1,'--',{'Off'});
xline3.LineWidth = 2;
xline3.Color='b'
 xline3.Alpha = 0.8;
 
 xline4=xline(0,'',{'C14'});
xline4.LineWidth = 4;
xline4.Color=[0.5,0.5,0.5];
 xline4.Alpha = 0.1;
 
  xline5=xline(0,'--');
  xline5.LineWidth = 0.5;
  xline5.Color='k'
 
%  ylim([4800,uL1])
xlim([xAxisStart,xAxisEnd])
 xlabel('Time [min]');
 ylabel('Spot intensity [au]')
%   xEx=[7.56,21.84,43.8,90];
%  yEx=[1200,1260,1370,1550];
% xx=intTimeData{1}{1,3}(:,1);
%  yy = spline(xEx,yEx,xx);
% plot(xx,yy,'--','Color', '#969696','LineWidth',1)
 hold off
 
 %%%%-----mCherry Signal----%%%%%%%
 
subplot(2,1,2) 
hold on
    ha1 = area([(lightOn1) (lightOff1)], [uL2 uL2]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha1.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha1.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha1.EdgeColor = 'none';
 
 
     ha2 = area([(lightOn2) (lightOff2)], [uL2 uL2]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha2.FaceAlpha = 0.1;
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha2.FaceColor = 'blue';
% % % ha2.FaceColor = 'blue';
% % % % ha3.FaceColor = 'blue';
 ha2.EdgeColor = 'none';

% errorbar((intTimeData{2}{1,1}(:,1))-xAxisOffset,...
%     (intTimeData{2}{1,1}(:,9)),...
%     intTimeData{2}{1,1}(:,3),'-o','MarkerSize',3,'Color',mCherry);
% 
% 
% errorbar((intTimeData{2}{1,2}(:,1))-xAxisOffset,...
%     (intTimeData{2}{1,2}(:,9)),...
%     intTimeData{2}{1,2}(:,3),'-o','MarkerSize',3,'Color',lightmCh );
% 
% errorbar((intTimeData{2}{1,3}(:,1))-xAxisOffset,...
%     (intTimeData{2}{1,3}(:,9)),...
%     intTimeData{2}{1,3}(:,3),'-ok','MarkerSize',3,'Color',mCherry);
% 
% 
% 
% errorbar((intTimeData{1}{1,1}(:,1))-xAxisOffset,...
%     (intTimeData{1}{1,1}(:,9)),...
%     intTimeData{1}{1,1}(:,3),'-o','MarkerSize',3,'Color',BcdGreen);


errorbar((intTimeData{1}{1,2}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,2}(:,9)),...
    intTimeData{1}{1,2}(:,3),'-o','MarkerSize',3,'Color',lightBcdGreen );

errorbar((intTimeData{1}{1,3}(:,1))-xAxisOffset,...
    (intTimeData{1}{1,3}(:,9)),...
    intTimeData{1}{1,3}(:,3),'-ok','MarkerSize',3,'Color',BcdGreen);

% ylim([1000,uL1])
xlim([xAxisStart,xAxisEnd])
 xlabel('Time [min]');
 ylabel('Intensity Sum [au]')
 
 xline(lightOn1,'-',{'Acceptable','Limit'});


% file_name = sprintf('%s_intTimeData.mat',myString);
% save([dataFolder ,file_name],'intTimeData','-v7.3','-nocompression');

saveas(gcf,[dataFolder,sprintf('%s_SpotSumintTimeData.emf',myString)]); 
saveas(gcf,[dataFolder,sprintf('%s_SpotSumintTimeData.jpg',myString)]); 
saveas(gcf,[dataFolder,sprintf('%s_SpotSumintTimeData.svg',myString)]); 

% intTimeData(2:5,1:memMark)=NaN;
% intWeightSum(1,1:memMark)=NaN;
%  errorbar((intTimeData(1,:)-memMark)/3,intTimeData(2,:),intTimeData(3,:))
% subplot(1,2,1)
%   errorbar((intTimeData{1,1}(:,1)),intTimeData{1,1}(:,2),intTimeData{1,1}(:,4))

% plot((intTimeData{1,1}(:,1)),smoothn(intTimeData{1,1}(:,2)),'-o','MarkerSize',5,'Color', BcdGreen)
%  plot((intTimeData{1,1}(:,1)),smoothn(intTimeData{1,1}(:,2)),'-r')
% % plot((intTimeData{1,1}(:,1)),(intTimeData{1,1}(:,2)),'-c')
% % plot((intTimeData{1,1}(:,1)),medfilt1(intTimeData{1,1}(:,2),3),'-g')



figure(3)
spotCountFinal  =activeSpotCountTime_IntSum(roiPlots,statslist_spot);
nucCountFinal   =activeSpotCountTime_IntSum(roiPlots,statslist_nuc);

%plot(nucCountFinal(:,1)*.33-xAxisOffset,nucCountFinal(:,2))

mCherryWindowFilter=round([1:2]./0.33)'; % time windwo mCherry signal need to be kept
newmCh=nucCountFinal(:,1);
newmChSelc=nucCountFinal(mCherryWindowFilter,:);


 
 
% mCherryWindowFilter=round([25:55]./0.33+xAxisOffset)'; % time windwo mCherry signal need to be kept
% newmCh=nucCountFinal(:,1);
% newmChSelc=nucCountFinal(mCherryWindowFilter,:);


 hold on
    ha1 = area([(lightOn1) (lightOff1)], [200 200]);
% %  ha2 = area([69/3 84/3], [uL uL]);
% % % ha3 = area([108/3 125/3], [uL uL]);
% % % 
 ha1.FaceAlpha = 0.1;
  ha1.EdgeColor = 'none';
% % % ha2.FaceAlpha = 0.08;
% % % % ha3.FaceAlpha = 0.08;
 ha1.FaceColor = 'blue';
 
  plot(spotCountFinal(:,1)*timePerF-xAxisOffset,spotCountFinal(:,2),'-o','Color',spotDark,'MarkerSize',3);
hold on
%  plot(spotCountFinal(:,1)*timePerF-xAxisOffset,spotCountFinal(:,4),'-o','Color',spotDark,'MarkerSize',3);
plot(spotCountFinal(:,1)*timePerF-xAxisOffset,spotCountFinal(:,3),'-o','LineWidth',0.5,'Color',spotLight,'MarkerSize',3);
plot(spotCountFinal(:,1)*timePerF-xAxisOffset,smoothn(spotCountFinal(:,3)),'--k','LineWidth',1);

xlabel('Time min')
ylabel('MS2 active spots')
xlim([xAxisStart,xAxisEnd]);
xline3=xline(lightOff1,'--',{'Off'});
xline3.LineWidth = 2;
xline3.Color='b'
 xline3.Alpha = 0.8;
 
 xline4=xline(0,'',{'C14'});
xline4.LineWidth = 4;
xline4.Color=[0.5,0.5,0.5];
 xline4.Alpha = 0.1;
 
  xline5=xline(0,'--');
  xline5.LineWidth = 0.5;
  xline5.Color='k'
ylim([0,200])
%   subplot(2,1,2)
% %  plot(nucCountFinal(:,1)*timePerF-xAxisOffset,nucCountFinal(:,2))
% % plot(spotCountFinal(:,1)*timePerF-xAxisOffset,spotCountFinal(:,2),'-o','Color',spotDark,'MarkerSize',3);
% hold on
% % plot(spotCountFinal(:,1)*timePerF-xAxisOffset,spotCountFinal(:,4),'-o','Color',spotDark,'MarkerSize',3);
% plot(spotCountFinal(:,1)*timePerF-xAxisOffset,spotCountFinal(:,3),'-o','Color',spotLight,'MarkerSize',3);
% plot(spotCountFinal(:,1)*timePerF-xAxisOffset,smoothn(spotCountFinal(:,3)),'--k');
% 
% 
% % plot(nucCountFinal(:,1)*timePerF,nucCountFinal(:,2),'-k');
%    plot(newmChSelc(:,1)*timePerF-xAxisOffset,newmChSelc(:,2),'o','Color',mCherry,'MarkerSize',3);
% % 
% % % plot(spotCountFinal(:,1)*0.33,nucCountFinal(:,3),'-o','Color',lightmCh,'MarkerSize',3);
% % plot(newmChSelc(:,1)*timePerF-xAxisOffset,newmChSelc(:,4),'o','Color',mCherry,'MarkerSize',3);
% 
% 
% 
%    ha1 = area([(lightOn1) (lightOff1)], [200 200]);
% % %  ha2 = area([69/3 84/3], [uL uL]);
% % % % ha3 = area([108/3 125/3], [uL uL]);
% % % % 
%  ha1.FaceAlpha = 0.1;
%   ha1.EdgeColor = 'none';
% % % % ha2.FaceAlpha = 0.08;
% % % % % ha3.FaceAlpha = 0.08;
%  ha1.FaceColor = 'blue';
%  
% xlabel('Time min')
% ylabel('Spots & total number of nucleus')
% xlim([xAxisStart,xAxisEnd])

spotCountFinal(:,5)=spotCountFinal(:,1)*timePerF-xAxisOffset;
% first column is time frame other all ROIs 5th coverted in minute and
% offset substracted
nucCountFinal(:,5)=nucCountFinal(:,1)*timePerF-xAxisOffset;
myTotalSpotNuc(:,1:5)=spotCountFinal;
myTotalSpotNuc(:,6:10)=spotCountFinal;
file_name = sprintf('%s_SpotNucCount.mat',myString);
save([dataFolder ,file_name],'myTotalSpotNuc','-v7.3','-nocompression');

saveas(gcf,[dataFolder,sprintf('%s_SpotCountvsNucTimeData.emf',myString)]); 
saveas(gcf,[dataFolder,sprintf('%s_SpotCountvsNucTimeData.jpg',myString)]); 
saveas(gcf,[dataFolder,sprintf('%s_SpotCountvsNucTimeData.svg',myString)]); 
% 


spotParaList(:,1)=(intTimeData{1}{1,2}(:,1))-xAxisOffset;
spotParaList(:,2)=intTimeData{1,1}{1,2}(:,2); %avg intensity
spotParaList(:,3)=intTimeData{1,1}{1,2}(:,3); %avg std intensity

spotParaList(:,4)=(intTimeData{1,1}{1,2}(:,5)); %sum intensity
spotParaList(:,5)=(intTimeData{1,1}{1,2}(:,6)); %sum std intensity

spotParaList(:,6)=spotCountFinal(:,3); %total active nucleus

    
% first column is time frame other all ROIs 5th coverted in minute and
% offset substracted

file_name = sprintf('%s_SpotParaList.mat',myString);
save([dataFolder ,file_name],'spotParaList','-v7.3','-nocompression');


end
