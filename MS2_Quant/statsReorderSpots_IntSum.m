function [statslist]=statsReorderSpots_IntSum(FullStats)
positionlist = [];
statslist = [];
nFiles=size(FullStats,2);
% fintmp1=[]
for i =1:nFiles
    
   tmpSliceA = struct2array([FullStats{i}]);
   tmpSliceA = tmpSliceA';
   tmpX = tmpSliceA(1:6:end);
   tmpY = tmpSliceA(2:6:end);
   tmpIn = tmpSliceA(3:6:end);
   tmpOffsetIn = tmpSliceA(4:6:end);
   tmpInStd=tmpSliceA(5:6:end);
   tmpInSum=tmpSliceA(6:6:end);
   fintmp = [tmpX tmpY repmat(i,[numel(FullStats{i}),1])];
   fintmp1 = [tmpX tmpY tmpIn tmpOffsetIn tmpInStd tmpInSum repmat(i,[numel(FullStats{i}),1])];
   positionlist = vertcat(positionlist, fintmp);
   statslist = vertcat(statslist, fintmp1);
end
% 
% %%%%%-------------Tracking segmented image--------%%%%%%%
% % 
% % memory_b=5;
% trackresult = track(positionlist,maxDisp,param);
% % 
% % %%% Get intensity info together with track result
% [m,n] = size(statslist);
% % 
% statslist = horzcat(statslist, zeros(m,1));
% ii = 1;
% j=1;
% while ii < m+1
%     while j < m+1
%        if  (statslist(j,1)== trackresult(ii,1) && statslist(j,2)== trackresult(ii,2)&& statslist(j,5)== trackresult(ii,3))
%             statslist(j,5) = ii;
%             break
%         else
%             j = j+1;
%         end
%     end
%     j = 1;
%     ii = ii + 1;
% end 
% 
% 
% 
% statslist_sorted = sortrows(statslist,6);
% % first column is x position second y, third intensity, fourth frame number, fifth cell id
% 
% statsList_TrackCombined = horzcat(statslist_sorted(:,1:5), trackresult(:,3:4)); 
% 

end