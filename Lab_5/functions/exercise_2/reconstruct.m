%=============================================================%
% Reconstructs 3D scene basing on calibrated stereo cameras
% and disparity map. Returns also mask for 2D photo that cuts
% 2D photo elements that are in RoI (mask should be used to
% zero cells of the photo i.e. 'photo(~mask) = 0').
%
% @param disparityMap
% @param stereoParams
% @param RoI : region of interests in the result points cloud
%=============================================================%
function [points3D, mask] = reconstruct(disparityMap, stereoParams, RoI)

    % Reconstruct 3D scene
    points3D = reconstructScene(disparityMap, stereoParams);

    % Convert to meters 
    points3D = points3D ./ 1000;
    
    % Get points dimensions
    X = points3D(:, :, 1);
    Y = points3D(:, :, 2);
    Z = points3D(:, :, 3);

    % Threshold points set
    X(X < RoI(1, 1) | X > RoI(1, 2)) = NaN; 
    Y(Y < RoI(2, 1) | Y > RoI(2, 2)) = NaN; 
    Z(Z > RoI(3, 2)) = RoI(3, 2); 
    Z(Z < RoI(3, 1)) = RoI(3, 1); 
    
    % Prepare mask
    maskX = repmat(X >= RoI(1, 1) & X <= RoI(1, 2),[1,1,3]);
    maskY = repmat(Y >= RoI(2, 1) & Y <= RoI(2, 2),[1,1,3]);
    maskZ = repmat(Z >= RoI(3, 1) & Z <= RoI(3, 2),[1,1,3]);

    % Package thresholded point back
    points3D(:,:,1) = X;
    points3D(:,:,2) = Y;
    points3D(:,:,3) = Z;
    
    % Convert masks to single mask
    mask = (maskX & maskY & maskZ);

end

