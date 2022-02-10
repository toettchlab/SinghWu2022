function plot_heatmap(folder,embryo,BWoutline,t,stats)
[row,col] = find(BWoutline); % find out all the coordinates of nonzero elements
xmin = min(col);
xmax = max(col);
p = 100;
delta = (xmax-xmin)/p;
edges_L = round(xmin:delta:xmax); %divide the embryo into p portions
ylen = [];
y = [];
for i = 1:(p+1)
    inx = find(col==edges_L(i)); % find out index
    y_tmp = row(inx);
    ylen(i) =max(y_tmp)-min(y_tmp);
end

for i = 1:p
    y(i) = (ylen(i)+ylen(i+1))/(2*max(ylen));
   
end


N_total = [];    
for i = 1:t
    tmp = stats{i};
    centroids = cat(1,tmp.Centroid);
    if isempty(centroids) == 0
        [N,edges_L] = histcounts(centroids(:,1),edges_L);
        N_norm = N./y;    % normalized by width, should also be normalized by the No. of cells in each cycle
        N_total = vertcat(N_total, N_norm);
    else
        N_total = vertcat(N_total, zeros(1,p));
    end
end
total_d = sprintf('/Users/pingwu/Desktop/Toettcher-lab/opto-bicoid/MS2/%s/%s_summary/matrix_%s.csv',folder,folder,embryo);
writematrix(N_total,total_d);

EL = 1:100;
%y_t = 0:0.5:(t/2-0.5);
%h = heatmap(EL,y_t,N_total,'XLabel','Egg length(%)','YLabel','Time(min)','GridVisible','off');
y_t = 0:1:(t-1);
h = heatmap(EL,y_t,N_total,'XLabel','Egg length(%)','YLabel','Frame No.','GridVisible','off');

idx= rem(EL,10) == 0; % show every 10 th x label
h.XDisplayLabels(~idx) = {''};
idy = rem(y_t,20) == 0;% show every 20th y label
h.YDisplayLabels(~idy) = {''};
set(struct(h).NodeChildren(3), 'XTickLabelRotation', 0); 
title(sprintf('kni MS2 iRFP-uBcd E1/+ (%s)',embryo));

saveas(gcf,sprintf('%s_heatmap.png',embryo));
close;
