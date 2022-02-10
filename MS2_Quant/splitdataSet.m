function timeSeries=splitdataSet(filename, dataLines,nCol)

PM = importfile_LabViewdata(filename, dataLines,nCol);
PM3=table2array(PM);
f=find(ge(PM3(:,1),0) & le(PM3(:,1),0.999));
 C = zeros(size(f,1),4);
% C{size(f,1),4} = [];

for i=1:size(f,1)
  C(i,:)=PM3(f(i),:);
end

t=min(C(2,1)).*(0:(size(C,1)-1))';
timeSeries(:,1)=t;
timeSeries(:,2:4)=C(:,2:4);
end