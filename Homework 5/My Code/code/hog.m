function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
% TODO

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
% TODO

%% Compute the gradient magnitude and orientation
[mag, ori] = mygradient(I);

%% Initialize parameters

% Block size
BlockSize = 8;

% Threshold for considering a pixel as an edge
thresh = 0.1 * max(mag(:));

% Number of orientation bins
Nbins = 9;

% Create orientation bins
Bins = linspace(-pi / 2, pi / 2, Nbins + 1);

% Divide the image orientations in to blocks
OriBlocks = im2col(ori, [BlockSize BlockSize], 'distinct');

% Create a mask of the cells that are considered as an edge
MaskBlocks = im2col(mag >= thresh, [BlockSize BlockSize], 'distinct');

% Allocate space for the output
ohist = zeros(size(OriBlocks, 2), Nbins);

%% Calculate gradient orientation histograms
for i = 1 : Nbins
    criteria = MaskBlocks & OriBlocks > Bins(i) & OriBlocks <= Bins(i + 1);
    ohist(:, i) = sum(criteria)';
end

%% Normalize so that sum over orientation bins is 1 for each block

% Calculate sums for each block
histSum = sum(ohist, 2);

% Convert the sums vestor to a matrix of the size of the histogram
histSumMat = repmat(histSum, 1, Nbins);

% Normalize the histogram
ohist(histSum > 0, :) = ohist(histSum > 0, :) ./ histSumMat(histSum > 0, :);

%% Reshape the histogram to the desired output dimensions
BlockRows = ceil(size(I, 1) / BlockSize);
BlockCols = ceil(size(I, 2) / BlockSize);
ohist = reshape(ohist(:), BlockRows, BlockCols, Nbins);
