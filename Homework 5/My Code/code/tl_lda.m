function template = tl_lda(template_images_pos, template_images_neg, lambda)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
%     lambda - parameter for lda
% output:
%     template - [16 x 16 x 9] matrix 

% Calculate the average template for negative examples
Mu_neg = tl_pos(template_images_neg);

% Calculate the difference of the average of positive and negative examples
% (i.e. deltaMu = Mu_pos - Mu_neg)
delta_mu = tl_pos(template_images_pos) - Mu_neg;

% Calculate the the covariance matrix of negative examples
Sigma_neg = zeros(numel(delta_mu));
for i = 1 : numel(template_images_neg)
    Neg_diff = hog(template_images_neg{i}) - Mu_neg;
    Sigma_neg = Sigma_neg + Neg_diff(:) * Neg_diff(:)';
end
Sigma_neg = Sigma_neg / numel(template_images_neg);
Sigma_neg = Sigma_neg + lambda * eye(size(Sigma_neg));

% Calculate the final template and reshape to the required size
template = Sigma_neg \ delta_mu(:);
template = reshape(template, size(delta_mu));

end
