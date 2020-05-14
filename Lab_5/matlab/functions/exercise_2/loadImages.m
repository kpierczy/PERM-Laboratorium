%==============================================================%
% Loads pair of images of index 'idx' and cut them with respect
% to 'bounds' vector.
%
% @param idx : index of the pair
% @param bounds : [2 x 2] vector containing bounds values
%        between 0 and 1, bot inclusively.
% @param filterParams : structcontaining parameters of the
%        filter applied after loading images
%==============================================================%
function [I1, I2] = loadImages(idx, bounds, filterParams)
    
    % Load all pairs
    LeftImages  = imageSet('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_2\RecordedImages\left');
    RightImages = imageSet('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_2\RecordedImages\right');

    % Load the idx'th images from the directories
    I1  = imread(LeftImages.ImageLocation{idx});
    I2 = imread(RightImages.ImageLocation{idx}); 

    % Extract the middle of the image
    [nr, nc, ~] = size(I1);
    if bounds(1, 1) == 0
        I1 = I1(1:bounds(1, 2) * nr, :, :);
        I2 = I2(1:bounds(1, 2) * nr, :, :);
    else
        I1 = I1(bounds(1, 1) * nr:bounds(1, 2) * nr, :, :);
        I2 = I2(bounds(1, 1) * nr:bounds(1, 2) * nr, :, :);
    end
    if bounds(2, 1) == 0
        I1 = I1(:, 1:bounds(2, 2) * nc, :);
        I2 = I2(:, 1:bounds(2, 2) * nc, :);
    else
        I1 = I1(:, bounds(2, 1) * nc:bounds(2, 2) * nc, :);
        I2 = I2(:, bounds(2, 1) * nc:bounds(2, 2) * nc, :);
    end
    
    % Filter pictures
    if strcmp(filterParams.filterType, 'histeq')
        I1 = histeq(I1, filterParams.binsNum);
        I2 = histeq(I2, filterParams.binsNum);
    end
    
end