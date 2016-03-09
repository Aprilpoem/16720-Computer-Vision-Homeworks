function [locs, desc] = briefLite(im)

% Initialize parameters
sigma0 = 1;
k = sqrt(2);
levels = -1 : 4;
th_contrast = 0.03;
th_r = 12;

% Load parameters
load('testPattern');

% Calculate keypoints locations
[locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, ...
    th_contrast, th_r);

% Compute a set of valid BRIEF descriptors
[locs, desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, ...
    compareX, compareY);
