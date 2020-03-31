clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

videoPath = 'E:/Projects/PERM-Laboratorium/Lab_2/data/pulse.mp4';
numberOfFrames = 300;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get path of the script
[filepath,~,~] = fileparts(mfilename('fullpath'));

% Load video
video = VideoReader(videoPath);

% Convert video to set of photos
i = 1;
while i <= numberOfFrames && video.hasFrame()
    frame = readFrame(video);
    imwrite(frame, strcat(filepath, '../data/images/', num2str(i), '.png'));
    i = i + 1;
end

clear videoPath numberOfFrames filepath video i frame