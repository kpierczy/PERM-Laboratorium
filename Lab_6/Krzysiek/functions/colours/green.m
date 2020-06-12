function [BW,masked] = green(RGB)

[BW, ~] = greenMask(RGB);
BW = greenFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

