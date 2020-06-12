function [BW,masked] = darkBlue(RGB)

[BW, ~] = darkBlueMask(RGB);
BW = darkBlueFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

