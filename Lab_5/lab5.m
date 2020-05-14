% read pair of images
I1 = imread('auvsi-cv-stereoVision/exercises/media/RecordedImages/left/frameL_12_Jan_2016_11_04_37.jpg');
%I1 = rgb2gray(I1);
I2 = imread('auvsi-cv-stereoVision/exercises/media/RecordedImages/right/frameR_12_Jan_2016_11_04_37.jpg');
%I2 = rgb2gray(I2);
% rectify images using calculated stereo parameters
[J1_col, J2_col] = rectifyStereoImages(I1, I2, stereoParams);
J1 = rgb2gray(J1_col);
J2 = rgb2gray(J2_col);
%imtool(cat(3, J1, J2, J2));

% disparity range
dispRange = [1, 17];
% disparityMap = disparity(J1, J2, 'DisparityRange', dispRange);
disparityMap = disparity(J1, J2, 'DisparityRange', dispRange, 'BlockSize', 11, 'ContrastThreshold', 0.8, 'UniquenessThreshold', 18);
% show disparity map
figure 
imshow(disparityMap, dispRange);
colormap(gca,jet) 
colorbar

points3D = reconstructScene(disparityMap, stereoParams);

% Convert to meters
points3D = points3D ./ 1000;

% Limit the range of Z and X for display.
thresholds=[-2.5 1.5;0 6;7 30];  %-3 3 0 6 7 30
points3D = thresholdPC(points3D,thresholds);

% View point cloud
figure
pcshow(points3D, J1_col)
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Point Cloud');

points = points3D(~isnan(points3D(:, :, 3)));

figure
histogram(points)
xlabel('Wspó³rzêdna z');
title('Histogram wspó³rzêdnych z punktów stanowi¹cych przeszkodê');
xticks(7:0.5:30)
grid on
