close all

% Read dataSet directories
dataSetLeft = dir('auvsi-cv-stereoVision/exercises/media/RecordedImages/left');
dataSetRight = dir('auvsi-cv-stereoVision/exercises/media/RecordedImages/right');

sizeLeft = size(dataSetLeft);
sizeRight = size(dataSetRight);

% assuming equal count of images
num = 10


for i = 7 : 1 : 183
    % Load image for further computation
    frameLeftDir = dataSetLeft(i);
    frameRightDir = dataSetRight(i);
    
    frameLeft = imread(strcat(frameLeftDir.folder(),'\', frameLeftDir.name()));
    frameRight = imread(strcat(frameRightDir.folder(),'\', frameRightDir.name()));
    
    % Clear, allign frames
    [frameLeftRect, frameRightRect] = ...
        rectifyStereoImages(frameLeft, frameRight, stereoParams);
    
    % Show cropped image

    
    frameLeftGray  = rgb2gray(frameLeftRect);
    frameRightGray = rgb2gray(frameRightRect);
    
    % Create disparity map
    disparityMap = disparitySGM(frameLeftGray, frameRightGray, 'DisparityRange', [0 96]);
    
    
    points3D = reconstructScene(disparityMap, stereoParams);
    

    % Convert to meters and create a pointCloud object
    points3D = points3D ./ 1000;

    thresholds=[-2.5 1.5;2 6;7 50];  %-3 3 0 6 7 30
    points3D = thresholdPC(points3D,thresholds);
    %ptCloud = pointCloud(points3D, 'Color', frameLeftRect);
    %ptCloud = pointCloud(ptCloud.Location(361:560,:,:),'Color', ptCloud.Color(361:560,:,:));

    loc = points3D;
    z  = loc(361:560,636:935,3);
    y1  = loc(361:560,636:935,2);
    x1  = loc(361:560,636:935,1);
    
    z(isnan(z)) = 0; % get rid of nans
    z(z == Inf) = 0; % get rid of Infs
    h = size(z,1);
    w = size(z,2);
    
    for x = 2 : 1 : w - 1
        for y = 1 : 1 : h
            if z(y,x) == 0
                if z(y,x-1) ~= 0 & z(y,x+1) ~= 0
                    z(y,x) = ( z(y,x-1) + z(y,x+1))/2;
                end
            end
        end
    end

    
    for x = 1 : 1 : w 
        for y = 2 : 1 : h - 1
            if z(y,x) == 0
                if z(y - 1,x) ~= 0 & z(y + 1,x) ~= 0
                    z(y,x) = ( z(y - 1,x) + z(y + 1,x))/2;
                end
            end
        end
    end
    
    z(z < 6) = 0;
    
    J = integralImage(z);
    
    carDetected = [];
    
    
    
    for sizeCarX = 90 : -1 : 15
        %sizeCarX = 0
        sizeCarY = 10 + floor(sizeCarX/10) ;

        distanceCar = 1300 / sizeCarX; 
        areaCar = sizeCarX * sizeCarY * distanceCar;

        for x = 1 : sizeCarX : w - sizeCarX
            for y = 1 : sizeCarY : h - sizeCarY
                topLeft = J(y,x);
                topRight = J(y, x + sizeCarX);
                bottomLeft = J(y + sizeCarY, x);
                bottomRight = J(y + sizeCarY, x + sizeCarX);

                regionSum = topLeft - topRight + bottomRight - bottomLeft;

                if regionSum > 0.7 * areaCar && regionSum < 1.3 * areaCar
                    if size(find(z(y:y+sizeCarY,x:x+sizeCarX) == 0) ,1) == 0
                        dist = min(z(y:y+sizeCarY,x:x+sizeCarX), [], 'all');
                        carDetected = [carDetected; [x,y, sizeCarX, sizeCarY, dist]];
                    end
                end
            end
        end
    end
% Code as above with vertical Vectors
%     for sizeCarY = 50 : -1 : 20
%         %sizeCarX = 0
%         sizeCarX = 2;
% 
%         distanceCar = 1300 / sizeCarX; 
%         areaCar = sizeCarX * sizeCarY * distanceCar;
% 
%         for x = 1 : sizeCarX : w - sizeCarX
%             for y = 1 : sizeCarY : h - sizeCarY
%                 topLeft = J(y,x);
%                 topRight = J(y, x + sizeCarX);
%                 bottomLeft = J(y + sizeCarY, x);
%                 bottomRight = J(y + sizeCarY, x + sizeCarX);
% 
%                 regionSum = topLeft - topRight + bottomRight - bottomLeft;
% 
%                 if regionSum > 0.98 * areaCar & regionSum < 1.02 * areaCar
%                     carDetected = [carDetected; [x,y, sizeCarX, sizeCarY, distanceCar]];
%                 end
%             end
%         end
%     end
    
 
    figure
    imshow(stereoAnaglyph(frameLeftRect(361:560,636:935,:), frameRightRect(361:560,636:935,:)));
    if size(carDetected,1) > 0
        croppedCarDetected = [carDetected(:,1:4) floor(carDetected(:,5))];
        [C, ia, ic] = unique(croppedCarDetected(:,5), 'first');
    
    

        for i = 1 : 1 : size(ia,1)
            rectangle('Position', croppedCarDetected(ia(i),1:4),...
                        'EdgeColor','r', 'LineWidth', 1)
            text(double(croppedCarDetected(ia(i),1:1) - 10), ...
                    double(croppedCarDetected(ia(i),2:2) -20), ...
                    strcat(num2str(carDetected(i,5:5)), 'm'), ...
                    'Color', 'Red');
        end
    end
    
    name = frameLeftDir.name();
    name = name(1:end-4);
    savePlot(strcat('detection/',name));

    
    drawnow
        
                
            
            
    
    
    


    % Create a streaming point cloud viewer
    %player3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
    %    'VerticalAxisDir', 'down');

    % Visualize the point cloud
    %view(player3D, ptCloud);
    
end