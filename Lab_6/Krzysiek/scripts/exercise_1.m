clear

im1 = imread('img/ex_1.jpg');
im2 = imread('img/ex_2.jpg');
im3 = imread('img/ex_3.jpg');

% Images filtering
[BW1, im1] = filterRGB(im1);
[BW2, im2] = filterRGB(im2);
[BW3, im3] = filterRGB(im3);

% Print results
figure
imshow(im1);
figure
imshow(im2);
figure
imshow(im3);