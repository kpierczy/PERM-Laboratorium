%---------------------------------------------------------------%
%------------------------ Configuration ------------------------%
%---------------------------------------------------------------%

% Path to the source file
img_RGB_src = 'images/ex_1.jpg';

% Segment size
size_s = 50;

%---------------------------------------------------------------%
%------------------------- Computation -------------------------%
%---------------------------------------------------------------%

% Load picture
img_RGB = imread(img_RGB_src);
img_HSV = rgb2hsv(img_RGB);

% Get segment from the picture
img_HSV_1 = img_HSV(1:size_s, 1:size_s,:);
img_HSV_2 = img_HSV(1:size_s, end-size_s : end,:);
img_HSV_3 = img_HSV(end-size_s : end, 1:size_s,:);
img_HSV_4 = img_HSV(end-size_s : end, end-size_s : end,:);


%[maskBW1, ~ ] = createMask(img_RGB);
[maskBW1]     = createMaskSum1(img_RGB);
[maskBW2, ~ ] = segmentImage2(img_RGB, maskBW1);

list_of_masks = bwconncomp(maskBW2);

stats = regionprops(list_of_masks);
idx = find([stats.Area] > 1000 );

list_of_masks.PixelIdxList = list_of_masks.PixelIdxList(idx);
list_of_masks.NumObjects = size(idx,2);
labels = labelmatrix(list_of_masks);

imshow(label2rgb(labels,'jet','k','shuffle'));


