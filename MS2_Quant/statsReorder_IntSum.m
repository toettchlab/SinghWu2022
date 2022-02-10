function statslist=statsReorder_IntSum(FullStats)
positionlist = [];
statslist = [];
% fintmp1=[]
nFiles=size(FullStats,2);
for i =1:nFiles
    
   tmpSliceA = struct2array([FullStats{i}]);
   tmpSliceA = tmpSliceA';
   tmpX = tmpSliceA(1:4:end);
   tmpY = tmpSliceA(2:4:end);
   tmpIn = tmpSliceA(3:4:end);
   tmpInStd=tmpSliceA(4:4:end);
   fintmp = [tmpX tmpY repmat(i,[numel(FullStats{1,i}),1])];
   fintmp1 = [tmpX tmpY tmpIn tmpInStd repmat(i,[numel(FullStats{i}),1])];
   positionlist = vertcat(positionlist, fintmp);
   statslist = vertcat(statslist, fintmp1);
end
% 
% %%%%%-------------Tracking segmented image--------%%%%%%%
% 
% trackresult = track(positionlist,maxDisp);
% 
% %%% Get intensity info together with track result
% [m,n] = size(statslist);
% 
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
% statslist_sorted = sortrows(statslist,5);
% % first column is x position second y, third intensity, fourth frame number, fifth cell id
% 
% statslist_combined_ctrl = horzcat(statslist_sorted(:,1:4), trackresult(:,3:4)); 
% 

end