function [BW,masked] = yellow(RGB)

[BW, ~] = yellowMask(RGB);
BW = yellowFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

