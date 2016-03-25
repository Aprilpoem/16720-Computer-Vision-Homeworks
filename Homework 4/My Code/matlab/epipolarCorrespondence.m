function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup

%% Calculate epipolar line corresponding to input point
epiline = F * [x1, y1, 1]';
epiline = epiline / norm(epiline);

%% Define search parameters

% Define the radius around the pixel considered in the neighbourhood
SearchRadius = 5;

% Define the pixel weights
PixelWeights = fspecial('gaussian', ...
    [2 * SearchRadius + 1, 2 * SearchRadius + 1], SearchRadius / 2);

% Define the maximum euclidean distance for the match point coordinates in 
% the two images
MaxDistance = 50;

%% Calculate search region using both x and y directions

% Find points in the image on the line using the x direction
lx1 = 1 : size(im2, 2);
ly1 = round(-(epiline(1) * lx1 + epiline(3)) / epiline(2));

% Find the valid points
ValidPoints1 = lx1 - SearchRadius > 0 & lx1 + SearchRadius <= size(im2, 2) ...
    & ly1 - SearchRadius > 0 & ly1 + SearchRadius <= size(im2, 1);

% Find points in the image on the line using the y direction
ly2 = 1 : size(im1, 2);
lx2 = round(-(epiline(2) * ly2 + epiline(3)) / epiline(1));

% Find the valid points
ValidPoints2 = lx2 - SearchRadius > 0 & lx2 + SearchRadius <= size(im2, 2) ...
    & ly2 - SearchRadius > 0 & ly2 + SearchRadius <= size(im2, 1);

% Choose between the point sets
lx = lx1;
ly = ly1;
ValidPoints = ValidPoints1;

if nnz(ValidPoints1) < nnz(ValidPoints2)
    lx = lx2;
    ly = ly2;
    ValidPoints = ValidPoints2;
end
ValidPoints = find(ValidPoints);

%% Calculate the patch on the first image
patch1 = double(im1((y1 - SearchRadius) : (y1 + SearchRadius), ...
    (x1 - SearchRadius) : (x1 + SearchRadius)));

%% Find the best match
Error = inf;
Match = 0;
for i = ValidPoints
    
    % Check if the distance of the point from the point on the first image
    % is less than expected
    if (x1 - lx(i))^2 + (y1 - ly(i))^2 > MaxDistance^2
        continue;
    end
    
    % Calculate the patch on the first image
    patch2 = double(im2((ly(i) - SearchRadius) : (ly(i) + SearchRadius), ...
        (lx(i) - SearchRadius) : (lx(i) + SearchRadius)));
    
    % Calculate the weighted Manhattan distance of two patches
    error = abs(patch1 - patch2) .* PixelWeights;
    error = sum(error(:));
    
    if Error > error
        Error = error;
        Match = i;
    end
end

% Return the results
x2 = lx(Match);
y2 = ly(Match);
