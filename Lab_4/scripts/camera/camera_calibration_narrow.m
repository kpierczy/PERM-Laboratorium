% Auto-generated by cameraCalibrator app on 29-Apr-2020
%-------------------------------------------------------


% Define images to process
imageFileNames = {'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0000.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0001.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0002.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0003.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0004.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0005.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0006.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0007.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0008.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0009.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0010.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0011.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0012.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0013.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0014.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0015.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0016.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0017.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0018.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0019.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0021.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0024.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0025.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0027.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0028.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0029.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0030.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0031.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0032.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0033.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0034.png',...
    'E:\Projects\PERM-Laboratorium\Lab_4\data\calib_narrow\left-0035.png',...
    };
% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 40;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParamsNarrow, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', true, 'EstimateTangentialDistortion', true, ...
    'NumRadialDistortionCoefficients', 3, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

<<<<<<< HEAD
if plot
    
    % View reprojection errors
    h1=figure; showReprojectionErrors(cameraParamsNarrow);

    % Visualize pattern locations
    h2=figure; showExtrinsics(cameraParamsNarrow, 'CameraCentric');

end
=======
% if plot
%     
%     % View reprojection errors
%     h1=figure; showReprojectionErrors(cameraParamsNarrow);
% 
%     % Visualize pattern locations
%     h2=figure; showExtrinsics(cameraParamsNarrow, 'CameraCentric');
% 
% end
>>>>>>> 461196addc31add2389140318b9cf61ce9e0e932
    
% Display parameter estimation errors
displayErrors(estimationErrors, cameraParamsNarrow);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParamsNarrow);
