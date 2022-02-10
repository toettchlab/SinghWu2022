brolist = readtable('/Users/pingwu/Desktop/Toettcher-lab/opto-bicoid/MS2_new/re_analysis/embryo list.xlsx','PreserveVariableNames',1);
codelist = table2array(brolist(:,{'Embryo code'}));


for e = 7:12
    embryo = string(codelist(e));
    embryo_split = split(embryo,{'-'});
    folder = sprintf('%s-%s-%s',embryo_split(1),embryo_split(2),embryo_split(3));
    NC_frame = table2array(brolist(e,2:6)); % frame of the beginning of each NC.
    t = NC_frame(5); % total time points
    cd (sprintf('/Users/pingwu/Desktop/Toettcher-lab/opto-bicoid/MS2_new/re_analysis/%s',folder));
    bro = sprintf('%s.tif',embryo);
    burst_mask=sprintf('%s_M.tif',embryo);
    
    total_count = [];
    accu_int = [];
    for i = 1:t
    
         M = imread(burst_mask,i);
         I = imread(bro,i);
         M_BW = im2bw(M);
         M_BW = ~ M_BW; % invert mask
         stats = regionprops(M_BW,I,'MeanIntensity','Area');
         tmp_int = cat(1,stats.MeanIntensity);
         tmp_area = cat(1,stats.Area);
         tmp_accu = transpose(tmp_int)*tmp_area;
         total_count = [total_count length(tmp_int)];
         if isempty(tmp_accu)== 1
            accu_int = [accu_int 0];
         else
            accu_int = [accu_int tmp_accu];
         end
         
     end
   
    total_d = sprintf('/Users/pingwu/Desktop/Toettcher-lab/opto-bicoid/MS2_new/re_analysis/%s.csv',embryo);
    writematrix([transpose(total_count) transpose(accu_int)],total_d);
end