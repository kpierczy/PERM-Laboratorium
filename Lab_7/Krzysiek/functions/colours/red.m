function [BW,masked] = red(RGB)

[BW, ~] = redMask(RGB);
BW = redFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

