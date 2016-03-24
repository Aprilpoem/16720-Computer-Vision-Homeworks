function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorithm, how you determined which
%     points are inliers, and any other optimizations you made


%% Initialize RANSAC parameters

% Probability that RANSAC returns a good model
p = 0.999;

% Fraction of inliers in data
w = 0.75;

% Number of points used to estimate model
% (Choose 7 for 7-point algorithm and 8 for 8-point algorithm)
n = 7;
% n = 8;

% Number of random trials 
k = ceil(log(1 - p) / log(1 - w^n));
fprintf('Number of trials for p = %0.4f and %d-point algorithm is: %d\n', p, n, k);
k = k * 2; 
fprintf('Performing %d iterations (just to be safe!)...\n', k);

% Threshold for error to determine inlier vs outlier
threshold = 1e-3;

% Total number of point pairs
N = size(pts1, 1);

% Best inlier set so far
Inliers = [];

% Error for the best inlier set so far
Error = inf;

% Fundamental matrix for the best inlier set so far
F = zeros(3, 3);

%% RANSAC loop

for iter = 1 : k
    % Select feature pairs (at random)
    randind = randperm(N, n);
    
    % Compute fundamental matrix using the random pairs
    if n == 7
        f = sevenpoint(pts1(randind, :), pts2(randind, :), M);
    else % if n == 8
        f_temp = eightpoint(pts1(randind, :), pts2(randind, :), M);
        % Convert to cell for compatibility with 7-point algorithm
        f = cell(1, 1);
        f{1} = f_temp;
    end
    
    % 7-point returns up to 3 candidate fundamental matrices. Compute inliers
    % for each of them
    for i = 1 : numel(f)
        % Initialize local parameters
        inliers = [];
        totalerror = 0;

        % Calculate error for all points
        errors = diag(abs([pts2, ones(N, 1)] * f{i} * [pts1, ones(N, 1)]'));
        totalerror = sum(errors);

        % Find the inliers
        inliers = errors < threshold;
        
        % Check if the inlier set and the error are better than previously
        % calculated so far
        if  nnz(inliers) > nnz(Inliers) || ...
                (nnz(inliers) == nnz(Inliers) && totalerror < Error)
            Inliers = inliers;
            Error = totalerror;
            F = f{i};
        end
    end
end

% Print the number of inliers
fprintf('The final number of inliers is %d out of total %d feature pairs.\n', ...
    nnz(Inliers), N);

end
