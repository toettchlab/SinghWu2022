function [ rA, rP, rD, rV ] = computePoles( mask, flip )
    % COMPUTE POLES. From the BW mask of the embryo this computes all four 
    % positions of poles (anterior, posterior, dorsal, and ventral.
    %
    % Inputs
    % 1. mask - BW image. Pixels = 1 demarks the embryo's location.
    
    CC = bwconncomp(mask);

    % Rotate the mask to determine the AP axis as the extremal points of the mask
    S = regionprops(CC,'Orientation','Centroid');    
    angle = S.Orientation; % Angle is in DEGREES!

    maskRot = imrotate(mask,-angle);
    rotMatrix = [cosd(angle), sind(angle); -sind(angle), cosd(angle)];

    CC = bwconncomp(maskRot);
    S = regionprops(CC,'Centroid','MajorAxisLength', 'MinorAxisLength','Extrema');
    
    % After rotation, the major axis is aligned with x axis
    ext = S.Extrema;
    rP_rot = (ext(3,:)+ext(4,:))/2;
    rA_rot = (ext(7,:)+ext(8,:))/2;
    rD_rot = (ext(1,:)+ext(2,:))/2;
    rV_rot = (ext(5,:)+ext(6,:))/2;
    rD_rot(1) = .5*(rD_rot(1) + rV_rot(1));
    rV_rot(1) = rD_rot(1);
    
    R = 1/2*[size(maskRot,2) size(maskRot,1)];
    
    %coordinates of the center of the original image
    center = .5*[size(mask,2) size(mask,1)];
    if flip
        rP = center + (rotMatrix * (rA_rot-R)')';
        rA = center + (rotMatrix * (rP_rot-R)')';
    else
        rA = center + (rotMatrix * (rA_rot-R)')';
        rP = center + (rotMatrix * (rP_rot-R)')';
    end
    rD = center + (rotMatrix * (rD_rot-R)')';
    rV = center + (rotMatrix * (rV_rot-R)')';

end

