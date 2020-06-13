function [BW,masked] = orange(RGB)

[BW, ~] = orangeMask(RGB);
BW = orangeFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

