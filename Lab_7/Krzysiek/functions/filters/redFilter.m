function [BW,maskedImage] = redFilter(RGB,MASK)

% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Load Mask
BW = MASK;

% Dilate mask with rectangle
dimensions = [7 6];
se = strel('rectangle', dimensions);
BW = imdilate(BW, se);

% Erode mask with diamond
radius = 5;
se = strel('diamond', radius);
BW = imerode(BW, se);

% Close mask with disk
radius = 30;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imclose(BW, se);

% Fill holes
BW = imfill(BW, 'holes');

% Dilate mask with rectangle
radius = 2;
se = strel('diamond', radius);
BW = imdilate(BW, se);

% Dilate mask with line
length = 4;
angle = 1355;
se = strel('line', length, angle);
BW = imdilate(BW, se);

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;

end

