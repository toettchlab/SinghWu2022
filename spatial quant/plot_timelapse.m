function plot_timelapse(folder,embryo,stats,NC_frame,L_frame,t)

total = [];
for i = 1:t
    tmp = stats{i};
    centroids = cat(1,tmp.Centroid);
    intensity = cat(1,tmp.MeanIntensity);
    total = [total length(tmp)];
    
   
end
total_d = sprintf('/Users/pingwu/Desktop/Toettcher-lab/opto-bicoid/MS2/%s/%s_summary/total_counts_%s.csv',folder,folder,embryo);
writematrix(transpose(total),total_d);
    
embryo_split = split(embryo,{'-'});
light = embryo_split(3);
hAX=axes;                 % first axes, save handle
t_x = linspace(0,t,t);% interval 30s
plot(t_x,total,'k.');
if light == '11' | light == '10'
    rectangle('Position',[0 0 L_frame 1500],'FaceColor',[0.3010 0.7450 0.9330,0.3],'EdgeColor','none');
else
    rectangle('Position',[L_frame 0 (t-L_frame) 1500],'FaceColor',[0.3010 0.7450 0.9330,0.3],'EdgeColor','none');
end
title(sprintf('Kni MS2 mCherry-uBcd bnt(%s)',embryo));
pos=get(hAX,'position');   % get the position vector
pos1=pos(2);              % save the original bottom position
pos(2)=pos(2)+pos1; pos(4)=pos(4)-pos1;  % raise bottom/reduce height->same overall upper position
set(hAX,'position',pos)   % and resize first axes
pos(2)=pos1; pos(4)=0.01; % reset bottom to original and small height
hAX(2)=axes('position',pos,'color','none');  % and create the second

ylabel(hAX(1),'foci counts');
xlabel(hAX(1),'Time(min)');
xlim(hAX(1),[0 t]);
xlim(hAX(2),[0 t]);
ylim(hAX(1),[0 1500]);
if NC_frame(1)==0
        xticks(hAX(2),NC_frame(2:5));
        xticklabels(hAX(2),{'NC12','NC13','NC14',''});
        xline(hAX(1),NC_frame(2),'--');
        xline(hAX(1),NC_frame(3),'--');
        xline(hAX(1),NC_frame(4),'--');
    else
        xticks(hAX(2),NC_frame);
        xticklabels(hAX(2),{'NC11','NC12','NC13','NC14',''});
        xline(hAX(1),NC_frame(1),'--');
        xline(hAX(1),NC_frame(2),'--');
        xline(hAX(1),NC_frame(3),'--');
        xline(hAX(1),NC_frame(4),'--');
    end

saveas(gcf,sprintf('%s_timelapse.png',embryo));
close;
