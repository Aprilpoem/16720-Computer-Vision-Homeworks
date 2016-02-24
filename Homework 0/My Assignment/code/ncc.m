function score = ncc(matrix1, matrix2)
% ncc - Given 2 matrices with the same size, calculates the Normalized
%       Cross Correlation of the matrices. Lower number means more 
%       difference between matrices
% Args:
%   matrix1, matrix2 - each is a matrix with H rows x W columns
% Returns:
%   score - single scalar representing the Normalized Cross Correlation of
%   the given matrices.

% Normalize input matrices
matnorm1 = double(matrix1);
matnorm1 = matnorm1 / norm(matnorm1(:));
matnorm2 = double(matrix2);
matnorm2 = matnorm2 / norm(matnorm2(:));

% Perform dot product and calculate score
dotprod = matnorm1 .* matnorm2;
score = sum(dotprod(:));