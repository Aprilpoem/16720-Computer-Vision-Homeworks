function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

%% Create scaling matrix T
T = diag([1 / M, 1 / M, 1]);

%% Scale the data by factor M
pts1 = pts1 / M;
pts2 = pts2 / M;

%% Build the matrix A in Af = 0
A = [pts1(:, 1) .* pts2(:, 1), pts1(:, 1) .* pts2(:, 2), pts1(:, 1), ...
     pts1(:, 2) .* pts2(:, 1), pts1(:, 2) .* pts2(:, 2), pts1(:, 2), ...
     pts2(:, 1), pts2(:, 2), ones(size(pts1, 1), 1)];
 
%% Calculate two vectors that span null space of A (F1 and F2)
[~, ~, V] = svd(A);
F1 = reshape(V(:, 9), [3, 3]);
F2 = reshape(V(:, 8), [3, 3]);

%% Find alpha such that det(alpha * F1 + (1 - alpha) * F2) = 0

% Calculate the alpha solutions
syms alphasym
alpha = solve(det(alphasym * F1 + (1 - alphasym) * F2) == 0);
alpha = double(alpha);

% Find the real alphas
reals = abs(imag(alpha)) < eps;
alpha = real(alpha(reals));

%% Calculate the candidate Fundamental matrices F
F = cell(1, length(alpha));

for i = 1 : length(alpha)
    F{i} = alpha(i) * F1 + (1 - alpha(i)) * F2;

    % Refine the calculated fundamental matrix
    F{i} = refineF(F{i}, pts1, pts2);
    
    % Unscale F
    F{i} = T' * F{i} * T;
end

end

