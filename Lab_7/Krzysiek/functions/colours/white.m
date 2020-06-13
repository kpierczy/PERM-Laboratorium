function [BW,masked] = white(RGB)

[BW, ~] = whiteMask(RGB);
BW = whiteFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

