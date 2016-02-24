function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% Maps p2 to p1

%% Set default values for input parameters nIter and tol
if ~exist('nIter', 'var') || isempty(nIter)
    nIter = 500;
end

if ~exist('tol', 'var') || isempty(tol)
    tol = 5;
end

%% Initialization
% Find the location of all matches
p1 = locs1(matches(:, 1), 1:2);
p2 = locs2(matches(:, 2), 1:2);

% Initialize RANSAC-specific variables
bestInliers = [];

%% Perform RANSAC iterations
for i = 1 : nIter
    % Pick 4 random corresponding points
    points = randperm(size(matches, 1), 4);
    prand1 = locs1(matches(points, 1), 1:2);
    prand2 = locs2(matches(points, 2), 1:2);
    
    % Calculate homography for the 4 points
    H = computeH(prand1', prand2');
    
    % Perform calculated homography matrix on all points in second set
    Hp2 = H * [p2'; ones(1, size(p2, 1))];
    Hp2 = (Hp2 ./ repmat(Hp2(3, :), 3, 1))';
    
    % Find inliers
    inliers = (p1(:, 1) - Hp2(:, 1)).^2 + (p1(:, 2) - Hp2(:, 2)).^2 < tol^2;
    if nnz(inliers) > nnz(bestInliers)
        bestInliers = inliers;
        % bestH = H;
    end
end

% Calculate Homography (H2to1) matrix for inliers
p1 = p1(bestInliers, :);
p2 = p2(bestInliers, :);
bestH = computeH(p1', p2');
