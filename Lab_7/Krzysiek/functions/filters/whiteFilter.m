function [BW,maskedImage] = whiteFilter(RGB,MASK)


% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Load Mask
BW = MASK;

% Erode mask with disk
radius = 2;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imerode(BW, se);

% Erode mask with disk
radius = 2;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imerode(BW, se);

% Erode mask with disk
radius = 2;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imerode(BW, se);

% Erode mask with disk
radius = 2;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imerode(BW, se);

% Close mask with disk
radius = 15;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imclose(BW, se);

% Dilate mask with disk
radius = 13;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imdilate(BW, se);

% Fill holes
BW = imfill(BW, 'holes');

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;

end

