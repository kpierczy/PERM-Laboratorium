close all

dataSetLeft = dir('auvsi-cv-stereoVision/exercises/media/RecordedImages/left')
dataSetRight = dir('auvsi-cv-stereoVision/exercises/media/RecordedImages/right')

sizeLeft = size(dataSetLeft);
sizeRight = size(dataSetRight);

% assuming equal count of images
num = 10


for i = 14 : 1 : 14
    frameLeftDir = dataSetLeft(i);
    frameRightDir = dataSetRight(i);
    
    frameLeft = imread(strcat(frameLeftDir.folder(),'\', frameLeftDir.name()));
    frameRight = imread(strcat(frameRightDir.folder(),'\', frameRightDir.name()));
    
    [frameLeftRect, frameRightRect] = ...
        rectifyStereoImages(frameLeft, frameRight, stereoParams);
    
    %figure
    imshow(stereoAnaglyph(frameLeftRect(361:560,636:935,:), frameRightRect(361:560,636:935,:)));
    
    frameLeftGray  = rgb2gray(frameLeftRect);
    frameRightGray = rgb2gray(frameRightRect);

    disparityMap = disparitySGM(frameLeftGray, frameRightGray, 'DisparityRange', [33 121]);
    
    %disparityMap = disparityMap(361:560,636:935)
%     figure;
%     imshow(disparityMap(361:560,636:935), [0, 128]);
%     title('Disparity Map');
%     colormap jet
%     colorbar
    
    points3D = reconstructScene(disparityMap, stereoParams);
    

    % Convert to meters and create a pointCloud object
    points3D = points3D ./ 1000;
    nnz(points3D(:,:,3))
    thresholds=[-2.5 1.5;0 6;5 50];  %-3 3 0 6 7 30
    points3D = thresholdPC(points3D,thresholds);
    nnz(points3D(:,:,3))
    %ptCloud = pointCloud(points3D, 'Color', frameLeftRect);
    %ptCloud = pointCloud(ptCloud.Location(361:560,:,:),'Color', ptCloud.Color(361:560,:,:));

    loc = points3D;
    z  = loc(361:560,636:935,3);
    y1  = loc(361:560,636:935,2);
    x1  = loc(361:560,636:935,1);
    nnz(~isnan(z))
    
    z(isnan(z)) = 0; % get rid of nans
    z(z == Inf) = 0; % get rid of Infs
    h = size(z,1);
    w = size(z,2);
    nnz(points3D(:,:,3))
    
    for x = 2 : 1 : w - 1
        for y = 1 : 1 : h
            if z(y,x) == 0
                if z(y,x-1) ~= 0 & z(y,x+1) ~= 0
                    z(y,x) = ( z(y,x-1) + z(y,x+1))/2;
                end
            end
        end
    end
    nnz(points3D(:,:,3))
    
    for x = 1 : 1 : w 
        for y = 2 : 1 : h - 1
            if z(y,x) == 0
                if z(y - 1,x) ~= 0 & z(y + 1,x) ~= 0
                    z(y,x) = ( z(y - 1,x) + z(y + 1,x))/2;
                end
            end
        end
    end
    nnz(points3D(:,:,3))
    
    z(z < 6) = 0;
    nnz(points3D(:,:,3))
    
    J = integralImage(z);
    
    carDetected = [];
    
    for sizeCarX = 50 : -1 : 10
        %sizeCarX = 0
        sizeCarY = 1;

        distanceCar = 1450 / sizeCarX; 
        areaCar = sizeCarX * sizeCarY * distanceCar;

        for x = 1 : sizeCarX : w - sizeCarX
            for y = 1 : sizeCarY : h - sizeCarY
                topLeft = J(y,x);
                topRight = J(y, x + sizeCarX);
                bottomLeft = J(y + sizeCarY, x);
                bottomRight = J(y + sizeCarY, x + sizeCarX);

                regionSum = topLeft - topRight + bottomRight - bottomLeft;

                if regionSum > 0.80 * areaCar && regionSum < 1.2 * areaCar
                    if find(z(y:y+sizeCarY,x:x+sizeCarX) == 0) <2
                        carDetected = [carDetected; [x,y, sizeCarX, sizeCarY, distanceCar]];
                    end
                end
            end
        end
    end
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