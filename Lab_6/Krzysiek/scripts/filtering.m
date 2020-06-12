im1 = imread('img/ex_1.jpg');
im2 = imread('img/ex_2.jpg');
im3 = imread('img/ex_3.jpg');

mask = @(RGB)(darkBlue(RGB));
maskFilter = @(RGB, MASK)(darkBlueFilter(RGB, MASK));

[BW1, masked1] = mask(im1);
[BW2, masked2] = mask(im2);
[BW3, masked3] = mask(im3);

filteredBW1 = maskFilter(im1, BW1);
filteredBW2 = maskFilter(im2, BW2);
filteredBW3 = maskFilter(im3, BW3);

im1(repmat(~filteredBW1, [1 1 3])) = 0;
im2(repmat(~filteredBW2, [1 1 3])) = 0;
im3(repmat(~filteredBW3, [1 1 3])) = 0;

figure
imshow(im1);
figure
imshow(im2);
figure
imshow(im3);

% figure
% imshow(masked1);
% figure
% imshow(masked2);
% figure
% imshow(masked3);