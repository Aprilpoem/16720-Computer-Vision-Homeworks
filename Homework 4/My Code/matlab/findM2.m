% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       4. Save the correct M2, p1, p2, R and P to q2_5.mat

clc;

%% Initialization

% Load the internal camera calibration matrices K1 and K2
load('../data/intrinsics.mat');

% Load the correspondences
load('../data/some_corresp.mat');

% Load the images
img1 = imread('..\data\im1.png');
img2 = imread('..\data\im2.png');

% Calculate the scaling factor M (the largest size of the images)
M = max([size(img1), size(img2)]);

%% Q 2.3 Compute the essential matrix from fundamental matrix

% Calculate fundamental matrix using 8-point algorithm
F = eightpoint(pts1, pts2, M);

% Compute the essential matrix from the fundamental matrix
E = essentialMatrix(F, K1, K2);

% Print the essential matrix
fprintf('Essential matrix computed from 8-point algorithm is:\n');
disp(E);

%% Q 2.4 and Q 2.5 Calculate the correct projective camera matrices M1 and M2

% Define the projective camera matrix M1
M1 = [eye(3), zeros(3, 1)];

% Calculate the candidate projective camera matrices M2
M2s = camera2(E);

% Multiply the given intrinsics matrices with the canonical camera matrices
M1 = K1 * M1;
for i = 1 : size(M2s, 3)
    M2s(:, :, i) = K2 * squeeze(M2s(:,:,i));
end

% Find the correct M2 from M2s
P = [];
M2 = [];
for i = 1 : size(M2s, 3)
    
    % Obtain the current M2 matrix
    M2_i = squeeze(M2s(:, :, i));
    
    % Perform the triangulation
    [P_i, ~] = triangulate(M1, pts1, M2_i, pts2);

    % Check if all 3D points are in front of the cameras
    if all(P_i(:, 3) > 0)
        P = P_i;
        M2 = M2_i;
    end
    
end

% Save the results
p1 = pts1;
p2 = pts2;
save('../results/q2_5.mat', 'M2', 'p1', 'p2', 'P');
