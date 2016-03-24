function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

%% Scale the data by factor M
pts1 = pts1 / M;
pts2 = pts2 / M;

%% Generate the matrices A and B in AF = B
A = [pts1(:, 1) .* pts2(:, 1), pts1(:, 1) .* pts2(:, 2), pts1(:, 1), ...
     pts1(:, 2) .* pts2(:, 1), pts1(:, 2) .* pts2(:, 2), pts1(:, 2), ...
     pts2(:, 1), pts2(:, 2)];

B = -ones(size(pts1, 1), 1);

%% Calculate the Fundamental matrix F
Fs = A \ B; 
F = reshape([Fs; 1], [3 3]);

%% Enforce the singularity condition on F
[U, S, V] = svd(F);
S(3, 3) = 0;
F = U * S * V';

%% Refine the calculated fundamental matrix
F = refineF(F, pts1, pts2);

%% Unscale the fundamental matrix F
% Create scaling matrix T
T = diag([1 / M, 1 / M, 1]);

% Unscale F
F = T' * F * T;

end
