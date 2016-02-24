function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)

% Calculate DoG levels
DoGLevels = levels(2:end);

% Calculate DoG Pyramid
DoGPyramid = GaussianPyramid(:, :, 2:end) - GaussianPyramid(:, :, 1:end-1);
