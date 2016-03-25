function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas
%

%% Initialization

% The total number of point pairs
N = size(p1, 1);

% Initialize the set of 3D points
P = zeros(N, 3);

%% Perform triangulation using homogeneous method (DLT)
% For more information refer to Section 12.2 of 'Multiple View Geometry in
% Computer Vision (2nd Edition)' by Richard Hartley and Andrew Zisserman
for i = 1 : N
    
    % Create the 4x4 matrix A for AP = 0
    A = [  p1(i, 1) * M1(3,:) - M1(1,:)
            p1(i, 2) * M1(3,:) - M1(2,:)
            p2(i, 1) * M2(3,:) - M2(1,:)
            p2(i, 2) * M2(3,:) - M2(2,:)     ];

    % Calculate 3D point P
    [~, ~, V] = svd(A);
    P(i, :) = V(1 : 3, end)' / V(4, end);

end

%% Calculate the reprojection error

% Create homogeneous 3D points
P_hmg = [P, ones(N, 1)]';

% Calculate the reprojections
p1_hat = (M1 * P_hmg)';
p1_hat = p1_hat(:, 1 : 2) ./ repmat(p1_hat(:, 3), 1, 2);

p2_hat = (M2 * P_hmg)';
p2_hat = p2_hat(:, 1 : 2) ./ repmat(p2_hat(:, 3), 1, 2);

% Calculate the error
error = sum((p1(:) - p1_hat(:)).^2 + (p2(:) - p2_hat(:)).^2);

end
