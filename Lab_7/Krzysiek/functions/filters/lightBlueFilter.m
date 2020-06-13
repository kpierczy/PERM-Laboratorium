function [BW,maskedImage] = lightBlueFilter(RGB,MASK)

% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Load Mask
BW = MASK;

% Erode mask with square
width = 2;
se = strel('square', width);
BW = imerode(BW, se);

% Close mask with diamond
radius = 15;
se = strel('diamond', radius);
BW = imclose(BW, se);

% Erode mask with diamond
radius = 5;
se = strel('diamond', radius);
BW = imerode(BW, se);

% Erode mask with square
width = 2;
se = strel('square', width);
BW = imerode(BW, se);

% Close mask with octagon
radius = 18;
se = strel('octagon', radius);
BW = imclose(BW, se);

% Dilate mask with diamond
radius = 8;
se = strel('diamond', radius);
BW = imdilate(BW, se);

% Close mask with octagon
length = 40;
angle = 90;
se = strel('line', length, angle);
BW = imclose(BW, se);

% Close mask with octagon
width = 50;
se = strel('square', width);
BW = imclose(BW, se);

% Fill holes
BW = imfill(BW, 'holes');

% Clear borders
BW = imclearborder(BW);

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;

end

