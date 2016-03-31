function template = tl_pos_neg(template_images_pos, template_images_neg)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix 

% Block size and number of feature types
BlockSize = 8;
NumOfFeatures = 9;

% Initialize the template variable
template = zeros([size(template_images_pos{1}) / BlockSize, NumOfFeatures]);

% Calculate the average hog template for positive examples
for i = 1 : numel(template_images_pos)
    template = template + hog(template_images_pos{i});
end
template = template ./ numel(template_images_pos);

% Initialize the template variable for negative examples
template_neg = zeros([size(template_images_neg{1}) / BlockSize, NumOfFeatures]);

% Calculate the average hog template for negative examples
for i = 1 : numel(template_images_neg)
    template_neg = template_neg + hog(template_images_neg{i});
end
template = template - (template_neg ./ numel(template_images_neg));


end