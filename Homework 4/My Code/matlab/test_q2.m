clc;

%% Initialization 

% Load the images
img1 = imread('..\data\im1.png');
img2 = imread('..\data\im2.png');

% Calculate the scaling factor M (the largest size of the images)
M = max(max(size(img1), size(img2)));

%% Q 2.1 Test the 8-point algorithm

% Load the correspondences
load('..\data\some_corresp.mat');

% Calculate fundamental matrix using 8-point algorithm
F = eightpoint(pts1, pts2, M);

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

% Save the results
save('../results/q2_2.mat', 'F', 'M', 'pts1', 'pts2');

% Display the interactive epipolar line GUI
FundMatNumber = 3;
displayEpipolarF(img1, img2, F{FundMatNumber});

roots




% load('..\data\some_corresp_noisy.mat');
% Fnoisy = eightpoint_norm(pts1, pts2, M);
% displayEpipolarF(img1,img2,Fnoisy);
