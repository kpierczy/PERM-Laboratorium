function brightness = movie2brightness(videoPath, numberOfFrames)

% Values of an average brightness of frames
brightness = zeros(numberOfFrames, 1);

% Load video
video = VideoReader(videoPath);

% Compute pictures' brightness
i = 1;
while i <= numberOfFrames && video.hasFrame()
    image = rgb2gray(readFrame(video));
    brightness(i) = mean(image, 'all');
    i = i + 1;
end

% Truncate brightness vector if the movie is shorter
brightness = brightness(1:i-1);

% Remove DC component
brightness = brightness - mean(brightness);

end

