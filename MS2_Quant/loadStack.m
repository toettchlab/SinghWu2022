function [ stack ] = loadStack(folder, l)
    % Load an entire folder of TIFFs into a single 4D matrix
    files = dir([folder,filesep, '*.tif']);
    filesMask = false(1,length(files));
    for i = 1:length(files)
        name = files(i).name;
        %Ignore mask, take in from expInfo;
        if(~contains(name,{'Left','Right','FullEmbryo','FullEmbyro'}))
            filesMask(i) = true;
        end
        
    end
    files = files(filesMask);
    if nargin < 2
        l = length(files);
    end
    
    im1 = loadTiff([folder, filesep, files(1).name]);
    stack = ones([size(im1), l],class(im1));
    
    for i = 1:l
        if i == 1
            stack(:,:,:,1) = im1;
        else
            stack(:,:,:,i) = loadTiff([folder, filesep, files(i).name]);
        end
    end

end