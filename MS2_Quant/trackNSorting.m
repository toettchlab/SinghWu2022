function sortedResults=trackNSorting(fullStats,numFrames)

%This function takes centroid X, Y corordinates, mean intensity and stdDev ...
% for segmented nucleus; and number of frames to follow in tracking
% output --> single matrix 
% sortedResults(:,1)= X cordinate
% sortedResults(:,2)= Y cordinate
% sortedResults(:,3)= mean Intensity value
% sortedResults(:,4)= stdDev nucleus 
% sortedResults(:,5)= Frame number
% sortedResults(:,6)= tracked particle ID
% sortedResults(:,7)= mean area 


positionlist = [];
statslist = [];
for i =1:size(fullStats,2)
    
   tmpSliceA = struct2array([fullStats{i}]);
   tmpSliceA = tmpSliceA';
   tmpX = tmpSliceA(1:4:end);
   tmpY = tmpSliceA(2:4:end);
   tmpIn = tmpSliceA(3:4:end);
   tmpInStd=tmpSliceA(4:4:end);
   tmpArea=tmpSliceA(5:4:end);
   fintmp = [tmpX tmpY repmat(i,[numel(fullStats{i}),1])];
   fintmp1 = [tmpX tmpY tmpIn tmpInStd repmat(i,[numel(fullStats{i}),1])];
   positionlist = vertcat(positionlist, fintmp);
   statslist = vertcat(statslist, fintmp1);
end


trackresult = track(positionlist,numFrames);

%%% Get intensity info together with track result
[m,n] = size(statslist);

statslist = horzcat(statslist, zeros(m,1));
ii = 1;
j=1;
while ii < m+1
    while j < m+1
       if  (statslist(j,1)== trackresult(ii,1) && statslist(j,2)== trackresult(ii,2)&& statslist(j,5)== trackresult(ii,3))
            statslist(j,5) = ii;
            break
        else
            j = j+1;
        end
    end
    j = 1;
    ii = ii + 1;
end 



statslist_sorted = sortrows(statslist,5);
% first column is x position second y, third intensity, fourth frame number, fifth cell particle id

statslist_combined_ctrl = horzcat(statslist_sorted(:,1:4), trackresult(:,3:4)); 
sortedResults=statslist_combined_ctrl;

% save([dataFolder,sprintf('%s_statslist_combined_ctrl.mat',fileString)],'statslist_combined_ctrl','-v7.3','-nocompression');


end