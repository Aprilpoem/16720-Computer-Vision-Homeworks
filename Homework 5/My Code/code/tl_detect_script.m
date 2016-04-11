function tl_detect_script

% Close all open figures
close all;

% Load the test image
Itest = im2double(rgb2gray(imread('../data/test6.jpg')));

% Load templates
load('template_images_pos.mat');
load('template_images_neg.mat');

%% Perform detection with positive examples
template = tl_pos(template_images_pos);
ndet = 1;
[x, y, ~] = detect(Itest, template, ndet);
draw_detection(Itest, ndet, x, y, 1);

%% Perform detection with positive and negative examples
template = tl_pos_neg(template_images_pos, template_images_neg);
ndet = 1;
[x, y, ~] = detect(Itest, template, ndet);
draw_detection(Itest, ndet, x, y, 1);

%% Perform detection with Linear Discriminative Analysis (LDA)
lambda = 0.4;
template = tl_lda(template_images_pos, template_images_neg, lambda);
ndet = 1;
[x, y, ~] = detect(Itest, template, ndet);
draw_detection(Itest, ndet, x, y, 1);

%% Perform multi-scale detection with Linear Discriminative Analysis (LDA)
Itest = im2double(rgb2gray(imread('../custom/test102.jpg')));
ndet = 2;
lambda = 0.4;
template = tl_lda(template_images_pos, template_images_neg, lambda);
det_res = multiscale_detect(Itest, template, ndet);
draw_detection(Itest, ndet, det_res(:, 1), det_res(:, 2), det_res(:, 3));

end


%% Function to draw detections on the image
function draw_detection(Itest, ndet, x, y, scale)

% Show the image
figure; clf;
imshow(Itest);

% Draw the detections. Draw a rectangle. use color to encode confidence of 
% detection top scoring are green, fading to red.
for i = 1 : ndet
    hold on;

    % Detection rectangle size
    RectSize = 128 / scale(i);

    rectangle('Position', [x(i)-RectSize/2 y(i)-RectSize/2 RectSize RectSize], ...
        'EdgeColor', [(i/ndet) ((ndet-i)/ndet)  0], 'LineWidth', 3, ...
        'Curvature', [0.3 0.3]); 
    hold off;
end

end