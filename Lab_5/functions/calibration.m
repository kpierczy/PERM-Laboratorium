function [stereoParams, I1, I2, J1, J2] = calibration(imageFileNames1,imageFileNames2)

    % Detect checkerboards in images
    [imagePoints, boardSize, ~] = detectCheckerboardPoints(imageFileNames1, imageFileNames2);

    % Generate world coordinates of the checkerboard keypoints
    squareSize = 30;  % in units of 'millimeters'
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);

    % Read one of the images from the first stereo pair
    I1 = imread(imageFileNames1{1});
    [mrows, ncols, ~] = size(I1);

    % Calibrate the camera
    [stereoParams, ~, ~] = estimateCameraParameters(imagePoints, worldPoints, ...
        'EstimateSkew', true, 'EstimateTangentialDistortion', true, ...
        'NumRadialDistortionCoefficients', 3, 'WorldUnits', 'millimeters', ...
        'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
        'ImageSize', [mrows, ncols]);
    
end

