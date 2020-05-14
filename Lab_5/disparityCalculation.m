close all

dataSetLeft = dir('auvsi-cv-stereoVision/exercises/media/RecordedImages/left')
dataSetRight = dir('auvsi-cv-stereoVision/exercises/media/RecordedImages/right')

sizeLeft = size(dataSetLeft);
sizeRight = size(dataSetRight);

% assuming equal count of images
num = 8


for i = 3 : 1 : 183
    frameLeftDir = dataSetLeft(i)
    frameRightDir = dataSetRight(i)
    
    frameLeft = imread(strcat(frameLeftDir.folder(),'\', frameLeftDir.name()));
    frameRight = imread(strcat(frameRightDir.folder(),'\', frameRightDir.name()));
    
    [frameLeftRect, frameRightRect] = ...
        rectifyStereoImages(frameLeft, frameRight, stereoParams);
    
    %figure
    imshow(stereoAnaglyph(frameLeftRect(361:560,636:935,:), frameRightRect(361:560,636:935,:)));
    
    frameLeftGray  = rgb2gray(frameLeftRect);
    frameRightGray = rgb2gray(frameRightRect);

    disparityMap = disparitySGM(frameLeftGray, frameRightGray, 'DisparityRange', [0 96]);
    
    %disparityMap = disparityMap(361:560,636:935)
%     figure;
%     imshow(disparityMap(361:560,636:935), [0, 128]);
%     title('Disparity Map');
%     colormap jet
%     colorbar
    
    points3D = reconstructScene(disparityMap, stereoParams);
    

    % Convert to meters and create a pointCloud object
    points3D = points3D ./ 1000;
    thresholds=[-2.5 1.5;0 6;7 30];  %-3 3 0 6 7 30
    points3D = thresholdPC(points3D,thresholds);
    ptCloud = pointCloud(points3D, 'Color', frameLeftRect);
    ptCloud = pointCloud(ptCloud.Location(361:560,636:935,:),'Color', ptCloud.Color(361:560,636:935,:));

    loc = ptCloud.Location();
    z  = loc(:,:,3);
    y  = loc(:,:,2);
    x  = loc(:,:,1);
    nnz(~isnan(z));
    
    z(isnan(z)) = 1000; % get rid of nans
    z(z == Inf) = 1000; % get rid of Infs
    h = size(z,1);
    w = size(z,2);
    
    for x = 2 : 1 : w - 1
        for y = 1 : 1 : h
            if z(y,x) == 1000
                if z(y,x-1) ~= 1000 & z(y,x+1) ~= 1000
                    z(y,x) = ( z(y,x-1) + z(y,x+1))/2;
                end
            end
        end
    end
    
    for x = 1 : 1 : w 
        for y = 2 : 1 : h - 1
            if z(y,x) == 1000
                if z(y - 1,x) ~= 1000 & z(y + 1,x) ~= 1000
                    z(y,x) = ( z(y - 1,x) + z(y + 1,x))/2;
                end
            end
        end
    end
    
    J = integralImage(z);
    
    carDetected = [];
    
    for sizeCarX = 100 : -1 : 20
        %sizeCarX = 0
        sizeCarY = 3;

        distanceCar = 1300 / sizeCarX; 
        areaCar = sizeCarX * sizeCarY * distanceCar;

        for x = 1 : sizeCarX : w - sizeCarX
            for y = 1 : sizeCarY : h - sizeCarY
                topLeft = J(y,x);
                topRight = J(y, x + sizeCarX);
                bottomLeft = J(y + sizeCarY, x);
                bottomRight = J(y + sizeCarY, x + sizeCarX);

                regionSum = topLeft - topRight + bottomRight - bottomLeft;

                if regionSum > 0.98 * areaCar & regionSum < 1.02 * areaCar
                    carDetected = [carDetected; [x,y, sizeCarX, sizeCarY, distanceCar]];
                end
            end
        end
    end
        for sizeCarY = 40 : -1 : 20
        %sizeCarX = 0
        sizeCarX = 10;

        distanceCar = 1300 / sizeCarX; 
        areaCar = sizeCarX * sizeCarY * distanceCar;

        for x = 1 : sizeCarX : w - sizeCarX
            for y = 1 : sizeCarY : h - sizeCarY
                topLeft = J(y,x);
                topRight = J(y, x + sizeCarX);
                bottomLeft = J(y + sizeCarY, x);
                bottomRight = J(y + sizeCarY, x + sizeCarX);

                regionSum = topLeft - topRight + bottomRight - bottomLeft;

                if regionSum > 0.98 * areaCar & regionSum < 1.02 * areaCar
                    carDetected = [carDetected; [x,y, sizeCarX, sizeCarY, distanceCar]];
                end
            end
        end
    end
    hold on
    for i = 1 : 1 : size(carDetected,1)
        rectangle('Position', carDetected(i,1:4),...
                    'EdgeColor','r', 'LineWidth', 1)
    end
    drawnow
        
                
            
            
    
    
    


    % Create a streaming point cloud viewer
    %player3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
    %    'VerticalAxisDir', 'down');

    % Visualize the point cloud
    %view(player3D, ptCloud);
    
end