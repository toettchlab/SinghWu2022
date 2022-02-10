%%
clear all

mat01=(load(['D:\17122019_nlsEGFPLexy\numPulses\01\statslist_combined_ctrl.mat']));
b=mat01.statslist_combined_ctrl;
% a = extractfield(mat01,'statslist_combined_ctrl');
%%

mymat02=sortrows(NewStats01,5);

%   myind=[];

for ij=1:max(mymat02(:,5))
    
     ind01=find(mymat02(:,5)==ij);
       K02{ij}=(mymat02(ind01,:));
       
%      myind(1:length(ind01),ij)=ind01; %stores all the indicies frame by frame
%             myind02(:,:,:,:,:,i)=(mymat02(myind(:,ij),:));
       

    

end
len = max( cellfun(@length, K02 ) );
Q2 = (cellfun( @(v) padarray(v,[len-length(v),0],nan,'post'), K02, 'uni',false ));
hold on

for i=1:size(Q2,2)
    Img(:,:,i)=Q2{1,i};
%     plot(Img(:,5,i),Img(:,3,i),'-o')
end

%%


I2=Img;



% H5=find(I2(:,1,:)>300 & I2(:,1,:)<390&  I2(:,2,:)>230 & I2(:,2,:)<270);

T4=size(H4,1);
T5=size(H5,1);
%%
% TG2(T2,6)=zeros;
% TG3(T3,6)=zeros;
for iTime=1:size(I2,3)
    H4{iTime,:}=find(I2(:,1,iTime)>520 & I2(:,1,iTime)<580 &I2(:,2,iTime)>200 & I2(:,2,iTime)<300) ;
% for h4=1:T4
%   TG4(h4,:,iTime)=I2(H4(h4),:,iTime);
% end
end

%%
blueLight=sortrows(TG2,5);
plot((timeperimage/60).*blueLight(:,5),(blueLight(:,3)),'Color',[0,0.7,0.9]);

title('Nuclear mean intensity over time', 'FontSize', 16)
xlabel('Time (min)', 'FontSize', 18)
ylabel('Intensity (AU)','FontSize', 18) 
% xlim([0,23]);
hold on

  for h3=1:T3
    
    TG3(h3,:)=I(H3(h3),:);
%      Stats02{h2}=TG2;
%      Stats03{h3}=TG3;
  end
    noLight=sortrows(TG3,5);
     plot((timeperimage/60).*noLight(:,5),noLight(:,3),'o-','LineWidth',0.8);

