function [stereoParams] = loadParams(scriptName)
    
    % Check if camera was calibrated
    if strcmp(scriptName, 'filenames_mathworks')
        if exist('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_2\stereoParams.mat', 'file')
            load('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_2\stereoParams.mat');
        % If wasn't, calibrate
        else
            run(scriptName);
            stereoParams = calibration(imageFileNames1,imageFileNames2);
            stereoParams.CameraParameters1.ImageSize = [];
            stereoParams.CameraParameters2.ImageSize = [];
            clearvars -except stereoParams
            save('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_2\stereoParams.mat');
        end    
    elseif strcmp(scriptName, 'filenames')
        if exist('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_1\stereoParams.mat', 'file')
            load('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_1\stereoParams.mat');
        % If wasn't, calibrate
        else
            run(scriptName);
            stereoParams = calibration(imageFileNames1,imageFileNames2);
            stereoParams.CameraParameters1.ImageSize = [];
            stereoParams.CameraParameters2.ImageSize = [];
            clearvars -except stereoParams
            save('E:\Projects\PERM-Laboratorium\Lab_5\matlab\data\exercise_1\stereoParams.mat');
        end
    end
    

end

