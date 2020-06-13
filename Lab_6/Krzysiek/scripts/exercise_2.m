clear

im1 = imread('img/ex_1.jpg');
im2 = imread('img/ex_2.jpg');
im3 = imread('img/ex_3.jpg');

% Process images
[stats1, descripted1] = descriptor(im1);
[stats2, descripted2] = descriptor(im2);
[stats3, descripted3] = descriptor(im3);

% Display descripted images
figure
imshow(descripted1);
figure
imshow(descripted2);
figure
imshow(descripted3);