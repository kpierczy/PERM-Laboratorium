function [BW,masked] = lightBlue(RGB)

[BW, ~] = lightBlueMask(RGB);
BW = lightBlueFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

