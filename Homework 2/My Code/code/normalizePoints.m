function [points_norm, T] = normalizePoints(points)
% Normalizes the point coordinates

% Put the origin of the image coordinates on the centroid of the points
origin = mean(points, 2);
points_o = points - repmat(origin, 1, size(points, 2));

% Scale the coordinates so that the average distance of points to origin is
% about sqrt(2)
points_sq = points_o .^ 2;
meandist = sum(sqrt(points_sq(1, :) + points_sq(2, :))) / size(points, 2);
factor = sqrt(2) / meandist;
points_norm = factor * points_o;

% Create the normalization matrix
T = factor * [  1   0   -origin(1)
                0   1   -origin(2)
                0   0   1/factor ];
