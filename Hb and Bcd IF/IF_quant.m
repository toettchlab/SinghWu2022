for i = 1:25
    bro = sprintf('%s.tif',string(i));
    I = imread(bro,3);% HB
    BCD = imread(bro,4); %BCD 
    %binarize based on HB image, getting a contour of the embryo
    [~,T] = edge(I,'sobel');
    BW = imbinarize(I,T);
    BWfill = imfill(BW,'holes'); %fill interior gap
    BW1 = bwareafilt(BWfill,1);% pick the largest object
    seD = strel('disk',4);
    BW_open = imopen(BW1,seD);
    se = strel('disk',10,0);
    kernel = se.Neighborhood / sum(se.Neighborhood(:));
    BWb = conv2(double(BW_open), kernel, 'same'); % blurring help to smooth the contour
    BW2 = imbinarize(BWb);
    BW3 = imerode(BW2,seD);
    BWoutline = bwperim(BW3); 
    %dilate the contour inward,and only get dorsal side
    se1 = strel('disk',15); 
    BWoutline2 = imdilate(BWoutline, se1);
    BW_in = BWoutline2 & BW3; % dilate inward asymmetrically 
    imwrite(BW_in,sprintf('%s_full.tif',string(i))); 
    [row,col] = find(BW_in);
    [xmin,indmin] = min(col); % get the index and value of the most anterior point
    [xmax,indmax] = max(col); %get the index and value of the most posterior point
    y_ind = max(row(indmin),row(indmax)); % get y value for the previous two points
    [m,~]= size (BW_in);
    BW_in((y_ind+1):m,:) = 0; % set the lower half of mask to 0, and only get dorsal contour
    haha = bwperim(BW_in);
    imwrite(BW_in,sprintf('%s_dorsal.tif',string(i))); 
    imwrite(imfuse(I,haha),sprintf('%s_HB.tif',string(i)));
    imwrite(imfuse(BCD,haha),sprintf('%s_BCD.tif',string(i)));
    
    %segmentation
    p = 100;
    delta = (xmax-xmin)/p;
    edges_L = round(xmin:delta:xmax); %divide the embryo into p portions
    
    BW_segment = BW_in;
    BWoutline((y_ind+1):m,:) = 0;
    [row,col] = find(BWoutline);
    xmin = min(col); % get the index and value of the most anterior point
    xmax = max(col); %get the index and value of the most posterior point
    for j = 2:(p+1)
        ind_tmp = find(col==edges_L(j));
        BW_segment(:,col(ind_tmp)) = 0;  % segment into 97 pieces
    end
    
    stats_hb = regionprops(BW_segment,I,'centroid','MeanIntensity');
    stats_bcd = regionprops(BW_segment,BCD,'MeanIntensity');
    
    centroids = cat(1,stats_hb.Centroid);    
    x_norm = arrayfun(@(x) (x-xmin)/(xmax-xmin),centroids(:,1));    % min-max normalized x axis, arrayfun  apply same operation on each element in an array
    hb_int = cat(1,stats_hb.MeanIntensity); 
    bcd_int = cat(1,stats_bcd.MeanIntensity); 
    
    sum = [x_norm centroids(:,2) bcd_int hb_int]; % y axis hasn't been normalized
    imwrite(BW_segment,sprintf('%s_segment.tif',string(i)));
    writematrix(sum,sprintf('%s.csv',string(i)));
    
    scatter(x_norm,bcd_int);
    hold on;
    scatter(x_norm,hb_int);
    saveas(gcf,sprintf('%s_plot.png',string(i)));
    hold off;
    
    clear all;
        
end

   
    
    
    
    
   
    
    
    
    
    