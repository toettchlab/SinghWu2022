function [myArrayMean,myArrayMeanTime,myArrayVar]= singleArray2MultiPageArray_2Color(dataArray)
% This function arranges data accrding to time column (5th)...
% to multipage array in time (with same number of elements) 

mymat02=sortrows(dataArray,6);
 

for ij=min(mymat02(:,6)):max(mymat02(:,6))
    
     ind01=find(mymat02(:,6)==ij);
       K02{ij}=(mymat02(ind01,:));
       
%      myind(1:length(ind01),ij)=ind01; %stores all the indicies frame by frame
%             myind02(:,:,:,:,:,i)=(mymat02(myind(:,ij),:));
       

    

end
%  len = max( cellfun(@length, K02{:,2}) );
% Q2 = (cellfun( @(v) padarray(v,[len-length(v),0],nan,'post'), K02, 'uni',false ));
% [m,~]=cellfun(@size, (K02) );
len=max(cellfun(@(c) size(c,1),K02));
Q2 = (cellfun( @(v) padarray(v,[len-size(v,1),0],nan,'post'), K02, 'uni',false ));
 
% hold on

for i=1:size(Q2,2)
    
%     myArray(:,:,i)=Q2{1,i};
    if isempty(Q2{1,i})
      myArrayMean(i,:)=NaN;
      myArrayMeanTime(i,:)=i;
      myArrayVar(i,:)=NaN;
    else
    myArrayMean(i,:)=nanmean(Q2{1,i}(:,4),'all');
    myArrayMeanTime(i,:)= i;%nanmean(Q2{1,i}(:,6),'all');
     myArrayVar(i,:)=std(Q2{1,i}(:,4),'omitnan');  
    end
%      plot(myArray(:,5,i),myArray(:,3,i),'o','MarkerFaceColor','red',...
%     'MarkerSize',3);

end


end