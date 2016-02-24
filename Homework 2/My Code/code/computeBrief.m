function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, ...
    levels, compareX, compareY)

%% Calculate BRIEF detector locations

patchWidth = 9;
nbits = length(compareX);

% Remove DoG detector locations at the edge of the image where we cannot 
% extract a full patch of width patchWidth
halfPatch = floor(patchWidth / 2);
locs = locsDoG(locsDoG(:,1) > halfPatch & ...
    locsDoG(:,1) < size(GaussianPyramid, 2) - halfPatch & ...
    locsDoG(:,2) > halfPatch & ...
    locsDoG(:,2) < size(GaussianPyramid, 1) - halfPatch, :);

%% Calculate descriptor

% Calculate level indices in 'levels' array
[~, levelInds] = ismember(locs(:,3), levels);

% Convert test set index arrays to more useful representation
[Xx, Xy] = ind2sub([patchWidth, patchWidth], compareX);
[Yx, Yy] = ind2sub([patchWidth, patchWidth], compareY);
Xx = repmat((Xx - halfPatch - 1)', size(locs, 1), 1);
Xy = repmat((Xy - halfPatch - 1)', size(locs, 1), 1);
Yx = repmat((Yx - halfPatch - 1)', size(locs, 1), 1);
Yy = repmat((Yy - halfPatch - 1)', size(locs, 1), 1);

% Calculate test locations (indices in GaussianPyramid)
compX1 = repmat(locs(:, 1), 1, nbits) + Xx;
compY1 = repmat(locs(:, 2), 1, nbits) + Xy;
compX2 = repmat(locs(:, 1), 1, nbits) + Yx;
compY2 = repmat(locs(:, 2), 1, nbits) + Yy;
compL = repmat(levelInds, 1, nbits);

comp1 = sub2ind(size(GaussianPyramid), compY1, compX1, compL);
comp2 = sub2ind(size(GaussianPyramid), compY2, compX2, compL);

% Calculate descriptors (test results)
desc = GaussianPyramid(comp1) < GaussianPyramid(comp2);
