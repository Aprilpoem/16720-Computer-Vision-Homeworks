clc;

%% Initialization 

% Load the images
img1 = imread('..\data\im1.png');
img2 = imread('..\data\im2.png');

% Calculate the scaling factor M (the largest size of the images)
M = max([size(img1), size(img2)]);

%% Q 2.1 Test the 8-point algorithm

% Load the correspondences
load('..\data\some_corresp.mat');

% Calculate fundamental matrix using 8-point algorithm
F = eightpoint(pts1, pts2, M);

% Print the fundamental matrix
fprintf('F estimated using the 8-point algorithm is:\n');
disp(F);

% Save the results
save('../results/q2_1.mat', 'F', 'M', 'pts1', 'pts2');

% Display the interactive epipolar line GUI
% displayEpipolarF(img1, img2, F);

%% Q 2.2 Test the 7-point algorithm

% Select 7 correspondences (the points are manually selected using the 
% cpselect tool. Comment the points if you are using the cpselect tool and 
% uncomment the following line)

% cpselect(img1, img2);

pts1 = [
   240   160
   425   224
   292   289
   137   293
    53   183
   523   232
   401   341 ];

pts2 = [
  238.0000  157.5000
  423.0000  202.5000
  294.0000  285.5000
  139.0000  282.5000
   53.0000  178.5000
  520.0000  186.5000
  406.0000  350.5000 ];

% Calculate fundamental matrix using 7-point algorithm
F = sevenpoint(pts1, pts2, M);

% Print the fundamental matrices
for i = 1 : numel(F)
    fprintf('F%d estimated using the 7-point algorithm is:\n', i);
    disp(F{i});
end

% Save the results
save('../results/q2_2.mat', 'F', 'M', 'pts1', 'pts2');

% Display the interactive epipolar line GUI
% displayEpipolarF(img1, img2, F{1});
% displayEpipolarF(img1, img2, F{2});
% displayEpipolarF(img1, img2, F{3});

%% Q 2.X Test the Automatic Computation of F using RANSAC

% Load the noisy correspondences with 75% inliers
load('..\data\some_corresp_noisy.mat');

% Print the fundamental matrix
fprintf('Starting estimation of fundamental matrix using RANSAC...\n');

% Calculate the fundamental matrix using 7-point algorithm with RANSAC
F = ransacF(pts1, pts2, M);

% Print the fundamental matrix
fprintf('F estimated using RANSAC is:\n');
disp(F);

% Save the results
save('../results/q2_X.mat', 'F', 'M', 'pts1', 'pts2');

% Display the interactive epipolar line GUI
displayEpipolarF(img1, img2, F);
