function [ embryoInfo ] = findAbsolutePosition( expInfoDS, flip )
% FIND ABSOLUTE POSITION. From the FullEmbryo images calculate the
% anterior and posterior poles, and the axis between them.  Align the
% surface image with the stitched saggital images.
%
% Inputs
% 1. expInfoDS.
% 2. flip - whether to flip AP-axis.

rawFolder = expInfoDS.expInfo.rawDataFolder;
analysisFolder = expInfoDS.expInfo.analysisFolder;
zoomFactor = expInfoDS.imagingInfo.zoomFactor;
rawDim = [expInfoDS.imagingInfo.Y,expInfoDS.imagingInfo.X];
darkCurrent = expInfoDS.flatfield.darkCurrent;
gain1x = expInfoDS.flatfield.Gain1x;
gain4x = expInfoDS.flatfield.Gain4x;
nucChan = find(vertcat(expInfoDS.channelsInfo.isNuclei));

HG = 0; % for Hernan data

if HG && (size(gain1x,1) ~= 512)
    temp = ones(512,512,'single');
    temp(128+(1:256),:) = gain1x;
    gain1x = temp;
end

% Obtain Saggital images.
D = dir([rawFolder,filesep,'FullEmbryo',filesep,'*.tif']);

%Find the right and left files that do not correspond to the surface image
%FILES IN THE FULLEMBRYO FOLDER ARE USUALLY NAMED SOMETHING LIKE "RightPASURF,", "RightPA", "LeftPA"


leftFileIndex = find( contains({D.name},'left','IgnoreCase',true) & ...
    ~contains({D.name},'surf','IgnoreCase',true) );
rightFileIndex = find( contains({D.name},'right','IgnoreCase',true) & ...
    ~contains({D.name},'surf','IgnoreCase',true) );
centerFileIndex = find( contains({D.name},'center','IgnoreCase',true) & ...
    ~contains({D.name},'surf','IgnoreCase',true) );
bottomFileIndex = find( contains({D.name},'bottom','IgnoreCase',true) & ...
    ~contains({D.name},'surf','IgnoreCase',true) );
topFileIndex = find( contains({D.name},'top','IgnoreCase',true) & ...
    ~contains({D.name},'surf','IgnoreCase',true) );

%Check if the right/left were taken as top/bottom
if (~isempty(rightFileIndex) && ~isempty(leftFileIndex))
    TB = 0;
else
    TB = 1;
    gain1x = permute(gain1x,[2,1]);
    gain4x = permute(gain4x,[2,1]);
end
    
if TB == 0
    left = single(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(leftFileIndex).name]));
else
    left = single(permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(topFileIndex).name]),[2,1,3]));
end
if (size(left,3) > 1)
    left = mean(left,3);
end
left = (left-darkCurrent).*gain1x;
% p = prctile(left(:),99);
% left(left>p) = p;
left = imgaussian(left,2.5);
 
if TB == 0
    right = single(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(rightFileIndex).name]));
else
    right = single(permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(bottomFileIndex).name]),[2,1,3]));
end
if (size(right,3) > 1)
    right = mean(right,3);
end
right = (right-darkCurrent).*gain1x;
% p = prctile(right(:),99);
% right(right>p) = p;
right = imgaussian(right,2.5);

if (~isempty(centerFileIndex)) % Left, center, right
    if TB == 0
        center = single(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(centerFileIndex).name]));
    else
        center = single(permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(centerFileIndex).name]),[2,1,3]));
    end
    if (size(center,3) > 1)
        center = mean(center,3);
    end
    center = (center-darkCurrent).*gain1x;
%     p = prctile(center(:),99);
%     center(center>p) = p;
    center = imgaussian(center,2.5);
    
    [ leftCenter, x1, y1 ] = metaData.imstitch( left, center );
    [ fullEmbryo, x2, y2 ] = metaData.imstitch( leftCenter, right );
    x = [x1,x2];
    y = [y1,y2];
    xr = [0,x1,x2];
    if y1 < 0
        yr = [-y1,0];
    else
        yr = [0,y1];
    end
    if y2 < 0
        yr = [yr-y2,0];
    else
        yr = [yr,y2];
    end
    dim{1} = size(left);
    dim{2} = size(center);
    dim{3} = size(right);
    dim{4} = size(leftCenter);
    dim{5} = size(fullEmbryo);
else % Left, right
    [ fullEmbryo, x, y ] = metaData.imstitch( left, right );
    xr = [0,0,x];
    if y < 0
        yr = [-y,0,0];
    else
        yr = [0,0,y];
    end
    dim{1} = size(left);
    dim{3} = size(right);
    dim{4} = size(fullEmbryo);
end
[ mask ] = metaData.makeMask( fullEmbryo, 20 );
[ rA, rP, rD, rV ] = metaData.computePoles( mask, flip );

refSurface = find( contains({D.name},'ref','IgnoreCase',true) & ...
    contains({D.name},'surf','IgnoreCase',true) );
leftSurface = find( ~contains({D.name},'ref','IgnoreCase',true) & ...
    contains({D.name},'left','IgnoreCase',true) & ...
    contains({D.name},'surf','IgnoreCase',true) );
rightSurface = find( ~contains({D.name},'ref','IgnoreCase',true) & ...
    contains({D.name},'right','IgnoreCase',true) & ...
    contains({D.name},'surf','IgnoreCase',true) );
centerSurface = find( ~contains({D.name},'ref','IgnoreCase',true) & ...
    contains({D.name},'center','IgnoreCase',true) & ...
    contains({D.name},'surf','IgnoreCase',true) );    
bottomSurface = find( ~contains({D.name},'ref','IgnoreCase',true) & ...
    contains({D.name},'bottom','IgnoreCase',true) & ...
    contains({D.name},'surf','IgnoreCase',true) );
topSurface = find( ~contains({D.name},'ref','IgnoreCase',true) & ...
    contains({D.name},'top','IgnoreCase',true) & ...
    contains({D.name},'surf','IgnoreCase',true) );

if (~isempty(refSurface))
    if TB == 0
        ref = single(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(refSurface).name]));
    else
        ref = single(permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(refSurface).name]),[2,1,3]));
    end
    ref = (ref-darkCurrent).*gain4x;
    Rdim = size(ref);
    
    if (~isempty(leftSurface) || ~isempty(topSurface))
        if TB == 0
            surf = single(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(leftSurface).name]));
        else
            surf = single(permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(topSurface).name]),[2,1,3]));
        end
        if (size(surf,3) > 1)
            surf = surf(:,:,nucChan);
        end
        surf = (surf-darkCurrent).*gain1x;
        p = prctile(surf(:),99);
        surf(surf>p) = p;
        
        Sdim = size(surf);
        n = 1;
        eMask = mask((1:Sdim(1))+yr(n),(1:Sdim(2))+xr(n));
    elseif (~isempty(centerSurface))
        if TB == 0
            surf = single(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(centerSurface).name]));
        else
            surf = single(permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(centerSurface).name]),[2,1,3]));
        end
        if (size(surf,3) > 1)
            surf = surf(:,:,nucChan);
        end      
        surf = (surf-darkCurrent).*gain1x;
        p = prctile(surf(:),99);
        surf(surf>p) = p;
        
        Sdim = size(surf);
        n = 2;
        eMask = mask((1:Sdim(1))+yr(n),(1:Sdim(2))+xr(n));
    elseif (~isempty(rightSurface) || ~isempty(bottomSurface))
        if TB == 0
            surf = single(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(rightSurface).name]));
        else
            surf = single(permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(bottomSurface).name]),[2,1,3]));
        end
        if (size(surf,3) > 1)
            surf = surf(:,:,nucChan);
        end
        surf = (surf-darkCurrent).*gain1x;
        p = prctile(left(:),99);
        surf(surf>p) = p;
        
        Sdim = size(surf);
        n = 3;
        eMask = mask((1:Sdim(1))+yr(n),(1:Sdim(2))+xr(n));
    end
    
    Is = Sdim < Rdim;
    scaling = max(Rdim(Is)./Sdim(Is));
    if ~isempty(scaling)
        scaling = zoomFactor*scaling;
    else
        scaling = zoomFactor;
    end
    surf = mat2gray(surf);
    ref  = mat2gray(ref);
    
    erodMask = imerode(eMask, strel('disk',50));
    surfMask = metaData.getNucleiMask(surf,erodMask,0.75);
    refMask  = metaData.getNucleiMask(ref,[],0.75*zoomFactor);
    refMask  = imresize(refMask,1/scaling);
    Rdim = size(refMask);
    
    %[center0,corrFig] = metaData.findOptimalCenter(surfMask,refMask,erodMask);
    [center0,corrFig] = metaData.findOptimalCenter(surf,imresize(ref,1/scaling),erodMask);
    
    topLeftX = round(center0(2)-Rdim(1)/2)+1;
    topLeftY = round(center0(1)-Rdim(2)/2)+1;
    test = zeros(size(surfMask));
    test(topLeftX+(1:Rdim(1)),topLeftY+(1:Rdim(2))) = double(refMask);
    test = test + double(surfMask);
    figure(4)
    imagesc(test)
    
    % calculate centroid
    x0 = center0(1)+xr(n);
    y0 = center0(2)+yr(n);
else
    if (~isempty(leftSurface))
        surf = loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(leftSurface).name]);
        n = 1;
    elseif (~isempty(centerSurface))
        surf = loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(centerSurface).name]);
        n = 2;
    elseif (~isempty(rightSurface))
        surf = loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(rightSurface).name]);
        n = 3;
    else %Was a top/bottom embryo.        
        if (~isempty(leftSurface))
            surf = permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(leftSurface).name]),[2,1,3]);
            n = 1;
        else
            surf = permute(loadTiff([rawFolder,filesep,'FullEmbryo',filesep,D(rightSurface).name]),[2,1,3]);
            n = 3;
        end
    end
    surf = mean(surf,3);
    [x0,y0] = metaData.computeSurfaceCentroid(x,y,n,dim);
    Sdim = size(surf);
end

% Interpolate AP/DV coordinate fields onto our image coordinates.
Xdim = rawDim(2);
Ydim = rawDim(1);

if TB
    Xtemp = Xdim;
    Xdim = Ydim;
    Ydim = Xtemp;
end

Is = Sdim < rawDim;
scaling = max(rawDim(Is)./Sdim(Is));
if ~isempty(scaling)
    deltaX  = Xdim/(scaling*zoomFactor);
    deltaY  = Ydim/(scaling*zoomFactor);
else
    deltaX  = Xdim/zoomFactor;
    deltaY  = Ydim/zoomFactor;
end

[Xq,Yq] = meshgrid(linspace(x0-(deltaX/2),x0+(deltaX/2),Xdim),linspace((y0-deltaY/2),(y0+deltaY/2),Ydim));
[APimg,DVimg] = apPosition(Xq,Yq,rA,rP);
APimg = reshape(APimg,[Ydim,Xdim]);
DVimg = reshape(DVimg,[Ydim,Xdim]);

if TB
    APimg = permute(APimg,[2,1,3]);
    DVimg = permute(DVimg,[2,1,3]);
end

% Diagnostic Plots
figure(1)
imshow(fullEmbryo,[])
hold all
scatter(rA(1),rA(2),'filled','b')
scatter(rP(1),rP(2),'filled','r')
scatter(rD(1),rD(2),'filled','g')
scatter(rV(1),rV(2),'filled','y')
scatter(x0,y0,'filled','m')
rectangle('Position',[x0-deltaX/2,y0-deltaY/2,deltaX,deltaY],'EdgeColor',[1,0,1])
saveas(gcf,[analysisFolder,filesep,'positonInfo.pdf']);

figure(2)
imshow(APimg,[])

figure(3)
imshow(DVimg,[])

embryoInfo = struct('AP',APimg,'DV',DVimg,'rA',rA,'rP',rP,'rD',rD,'rV',rV,'flip',flip);

end

function [ap,dv] = apPosition(x,y,rA,rP)
% ap is the AP coordinate
% ap = 0 for A, ap = 1 for P
% bdv is the perpendicular coordinate normalized to the same units

PA = rP-rA;
PAperp = [-PA(2), PA(1)];

RA = double([x(:)-rA(1),y(:)-rA(2)]);

ap = (RA*PA')/(PA*PA');
dv  = (RA*PAperp')/(PA*PA');

end

