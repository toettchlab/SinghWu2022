function [ FF,G ] = extractFF4x_2color( folder, X, Y, darkCurrent )
% EXTRACT FLAT FIELD: Takes in the folder we will look for the flat
% field image within and then computes and returns the image.

% Obtain FF image. FFDir = dir([folder,filesep,'FF2.0x','*.tif']);
FFDir = dir([folder,filesep,'*.tif']);

if (~isempty(FFDir))
    FFFile = FFDir(1).name;
%     FF = single(loadTiff([folder,filesep,FFFile]));
FF = double(loadTiff([folder,filesep,FFFile]));
    if size(FF,3) > 1 && size(FF,3) < 3 % For Hernan
        FF = FF(:,:,1);
    end
    if size(FF,3) > 2
        FF = mean(FF,3);
        FF(:,1) = FF(:,2);
        FF(:,end) = FF(:,end-1);
        FF(1,:) = FF(2,:);
        FF(end,:) = FF(end-1,:);
    end
    FF = FF - darkCurrent;
    FF=imgaussfilt(FF,10);
    FF = imfilter(FF,fspecial('disk',30),'replicate','same');
    maxInt = max(FF(:));
    FF(FF<0.5*maxInt) = 0.5*maxInt;
    G = mean(FF(:))./FF; % Gain
    %G(G>10) = 10;
else
    FF = ones(Y,X);
    G = ones(Y,X);
    display('no FF4x file was used');
end

% [x,y] = meshgrid(1:X,1:Y);
% figure
% surf(x,y,FF,'EdgeColor','none')
% figure
% surf(x,y,G,'EdgeColor','none')

end

