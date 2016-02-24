function score = ssd(matrix1, matrix2)
% ssd - Given 2 matrices with the same size, calculates the sum of squared
%       differences between the corresponding elements of the matrices.
%       Higher number means more difference between matrices
% Args:
%   matrix1, matrix2 - each is a matrix with H rows x W columns
% Returns:
%   score - single scalar representing the sum of squared differences of
%   the given matrices.

diff = (matrix1 - matrix2).^2;
score = sum(diff(:));