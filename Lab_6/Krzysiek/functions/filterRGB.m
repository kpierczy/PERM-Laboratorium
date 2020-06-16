function [BW, masked] = filterRGB(RGB)

% Gather masks
[   yellowBW, ~] =    yellow(RGB);
[   orangeBW, ~] =    orange(RGB);
[    whiteBW, ~] =     white(RGB);
[      redBW, ~] =       red(RGB);
[     pinkBW, ~] =      pink(RGB);
[lightBlueBW, ~] = lightBlue(RGB);
[     grenBW, ~] =     green(RGB);
[ darkBlueBW, ~] =  darkBlue(RGB);
[     blueBW, ~] =      blue(RGB);

% Create summary mask
BW = yellowBW | orangeBW | whiteBW | redBW | pinkBW | ...
     lightBlueBW | grenBW | darkBlueBW | blueBW;

% Perform filtering
RGB(repmat(~BW, [1 1 3])) = 0;
masked = RGB;

end

