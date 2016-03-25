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

%% Q 2.6 Epipolar Correspondences

% Call the epipolar match GUI
[pts1, pts2] = epipolarMatchGUI(img1, img2, F);

% Save the results
save('../results/q2_6.mat', 'F', 'pts1', 'pts2');
