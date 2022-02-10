function [fFTable]=flatFImgvsTime(FFdataFolder,nColor)

% 
      pathparts = strsplit(FFdataFolder,filesep);
      pathparts = strcat(pathparts{end-2},'_',pathparts{end-1});
%      fileString = (pathparts);
     fileString = [FFdataFolder, sprintf('%s_', pathparts)];
 
[myFFImg]           =loadStack(FFdataFolder); % load image data
[imgBkgSubs]=offsetSubs(myFFImg,nColor); %%% Background substraction (min value of image)

myFFAvgImg=mean(imgBkgSubs,3);
myFFStdImg=std(imgBkgSubs,0,3);
[mPy,nPx,~]=size(myFFAvgImg);
% subplot(2,1,1)
% errorbar(1:nPx,myFFAvgImg(mPy/2,:),myFFStdImg(mPy/2,:));
% ylabel({'Mean intensity'; '+- std (AU)'},'FontWeight', 'bold','FontSize',16)
% xlabel('Pixel coordinate (pixel)','FontWeight', 'bold','FontSize',16)
%  ylim([100,(max(myFFAvgImg(:))+max(myFFStdImg(:)))]);
%  xlim([12, (nPx-12)]);
%   text(936.,-6385,FFdataFolder,'HorizontalAlignment','center','FontSize',5);
  %%
  subplot(2,3,[1,3])
%   imshow(myFFAvgImg,[])
  imagesc(myFFAvgImg);
colormap gray
title('Flat field image','FontWeight', 'bold','FontSize',16)
text(936.,-6385,FFdataFolder,'HorizontalAlignment','center','FontSize',5);
% ylabel({'Pixel coordinate along y'},'FontWeight', 'bold','FontSize',16);
% xlabel('Pixel coordinate along x','FontWeight', 'bold','FontSize',16);

  subplot(2,3,4)
 errorbar(1:nPx,myFFAvgImg(mPy/2,:),myFFStdImg(mPy/2,:));
  ylim([100,(max(myFFAvgImg(:))+max(myFFStdImg(:)))]);
 xlim([12, (nPx-12)]);
 ylabel({'Pixel intensity'; 'mean +- std'},'FontSize',12);
xlabel('Pixel coordinate- x','FontSize',12);
   subplot(2,3,5)
    errorbar(1:mPy,myFFAvgImg(:,nPx/2),myFFStdImg(:,nPx/2));
      ylim([100,(max(myFFAvgImg(:))+max(myFFStdImg(:)))]);
 xlim([12, (mPy-12)]);
%  ylabel({'Pixel intensity mean +- std'},'FontWeight', 'bold','FontSize',16);
xlabel('Pixel coordinate- y','FontSize',12);

subplot(2,3,6)
mySNRImg=myFFAvgImg./myFFStdImg;
% histogram(mySNRImg(:),40,'Normalization','probability','DisplayStyle','stairs');

mySNR=mySNRImg(mySNRImg(:)> 0.5); % removing zero values
histfit(mySNR(:),50,'normal');
myParam=fitdist(mySNR(:),'Normal');
ylabel({'Frequency'},'FontSize',12);
xlabel('Signal to noise ratio (SNR)','FontSize',12);
ax.PlotBoxAspectRatio = [1 0.75 0.75];


saveas(gcf,sprintf('%s_flatFnSNR.emf',fileString));
% varName = {'FolderName';'mu';'sigma'};
FolderName={sprintf('%s',pathparts)};
mu01=myParam.mu;
sigma01=myParam.sigma;


if exist('D:\FlatF\fFTable.mat','file') == 2
  load('D:\FlatF\fFTable.mat') ;
else 
   fFTable=[];
end
%  fFTable=struct2cell(fFTable);

Tnew = [FolderName,mu01,sigma01];

fFTable=[fFTable;Tnew];
%     Tnew = table(rand,rand,'VariableNames',{'Age','Weight'},'RowNames',{['P',num2str(i)]}) ;
%     T = [T ; Tnew] 
% save('D:\FlatF\fFTable.mat');
save('D:\FlatF\fFTable.mat','fFTable')  
% type 'fFTable.dat'
close all
end