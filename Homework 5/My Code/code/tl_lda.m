function template = tl_lda(template_images_pos, template_images_neg, lambda)
% input:
%     template_images_pos - a cell array, each one contains [128 x 128] matrix
%     template_images_neg - a cell array, each one contains [128 x 128] matrix
%     lambda - parameter for lda
% output:
%     template - [16 x 16 x 9] matrix 

% Calculate the average template for negative examples
Mu_neg = tl_pos(template_images_neg);

% Calculate the difference of the average of positive and negative examples
% (i.e. deltaMu = Mu_pos - Mu_neg)
delta_mu = tl_pos(template_images_pos) - Mu_neg;

% Initialize the output template
template = zeros(size(delta_mu));

% Calculate the template channel-by-channel
for channel = 1 : size(delta_mu, 3)

    % Calculate the covariance matrix of negative examples
    Sigma_neg = zeros(size(delta_mu, 1), size(delta_mu, 2));
    for i = 1 : numel(template_images_neg)
        sample_hog = hog(template_images_neg{i});
        Neg_diff = sample_hog(:, :, channel) - Mu_neg(:, :, channel);
        Sigma_neg = Sigma_neg + Neg_diff * Neg_diff';
    end
    Sigma_neg = Sigma_neg / numel(template_images_neg);
    Sigma_neg = Sigma_neg + lambda * eye(size(Sigma_neg));

    % Calculate the final template for the current channel
    delta_mu_channel = delta_mu(:, :, channel);
    template(:, :, channel) = Sigma_neg \ delta_mu_channel;

end

end
