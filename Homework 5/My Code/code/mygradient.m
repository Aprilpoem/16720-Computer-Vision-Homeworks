function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

%% Create the gradient filter
filt = [-1, 0, 1];

%% Find the horizontal and vertical gradients
gradx = imfilter(I, filt, 'replicate', 'same');
grady = imfilter(I, filt', 'replicate', 'same');

%% Compute the magnitude and orientation of the gradient
mag = sqrt(gradx.^2 + grady.^2);

% Compute the directions in (-pi, pi] range
ori = atan2(grady, gradx);

end
