function template = tl_pos(template_images_pos)
% input:
%     template_images_pos - a cell array, each one contains [128 x 128] matrix
% output:
%     template - [16 x 16 x 9] matrix

% Block size and number of feature types
BlockSize = 8;
NumOfFeatures = 9;

% Initialize the template variable
template = zeros([size(template_images_pos{1}) / BlockSize, NumOfFeatures]);

% Calculate the average hog template
for i = 1 : numel(template_images_pos)
    template = template + hog(template_images_pos{i});
end
template = template ./ numel(template_images_pos);
