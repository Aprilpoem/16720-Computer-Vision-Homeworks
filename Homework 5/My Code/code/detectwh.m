function [x, y, score, heatmap] = detectwh(I,template,ndet)

%% Initialization and parameter definition

% Size of each image block
BlockSize = 8;

% Calculate the histogram of gradient orientation feature map
Map = hog(I);

% Number of feature types (orientation bins)
NumOfFeatureTypes = size(Map, 3);

% Size of the feature map
MapRows = size(Map, 1);
MapCols = size(Map, 2);

% Size of the template
TemplateRows = size(template, 1);
TemplateCols = size(template, 2);

% Overlap threshold (distance of blocks to be considered non-overlapping)
OverlapRows = BlockSize * TemplateRows;
OverlapCols = BlockSize * TemplateCols;

%% Perform cross-correlation of the template with the feature map

% Allocate space for the initial response map (heat map)
heatmap = zeros(MapRows, MapCols);

% MATLAB does not support cross correlation output of the same size as one
% of the inputs, therefore it is easier to use conv2 function with one of
% the inputs (the smaller) rotated for 180 degrees instead of xcorr2

% Rotate the template for 180 degrees: 
template_rot = rot90(template, 2);

% Calculate and sum the responses (perform cross-correlation)
for i = 1 : NumOfFeatureTypes
    heatmap = heatmap + conv2(Map(:, :, i), template_rot(:, :, i), 'same');
end

%% Find the highest correlation points in the maps; i.e. find the 
% coordinates and score of the detections in the image

% Initialize the coordinates and score of the detections
% It is possible that the number of detections is less than intended, so it
% is not appropriate to pre-allocate the space for these output variables.
score = [];
x = [];
y = [];

% Sort responses in descending order
[~, heatmapSortedInds] = sort(heatmap(:), 'descend');

% Find the coordinates and score of the detections in the image
for i = 1 : length(heatmapSortedInds)

    % Calculate the row and col of the index in the image coordinates
    [blkrow, blkcol] = ind2sub(size(heatmap), heatmapSortedInds(i));
    imgrow = BlockSize * blkrow;
    imgcol = BlockSize * blkcol;

    % Add current detection if there is no spatial overlap with the 
    % previous detections
    if nnz(abs(x - imgcol) < OverlapCols & abs(y - imgrow) < OverlapRows) == 0
        score = [score; heatmap(blkrow, blkcol)];
        x = [x; imgcol];
        y = [y; imgrow];

        % Check to see if we reached the desired number of detections
        if length(x) == ndet
            break;
        end
    end
    
end
