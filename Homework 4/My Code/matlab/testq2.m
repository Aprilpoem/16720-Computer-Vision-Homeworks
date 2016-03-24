clc;

%% Load the images
img1 = imread('..\data\im1.png');
img2 = imread('..\data\im2.png');

%% Q 2.1 Test the 8-point algorithm

% Calculate the scaling factor M (the largest size of the images)
M = max(max(size(img1), size(img2)));

% Load the correspondences
load('..\data\some_corresp.mat');

% Calculate fundamental matrix using 8-point algorithm
F = eightpoint(pts1, pts2, M);

% Save the results
save('../results/q2_1.mat', 'F', 'M', 'pts1', 'pts2');

% Display the interactive epipolar line GUI
% displayEpipolarF(img1, img2, F);

% load('..\data\some_corresp_noisy.mat');
% Fnoisy = eightpoint_norm(pts1, pts2, M);
% displayEpipolarF(img1,img2,Fnoisy);
