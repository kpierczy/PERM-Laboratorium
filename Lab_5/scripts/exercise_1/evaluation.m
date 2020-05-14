calibration
clearvars -except stereoParams
imtool close all

%========================================================================%
%=========================== Configuration ==============================%
%========================================================================%

% Photo identifier
photo_id = '0015';

% Disparity parameters range
dispRange = [72, 232];
blockSize = 19;
contrastThr = 0.05;
uniqnessThr = 8;


% Display control
DISP_RECTIFIED_IMG = false;
DISP_DISPARITY_MAP = false;
DISP_REPROJECTION  = true;

%========================================================================%
%============================ Computation ===============================%
%========================================================================%

% Read pair of images
I1 = imread(strcat('data\exercise_1\calib_stereo_1\left\left-', photo_id, '.png'));
I2 = imread(strcat('data\exercise_1\calib_stereo_1\right\right-', photo_id, '.png'));

% rectify images using calculated stereo parameters
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);

% Display rectified images
if DISP_RECTIFIED_IMG
    imtool(cat(3, J1, J2, J1));
end

% Get disparity map
disparityMap = disparity(               ...
    J1, J2,                             ...
    'DisparityRange',      dispRange,   ...
    'BlockSize',           blockSize,   ...
    'ContrastThreshold',   contrastThr, ...
    'UniquenessThreshold', uniqnessThr  ...
);
	
% Show disparity map
if DISP_DISPARITY_MAP
    figure
    imshow(disparityMap, dispRange);
    colormap(gca,jet)
    colorbar
end

% Reconstruct 3D scene
points3D = reconstructScene(disparityMap, stereoParams);

% expand gray image to three channels (simulate RGB)
J1_col = cat(3, J1, J1, J1);

% Convert to meters and create a pointCloud object
points3D = points3D ./ 1000;
ptCloud = pointCloud(points3D, 'Color', J1_col);

% Visualize the point cloud
if DISP_REPROJECTION
    
    % Create a streaming point cloud viewer
    player3D = pcplayer(          ...
        [-3, 3], [-3, 3], [0, 8], ...
        'VerticalAxis', 'y',      ...
        'VerticalAxisDir', 'down' ...
    );
    
    view(player3D, ptCloud); 
end