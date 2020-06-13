function [BW,maskedImage] = blueFilter(RGB,MASK)

% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Load Mask
BW = MASK;

% Erode mask with disk
radius = 5;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imerode(BW, se);

% Dilate mask with disk
radius = 6;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imdilate(BW, se);

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end

