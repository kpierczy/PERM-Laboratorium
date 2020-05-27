%=================================================
% Creates point cloud with a given matrix of 3D
% points and J colors map.
%
% @param points3D
% @param J
%=================================================
function ptCloud = createPointCloud(points3D, J)

    % Create a pointCloud object
    ptCloud = pointCloud(points3D, 'Color', J);
    
end

