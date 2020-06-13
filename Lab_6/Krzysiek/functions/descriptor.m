function [stats, describedPicture] = descriptor(RGB)

%--------------- Function's parameters --------------------%

% Maximum 'Extent' for the square-like shapes
squareTightnessTolerance = 2.4;

%Maximum 'Eccentricity' for circle-like shapes
circleTightnessTolerance = 1;

% Orientation corner (@see regionprops : Extrema)
orientationCorner = 2;

% Lines widths
lineWidth = 4;

%------------------------ Body ----------------------------%

describedPicture = RGB;

% Filter image to get separated regions
[BW, ~] = filterRGB(RGB);

% Get regions' statistics
% - Centroid : coordinates of the region's mass center
% - Area : area of the region
% - Peimteter : region's perimeter
% - Extrema : set 8 extreamal  points in the tegion
% - BoundingBox : smallest box bounding the region
regionsStats = regionprops(BW, 'Centroid', 'Area', 'Perimeter', 'Extrema', 'BoundingBox');


% Preallocate structure
fields = {'origin', 'colour', 'shape', 'size' 'area'};
c = cell(length(fields), size(regionsStats, 1));
stats = cell2struct(c, fields);

% Iterate over all regions
for regionNum = 1:size(regionsStats, 1)
    
    %------------------ Position ---------------------%
    
    % Register object's mass center
    stats(regionNum).origin = regionsStats(regionNum).Centroid;

    %------------------ Colour ---------------------%
    
    % Cut the region from the image
    region = RGB( ...
        round(                                           ...
            regionsStats(regionNum).BoundingBox(1, 2)) : ... 
        round(                                           ...
            regionsStats(regionNum).BoundingBox(1, 2) +  ...
            regionsStats(regionNum).BoundingBox(1, 4)),  ...
        round(                                           ...
            regionsStats(regionNum).BoundingBox(1, 1)) : ... 
        round(                                           ...
            regionsStats(regionNum).BoundingBox(1, 1) +  ...
            regionsStats(regionNum).BoundingBox(1, 3)),  ...
        :                                                ...
    );

    % Transform region to the hsv space
    region = rgb2hsv(region);
    % Compute mean colour
    hue = mode(region(:, :, 1) * 360, 'all');
    sat = mode(region(:, :, 2), 'all');
    % Classify colour
    if sat < 0.2
        stats(regionNum).colour = 'white';
    elseif hue <= 60
        stats(regionNum).colour = 'red';
    elseif hue <= 120
        stats(regionNum).colour = 'yellow';
    elseif hue <= 180
        stats(regionNum).colour = 'green';
    elseif hue <= 240
        stats(regionNum).colour = 'cyan';
    elseif hue <= 300
        stats(regionNum).colour = 'blue';
    else
        stats(regionNum).colour = 'magenta';
    end
    
    % Compute region's tightness
    thightness = ( regionsStats(regionNum).Perimeter ^ 2) / ...
                   regionsStats(regionNum).Area;
    
   %------------------ Shape ---------------------%
               
    % Recognize region's shape
    if abs(thightness - 16) <  squareTightnessTolerance
        
        stats(regionNum).shape = 'Square';
        
        %------------------ Size ---------------------%
        
        stats(regionNum).size  = sqrt(regionsStats(regionNum).Area);
        stats(regionNum).area  = regionsStats(regionNum).Area; 
        
        %-------------- Orientation ------------------%
        
        % For square objects define non-zero orientation vector
        stats(regionNum).orientation = ...
            regionsStats(regionNum).Extrema(orientationCorner, :);
        
    elseif abs(thightness - 12.6) <  circleTightnessTolerance
        
        stats(regionNum).shape = 'Circle';
        
        %------------------ Size ---------------------%
        
        stats(regionNum).size  = 2 * sqrt(regionsStats(regionNum).Area / pi);
        stats(regionNum).area  = regionsStats(regionNum).Area;
        
        %-------------- Orientation ------------------%
        
        % For circular objects define zero orientation vector
        stats(regionNum).orientation = regionsStats(regionNum).Centroid;
        
    else
        
        stats(regionNum).shape = 'Other';
        
        %------------------ Size ---------------------%
        
        stats(regionNum).size  = 0;
        stats(regionNum).area  = regionsStats(regionNum).Area;
        
        %-------------- Orientation ------------------%
        
        % For other objects define zero orientation vector
        stats(regionNum).orientation = regionsStats(regionNum).Centroid;
        
    end
    
   
    % Draw shape that approximates region's shape
    if strcmp(stats(regionNum).shape, 'Square')
        
        topRight = stats(regionNum).origin - ...
                   stats(regionNum).orientation;
        topLeft  = [      ...
             topRight(2), ...
           - topRight(1)  ...
        ];
        bottomLeft  = [   ...
           - topRight(1), ...
           - topRight(2)  ...
        ];
        bottomRight  = [  ...
           - topRight(2), ...
             topRight(1)  ...
        ];
    
        describedPicture = insertShape(describedPicture, ...
            'Polygon',                                   ...
            [ stats(regionNum).origin + topRight,        ...
              stats(regionNum).origin + topLeft,         ...
              stats(regionNum).origin + bottomLeft,      ...
              stats(regionNum).origin + bottomRight      ...
            ],                                           ...
            'Color', stats(regionNum).colour,            ...
            'LineWidth', lineWidth                       ...
        );
    
        % Draw orientation line
        describedPicture = insertShape(describedPicture, ...
            'Line',                                      ...
            [ stats(regionNum).origin,                   ...
              stats(regionNum).orientation               ...
            ],                                           ...
            'Color', stats(regionNum).colour,            ...
            'LineWidth', lineWidth                       ...
        );
    
    elseif strcmp(stats(regionNum).shape, 'Circle')
        
        describedPicture = insertShape(describedPicture, ...
            'Circle',                                    ...
            [ stats(regionNum).origin,                   ...
              stats(regionNum).size / 2                  ...
            ],                                           ...
            'Color', stats(regionNum).colour,            ...
            'LineWidth', lineWidth                       ...
        );
    
    end
    
end
end

