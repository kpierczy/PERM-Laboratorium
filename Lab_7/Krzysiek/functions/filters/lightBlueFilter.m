function [BW,maskedImage] = lightBlueFilter(RGB,MASK)

% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Load Mask
BW = MASK;

% Erode mask with disk
radius = 3;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imerode(BW, se);

% Dilate mask with square
width = 10;
se = strel('square', width);
BW = imdilate(BW, se);

% Close mask with square
width = 10;
se = strel('square', width);
BW = imclose(BW, se);

% Erode mask with square
width = 5;
se = strel('square', width);
BW = imerode(BW, se);

% Fill holes
BW = imfill(BW, 'holes');

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;

end

