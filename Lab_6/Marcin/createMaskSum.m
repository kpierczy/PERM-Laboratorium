function [BW] = createMaskSum(RGB)

[maskBW1, ~ ] = createMask1(RGB);
%figure;
%imshow(maskBW1);

[maskBW2, ~ ] = createMask2(RGB);
%figure;
%imshow(maskBW2);

[maskBW3, ~ ] = createMask3(RGB);
%figure;
%imshow(maskBW3);

BW = (maskBW1 | maskBW2 | maskBW3);
%figure;
%imshow(BW);
end