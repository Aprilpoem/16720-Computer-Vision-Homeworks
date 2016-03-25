clc;

%% Load the images
img1 = imread('..\data\im1.png');
img2 = imread('..\data\im2.png');

%% Calculate fundamental matrix

% Load some correspondences
load('../data/some_corresp.mat');

% Calculate the scaling factor M (the largest size of the images)
M = max([size(img1), size(img2)]);

% Calculate fundamental matrix using 8-point algorithm
F = eightpoint(pts1, pts2, M);

%% Load the internal camera calibration matrices K1 and K2
load('../data/intrinsics.mat');

%% Q 2.7 Perform 3D Visualization

% Load the points in the first image
load('..\data\templeCoords.mat');

% Allocate space for the result points
x2 = zeros(size(x1));
y2 = zeros(size(y1));

for i = 1 : length(x1)
    % Calculate corresponding points on the second image
    [x2(i), y2(i)] = epipolarCorrespondence(img1, img2, F, x1(i), y1(i));
end

% Calculate correct projective camera matrices
[M1, M2, P] = computeProjectiveMatrices(F, K1, K2, [x1 y1], [x2 y2]);

% Save the results
save('q2_7.mat', 'F', 'M1', 'M2');

% 3D Visualization
scatter3(P(:, 1), P(:, 2), P(:, 3));
