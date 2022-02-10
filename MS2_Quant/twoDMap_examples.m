
    %%
    x=1:size(A,2);
    y=1:size(A,1);
    subplot(1,3,1)
   pcolor(x,y,A);
   
colorbar;
shading interp;
caxis([200 max(A(:))])
subplot(1,3,2)
imagesc(x,y,A); 
colorbar;      
set(gca,'Xlim',[min(x),max(x)]); 
set(gca,'Ylim',[min(y),max(y)]); 
set(gca,'YDir','normal');
caxis([200 max(A(:))])
subplot(1,3,3)
h=heatmap(x,y,A);
% h.ColorbarVisible = 'off';
colormap cool
h.GridVisible = 'off'
caxis([200 max(A(:))])
% snapnow