function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

%% Convert image to double
I = im2double(I);

%% Create the gradient filter
filt = [-1, 0, 1];

%% Find the horizontal and vertical gradients
gradx = imfilter(I, filt, 'replicate', 'same');
grady = imfilter(I, filt', 'replicate', 'same');

%% Compute the magnitude and orientation of the gradient
mag = sqrt(gradx.^2 + grady.^2);

% Compute the directions in (-pi, pi] range
ori = atan2(grady, gradx);

% Compute the orientations in (-pi/2, pi/2] range
ori(ori > pi / 2) = ori(ori > pi / 2) - pi;
ori(ori <= - pi / 2) = ori(ori <= - pi / 2) + pi;

end
