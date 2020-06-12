function [BW,maskedImage] = pinkFilter(RGB,MASK)

% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Load Mask
BW = MASK;

% Erode mask with diamond
radius = 3;
se = strel('diamond', radius);
BW = imerode(BW, se);

% Dilate mask with diamond
radius = 3;
se = strel('diamond', radius);
BW = imdilate(BW, se);

% Close mask with diamond
radius = 3;
se = strel('diamond', radius);
BW = imclose(BW, se);

% Fill holes
BW = imfill(BW, 'holes');

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end

