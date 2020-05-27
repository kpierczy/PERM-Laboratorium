function [BW] = createMaskSum1(RGB)

[maskBW1, ~ ] = createMask4(RGB);
%figure;
%imshow(maskBW1);

[maskBW2, ~ ] = createMask5(RGB);
%figure;
%imshow(maskBW2);

[maskBW3, ~ ] = createMask6(RGB);
%figure;
%imshow(maskBW3);

BW = (maskBW1 | maskBW2 | maskBW3);
%figure;
%imshow(BW);
end