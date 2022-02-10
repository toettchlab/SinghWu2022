ctrl= 'D:\10092019_nls-Lexy-EGFP\09\outputROIdata1\file_t00001.tif';
nf = 20;  %number of frame
for i = 1:nf  % change according to frame number
    ctrl_tmp = double(imread(ctrl,i));
%     ctrl_open = imopen (ctrl_tmp,strel('disk',4));
%     imshow(ctrl_open)%remove small background noise
     ctrl_tophat = imtophat (ctrl_tmp,strel('disk',40));
%      imshow(ctrl_tophat);
%     ctrl_eq = adapthisteq(ctrl_tophat);
%     bw = im2bw(ctrl_eq, graythresh(ctrl_eq));  % binarize the image
[bw,level]=fcmthresh(ctrl_tophat,0);
imshow(bw);
    %bw2 = imclearborder(bw,4); % clear border objects using lower connectivity
    bw_erode = imerode(bw,strel('disk',2));
    D = -bwdist(~bw_erode); % calculate the distance from center
    %imshow(D,[]);
    mask = imextendedmin(D,2);  %  extended-minima transform, similar to hmin
    %imshowpair(bw,mask,'blend'); 
    D2 = imimposemin(D,mask);   % to prevent over segmentation
    L = watershed(D2);
    L(~bw_erode) = 0;
    bw_label = label2rgb(L);
    %imshow(bw_label,'InitialMagnification','fit');
%     imwrite(bw_label,sprintf('frame_mask%d.jpg', i));
    ctrl_stats{i} = regionprops(L,ctrl_tmp,'centroid','MeanIntensity'); % the last region usually corresponding to background     
end


    
    
 

    
    


