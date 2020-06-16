clear

im1 = imread('img/ex_1.jpg');
im2 = imread('img/ex_2.jpg');
im3 = imread('img/ex_3.jpg');
im4 = imread('img/ex_4.jpg');

% Process images
[stats1, descripted1] = descriptor(im1);
[stats2, descripted2] = descriptor(im2);
[stats3, descripted3] = descriptor(im3);
[stats4, descripted4] = descriptor(im4);

% Display descripted images
figure
imshow(descripted1);
figure
imshow(descripted2);
figure
imshow(descripted3);
figure
imshow(descripted4);

% Save
imwrite(descripted1, 'desc_1.jpg');
imwrite(descripted2, 'desc_2.jpg');
imwrite(descripted3, 'desc_3.jpg');
imwrite(descripted4, 'desc_4.jpg');
