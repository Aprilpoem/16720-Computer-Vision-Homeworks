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

% Calculate correct projective camera matrices and find 3D points P
% corresponding to the point pairs
[M1, M2, P] = computeProjectiveMatrices(F, K1, K2, pts1, pts2);

% Save the results
p1 = pts1;
p2 = pts2;
save('../results/q2_5.mat', 'M2', 'p1', 'p2', 'P');
