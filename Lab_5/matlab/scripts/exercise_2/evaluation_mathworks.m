imtool close all
close all
clear

%========================================================================%
%=========================== Configuration ==============================%
%========================================================================%

% Set scenario (0 - calibration, 1 - simulation)
scenario = 0;

%------------------------------------------------------------------------%

% Photo identifier (calibration only)
photoIdx     = 10;
% Photo boundaries
photoBounds  = [2/5 3/4;   0   1];

% Filtering ('histeq', 'none')
imgFilterParams.filterType = 'none';
% Filtering parameters ('histeq')
imgFilterParams.binsNum    = 64; % Def : 64

%------------------------------------------------------------------------%

% Disparity map algorithm type ('SGM' / 'BM')
disparityParams.type = 'BM';
% Common disparity map parameters
disparityParams.dispRange    = [0, 16]; % Def : [0 64] 
disparityParams.uniqnessThr  =       7; % Def : 15
% 'BM' specific params
disparityParams.blockSize    =       13; % Def : 15
disparityParams.contrastThr  =     0.5; % Def : 0.5
disparityParams.distanceThr  =      []; % Def : []
disparityParams.textureThr   =  0.0002; % Def : 0.0002

% Disparity map filtering ('gaussian', 'median, 'none')
disparityFilterParams.filterType = 'none';
% Filtering parameters ('gaussian')
disparityFilterParams.sigma        =           2; % Def : 0.5
disparityFilterParams.filterSize   =          51; % Def : 2 * ceil(2*sigma) + 1
disparityFilterParams.padding      =  'symmetric'; % Def : 'replicate' ('circular', 'replicate', 'symmetric')
disparityFilterParams.filterDomain =      'auto'; % Def : 'auto' ('frequency', 'spatial')
% Filtering parameters ('median')
disparityFilterParams.neighborhood =       [5 3]; % Def : [3 3]

% Point cloud RoI (Region of Interest)
roi = [    ...
   -15  5; ...
   - 7  0; ...
     7 80  ...
];

%------------------------------------------------------------------------%

% Display control (calibration only)
DISP_ORIGIN_PHOTOS = false;
DISP_RECTIFIED_IMG = false;
DISP_DISPARITY_MAP = true;
DISP_ROI_PHOTOS    = true;
DISP_REPROJECTION  = true;

% Show reconstruction parameters (calibration only)
SHOW_LIMITS  = false;
SHOW_Z_HISTO = false; HIST_BINS = 16;


%========================================================================%
%=========================== Initialization =============================%
%========================================================================%

% Load stereoParams
stereoParams = loadParams('filenames_mathworks');


%========================================================================%
%============================ Calibration ===============================%
%========================================================================%

if scenario == 0

    % Read pair of images
    [I1, I2] = loadImages(photoIdx, photoBounds, imgFilterParams);

    % Rectify images using calculated stereo parameters
    [J1, J2] = rectifyStereoImages(I1, I2, stereoParams);

    % Conver J1 and J2 to grayscale to measure disparity by hand
    J1_gray = rgb2gray(J1);
    J2_gray = rgb2gray(J2);

    % Get disparity map
    disparityMap = getDisparityMap(J1_gray, J2_gray, disparityParams, disparityFilterParams);

    % Reconstruct 3D image
    [points3D, mask] = reconstruct(disparityMap, stereoParams, roi);

    % Create points cloud
    ptCloud = createPointCloud(points3D, J1);

end

%========================================================================%
%============================ Simulation ================================%
%========================================================================%

if scenario == 1

    % Create DeployableVideoPlayer for visualization
    VP = vision.DeployableVideoPlayer;  
    
    % Loop over all photos
    for imageIdx = 1:181
        
        % Read pair of images
        [I1, I2] = loadImages(imageIdx, photoBounds, imgFilterParams);

        % Rectify images using calculated stereo parameters
        [J1, J2] = rectifyStereoImages(I1, I2, stereoParams);

        % Conver J1 and J2 to grayscale to measure disparity by hand
        J1_gray = rgb2gray(J1);
        J2_gray = rgb2gray(J2);

        % Get disparity map
        disparityMap = getDisparityMap(J1_gray, J2_gray, disparityParams, disparityFilterParams);

        % Reconstruct 3D view
        [points3D, mask] = reconstruct(disparityMap, stereoParams, roi);
        
        %---------------------- Image analyze ----------------------%

        % @todo : make analysis :|
        %         ...
        %         ...
        %         ...

        % Update video frame
        step(VP, J1);
        
    end
    
end


%========================================================================%
%===================== Plotting (calibration only) ======================%
%========================================================================%

if scenario == 0

    % View the extracted image
    if DISP_ORIGIN_PHOTOS
        figure; 
        imshowpair(I1,I2,'montage'); 
        title('Extracted Portion of Original Images');
    end

    % Display rectified images
    if DISP_RECTIFIED_IMG
        imtool(cat(3, J1_gray, J2_gray, J2_gray));
    end

    % Show disparity map
    if DISP_DISPARITY_MAP
        f = figure;
        imshow(disparityMap, disparityParams.dispRange);
        set(f, 'Position', [0 560 1920 440]);
        colormap jet
        colorbar
    
    end

    % Show 2D photo with elements out of RoI cut
    if DISP_ROI_PHOTOS
        J1_cut = J1;
        J1_cut(~mask) = 0;
        f = figure;
        imshow(J1_cut);
        set(f, 'Position', [960 40 960 440]);
    end

    % Visualize the point cloud
    if DISP_REPROJECTION

        % Create a streaming point cloud viewer
        player3D = pcplayer(          ...
            [-100, 100], [-100, 100], [-100, 100], ...
            'VerticalAxis', 'y',      ...
            'VerticalAxisDir', 'down' ...
        );
        player3D.Axes.Parent.Position = [0 40 960 440];

        view(player3D, ptCloud); 
    end

    %------------------------------------------------------------------------%

    % Show limits of the reconstructed objects (in RoI)
    if SHOW_LIMITS
        x = [ nanmin(ptCloud.Location(:, :, 1), [], 'all'), nanmax(ptCloud.Location(:, :, 1), [], 'all')];
        y = [ nanmin(ptCloud.Location(:, :, 2), [], 'all'), nanmax(ptCloud.Location(:, :, 2), [], 'all')];
        z = [ nanmin(ptCloud.Location(:, :, 3), [], 'all'), nanmax(ptCloud.Location(:, :, 3), [], 'all')];
        display([x; y; z])
    end
    
    % Show histogram of elements basing on Z-axis placement
    if SHOW_Z_HISTO
        figure
        histogram(points3D(:, :, 3), HIST_BINS);
    end

end

    
%========================================================================%
%============================== Cleaning ================================%
%========================================================================%

clearvars -except disparityMap I1 I2 J1 J2 points3D ptCloud mask stereoParams player3D

