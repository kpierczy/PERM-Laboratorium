function [BW,masked] = blue(RGB)

[BW, ~] = blueMask(RGB);
BW = blueFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

