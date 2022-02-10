function [ expInfoDS ] = makeExpInfo( analysisFolder )
% makeExpInfo Stores all relevant information/data that will be used
% in the following analyses

if exist([analysisFolder,filesep,'expInfo.txt'],'file')
    info = readtext([analysisFolder,filesep,'expInfo.txt'],'\t');
    userInfo = cell2struct(info(:,2),info(:,1),1);
else
    error('User must supply expInfo.txt in the analysis directory')
end

if isfield(userInfo,'rawDataFolder')
    expInfoDS.expInfo.rawDataFolder = userInfo.rawDataFolder;
    expInfoDS.expInfo.analysisFolder = analysisFolder;
    if isfield(userInfo,'useIlastik')
        expInfoDS.expInfo.useIlastik = useIlastik;
    else
        expInfoDS.expInfo.useIlastik = 0;
    end
    if isfield(userInfo,'useComplement')
        expInfoDS.expInfo.useComplement = userInfo.useComplement;
    else
        expInfoDS.expInfo.useComplement = 0;
    end
    if isfield(userInfo,'useEmbMask')
        expInfoDS.expInfo.useEmbMask = userInfo.useEmbMask;
    else
        expInfoDS.expInfo.useEmbMask = 0;
    end
    if isfield(userInfo,'noNuc')
        expInfoDS.expInfo.noNuc = userInfo.noNuc;
    else
        expInfoDS.expInfo.noNuc = 0;
    end
    if isfield(userInfo,'lowmem')
        expInfoDS.expInfo.lowmem = userInfo.lowmem;
    else
        expInfoDS.expInfo.lowmem = 0;
    end
else
    error('expInfo.txt should include rawDataFolder')
end

if isfield(userInfo,'channelsNames') && isfield(userInfo,'nucleiChannel')
    channelsNames = strsplit(userInfo.channelsNames,'/');
else
    error('expInfo.txt should include channelsNames and nucleiChannel')
end

nChannels = length(channelsNames);
channels = struct();

if isfield(userInfo,'Nspot')
    Nspot = str2double(strsplit(userInfo.Nspot,'/'));
else
    Nspot = ones(1,nChannels);
end

for cc = 1:nChannels
    channels(cc).name = channelsNames{cc};
    channels(cc).rawImagesFolderName = [analysisFolder,filesep,channelsNames{cc}];
    channels(cc).procImagesFolderName = [analysisFolder,filesep,channelsNames{cc},'_proc'];
    channels(cc).isNuclei = (cc == userInfo.nucleiChannel);
    if isfield(userInfo,'refChannel')
        channels(cc).isRef = (cc == userInfo.refChannel);
    else
        channels(cc).isRef = false;
    end
    channels(cc).Nspot = Nspot(cc);
end

expInfoDS.channelsInfo = channels;

if isfield(userInfo,'nTimePoints')
    T = userInfo.nTimePoints;
    d = dir([userInfo.rawDataFolder,filesep,'*.tif']);
    if (T < 1) || (mod(length(d),T) ~= 0)
        disp('number of files in rawDataFolder does not match nTimePoints');
    end
else
    error('expInfo.txt should include nTimePoints')
end

if isfield(userInfo,'timeResulotion')
    DeltaT = userInfo.timeResulotion;
else
     DeltaT = 30;
end

if isfield(userInfo,'Zslices')
    Zslices = userInfo.Zslices;
else
    error('expInfo.txt should include Zslices')
end

if isfield(userInfo,'Zaverage')
    Zaverage = userInfo.Zaverage;
    if Zaverage < 1
        Zaverage = 1;
    end
else
    error('expInfo.txt should include Zaverage')
end

if isfield(userInfo,'mergedChan')
    mergedChan = userInfo.mergedChan;
else
    mergedChan = true;
end

imDS = imfinfo([userInfo.rawDataFolder,filesep,d(1).name]); % (Y x X x nChannels*Z*Zav) matrix or (Y x X x Z*Zav) matrix
Ztotal = length(imDS);
X = imDS(1).Width;
Y = imDS(1).Height;

if mergedChan
    if Ztotal ~= nChannels*Zslices*Zaverage
        error('Ztotal not consistent with nChannels*Zslices*Zaverage')
    end
else
    if Ztotal ~= Zslices*Zaverage
        error('Ztotal not consistent with Zslices*Zaverage')
    end
end

expInfoDS.imagingInfo = struct('X',X,'Y',Y,'T',T,'Zslices',userInfo.Zslices,'Zav',Zaverage,'Ztotal',Ztotal,'mergedChan',mergedChan,'DeltaT',DeltaT);

if isfield(userInfo,'Xpixel')&&isfield(userInfo,'Ypixel')&&isfield(userInfo,'Zpixel')
    expInfoDS.imagingInfo.Xpixel  = userInfo.Xpixel;
    expInfoDS.imagingInfo.Ypixel  = userInfo.Ypixel;
    expInfoDS.imagingInfo.Zpixel  = userInfo.Zpixel;
else
    error('expInfo.txt should include pixel size [nm] Xpixel, Ypixel and Zpixel')
end

% Obtain dark current for flat field correction
if isfield(userInfo,'darkCurrent')
    darkCurrent = userInfo.darkCurrent;
else
    darkCurrent = 0;
end
expInfoDS.flatfield.darkCurrent = darkCurrent;

% Obtain flat-field for spot images.
FFfolder = [userInfo.rawDataFolder,filesep,'..'];
[FF,G] = metaData.extractFF4x(FFfolder, X, Y, darkCurrent);
expInfoDS.flatfield.FF4x = FF;
expInfoDS.flatfield.Gain4x = G;

% Get zoom factor
if isfield(userInfo,'zoomFactor')
    zoomFactor = userInfo.zoomFactor;
else
    zoomFactor = metaData.acquireImageDetails( imDS, {'zoomFactor'} );
    if isnan(zoomFactor)
        error('could not find zoomFactor, include it in expInfo.txt')
    end
end
expInfoDS.imagingInfo.zoomFactor = zoomFactor;

% Determine AP axis for position
if (exist([userInfo.rawDataFolder,filesep,'FullEmbryo'],'dir'))
    if isfield(userInfo,'flip')
        isflip = userInfo.flip;
    else
        isflip = false;
    end
    
    d = dir([userInfo.rawDataFolder,filesep,'FullEmbryo',filesep,'*.tif']);
    imDS = imfinfo([userInfo.rawDataFolder,filesep,'FullEmbryo',filesep,d(1).name]); %bad if the first file is the ref one
    X = imDS(1).Width;
    Y = imDS(1).Height;
    
    % Obtain flat-field for zoomed-out embryo.
    [FF,G] = metaData.extractFF1x(FFfolder, X, Y, darkCurrent);
    expInfoDS.flatfield.FF1x = FF;
    expInfoDS.flatfield.Gain1x = G;
    % Estimate AP position
    expInfoDS.embryoInfo = metaData.findAbsolutePosition(expInfoDS, isflip);
else
    expInfoDS.embryoInfo = [];
end

end

