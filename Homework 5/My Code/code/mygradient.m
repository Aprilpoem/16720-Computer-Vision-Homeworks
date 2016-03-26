function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

%% Convert image to double
I = im2double(I);

%% Create the gradient filter

% filt = fspecial('sobel');
filt = [    1     2     1
            0     0     0
           -1    -2    -1   ];

% filt = fspecial('prewitt');
% filt = [    1     1     1
%             0     0     0
%            -1    -1    -1   ];

%% Find the horizontal and vertical gradients
gradx = imfilter(I, filt', 'replicate', 'same');
grady = imfilter(I, filt, 'replicate', 'same');

%% Compute the magnitude and orientation of the gradient
grad = gradx + grady * 1i;
mag = abs(grad);
ori = angle(grad);
