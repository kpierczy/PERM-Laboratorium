function [BW,masked] = pink(RGB)

[BW, ~] = pinkMask(RGB);
BW = pinkFilter(RGB, BW);
masked = RGB;
masked(repmat(~BW, [1 1 3])) = 0;

end

