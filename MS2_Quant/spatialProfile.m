function spatialProfile(statslist_spot,statslist_nuc)

indXYCorBcd=find(statslist_spot(:,1)>100 & statslist_spot(:,1)<770 &...
statslist_spot(:,2)>180 & statslist_spot(:,2)<320);

statsBcdFilt=statslist_spot(indXYCorBcd,:);
 statsHistFilt=statslist_nuc(indXYCorBcd,:);

% to see brewer map [brewermap('plot')] 
% map = colormap(cbrewer('qual', 'Dark2', N));
%  map = colormap(cbrewer('seq', 'Greys', N));
% map = colormap(cbrewer('seq', 'Blues', N));
%     cmap = brewermap((nPlots),'Spectral'); 
% cmap=colormap(parula(nPlots));
%'transparency',1
% cmap=othercolor('GnBu5',nPlots);
% s2=subplot(2,2,3);
    hold on
% 
%     boundedline(double(GS{1}(:,1)),double(GS{1}(:,3)),double(GS{1}(:,4)),...
%         'cmap',cmap(1,:));
%     boundedline(double(GS{100}(:,1)),double(GS{100}(:,3)),double(GS{100}(:,4))...
%         ,'cmap',cmap(100,:));
%     boundedline(double(GS{157}(:,1)),double(GS{157}(:,3)),double(GS{157}(:,4)),...
%         'cmap',cmap(157,:),'alpha');
%      xlim([50,974]);
%         ylim([50,20000]);
% statslist_spot
for iPlots = 1
  
    index01 = (statsBcdFilt(:,5) == iPlots);
    trackposTTBcd = statsBcdFilt(index01,:);
    GGBcd{iPlots}=trackposTTBcd; 
    GSBcd{iPlots}=sortrows(GGBcd{iPlots},1);  % sorts the row increasing x value
         plot(GSBcd{1,iPlots}(:,6),GSBcd{1,iPlots}(:,3),'-g','MarkerSize',8)

    x=GSBcd{1,iPlots}(:,6);
    y=GSBcd{1,iPlots}(:,3);
    xrg = linspace(0.15,0.4,6)';
[~,~,loc]=histcounts(x,xrg);
meany = accumarray(loc(:),y(:))./accumarray(loc(:),1);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
figure
plot(x,y)
hold on; 
plot(xmid,meany,'r')
hold on; 
% plot(xmid,meany,'r')
%%% histone

 trackposTTHist = statsHistFilt(index01,:);
    GGHist{iPlots}=trackposTTHist; 
    GSHist{iPlots}=sortrows(GGHist{iPlots},1); 
     
     
     hold on
        plot(GSHist{1,iPlots}(:,6),mean(GSHist{1,iPlots}(:,3),2),'-r','MarkerSize',8)
%,'Color',cmap(iPlots,:),...
%    'LineWidth',0.8);
% 
% x=GS{1,1}.XCor;
% y=GS{1,1}.YCor;
% z=GS{1,1}.Int;
% xi = unique(x) ; yi = unique(y) ;
% [X,Y] = meshgrid(xi,yi) ;
% Z = repmat(z,1,size(X,1)) ;
% figure
% surf(X,Y,Z)

% [X,Y,Z] = xyz2grd(x,y,z); 
% surf(X,Y,Z) 
% shading flat


% 


% 
% 
% 
% 
% 
        xlim([0,1]);
        ylim([0,2000]);

%              scatter(GG{i}(:,1),GG{i}(:,3),c(i),'LineWidth',1.5);
    %         % %     text(trackpos(:,1),trackpos(:,2),num2str(trackpos(:,4)),'Color','red','FontSize',10);
    %         % %     fname = sprintf('frame%d.jpg', i);
    %         % %     print(fname, '-djpeg')
       
    
    
end
title('Nuclear mean intensity', 'FontSize', 16)
xlabel('Pixel coordinate (X)', 'FontSize', 16)
ylabel('Intensity (AU)','FontSize', 16)
% set(s2,'colormap',cmap)
% hBar1=colorbar;
% ylabel(hBar1,'min','FontSize',12);
% % set(c1,cmap);
% caxis([0  7.1 ]);
hold off
%%
subplot(2,2,4)
mPlots=[1,11,29,44,80];

cmap1 = brewermap(length(mPlots),'Spectral'); 
hold on
for kPlots=mPlots
   plot(GS{:,kPlots}.XCor,GS{:,kPlots}.Int,'--*','Color',cmap(kPlots,:),...
   'LineWidth',2);
end
  xlim([50,974]);
        ylim([50,25000]);
        title('Nuclear mean intensity', 'FontSize', 16)
xlabel('Pixel number', 'FontSize', 16)
ylabel('Intensity (AU)','FontSize', 16)

fig1 = gcf;
fig1.PaperUnits = 'inches';
% fig2.PaperPosition = [0 0 6 5];
saveas(fig1,[dataFolder,'IntensityProfile_nlsGFPLexy.png']);
close (fig1);


end