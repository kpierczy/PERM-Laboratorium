clear

% Cubes' size [px]
heigth = 140;
width = 140;

% Read base image
im = imread('data/img/ex_4.jpg');

% Get regions statistics
[stats, ~] = descriptor(im);

% Preallocate structure to hold saved spectrograms
dictionary = containers.Map;

% Loop over all regions to parse, label and save spectografs of characters
for i = 1:size(stats, 1)
    
    % Crop image
    crop = imcrop(im, [stats(i).origin - [width / 2 heigth / 2], ...
                       width, heigth]);
                   
   % Equalize histogram to extract edges
    smoothCrop = adapthisteq(rgb2gray(crop));
    
    % Get image edges
    edges = edge(smoothCrop);
    
    % Perform series of morphological operations to get rid of trash
    radius = 5;
    decomposition = 0;
    se = strel('diamond', radius);
    sd = strel('disk', radius, decomposition);
    edges = imclose(edges, sd);
    edges = imdilate(edges, sd);
    edges = imfill(edges, 'holes');
    edges = imerode(edges, sd);
    edges = imerode(edges, sd);
    edges = imdilate(edges, sd);
    
    % Crop image to the character's bounding box
    regionStats = regionprops(edges, 'Centroid', 'Area', 'BoundingBox');
    maxArea = 0;
    maxAreaIndex = 1;
    for j=1:size(regionStats,1)
        if regionStats(j).Area > maxArea
           maxArea = regionStats(j).Area;
           maxAreaIndex = j;
        end
    end
    object = imcrop(edges, regionStats(maxAreaIndex).BoundingBox);
    
    % Return to the initial cube's size
    filteredIm = zeros(heigth, width);
    filteredIm( ...
        round((heigth - size(object, 1)) / 2) : ...
        round((heigth - size(object, 1)) / 2) + size(object, 1) - 1 , ...
        round((width - size(object, 2)) / 2) : ...
        round((width - size(object, 2)) / 2) + size(object, 2) - 1 ...
    ) = object;
    
    % Print fourier spectrum
    spectrum = fourierSpectrum(filteredIm);
    
    % Get image label
    label = input("Pass image's label (if not recogised, just press ENTER): ");
    if size(label, 1) ~= 0
        if isKey(dictionary, label)
            tmp = dictionary(label);
            tmp{end+1} = spectrum;
            dictionary(label) = tmp;
        else
            dictionary(label) = {spectrum};
        end
    end
end

clearvars -except dictionary