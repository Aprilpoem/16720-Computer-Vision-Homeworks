function [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, ...
    th_contrast, th_r)

% Calculate the Gaussian Pyramid
GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);

% Calculate DoG Pyramid
[DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);

% Calculate Principal Curvature
PrincipalCurvature = computePrincipalCurvature(DoGPyramid);

% Calculate DoG extremum points
locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, ...
    th_contrast, th_r);

% % Plot detected DoG keypoints (i.e. extremums)
% imshow(im); 
% hold on
% plot(locsDoG(:, 1), locsDoG(:, 2), '.g');
% hold off