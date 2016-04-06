function tl_detect_script

% Load the test image
Itest = im2double(rgb2gray(imread('../data/test6.jpg')));

% Load templates
load('template_images_pos.mat');
load('template_images_neg.mat');

% Perform detection with positive examples
template = tl_pos(template_images_pos);
ndet = 1;
[x, y, score] = detect(Itest, template, ndet);
draw_detection(x, y, Itest);

% Perform detection with positive and negative examples
template = tl_pos_neg(template_images_pos, template_images_neg);
[x, y, score] = detect(Itest, template, ndet);
draw_detection(x, y, Itest);

% Perform detection with Linear Discriminative Analysis (LDA)
lambda = 0.4;
template = tl_lda(template_images_pos, template_images_neg, lambda);
[x, y, score] = detect(Itest, template, ndet);
draw_detection(x, y, Itest);

return;

det_res = multiscale_detect(Itest, template, ndet);
draw_detection();

end



function draw_detection(x, y, I)

% Detection rectangle size
RectSize = 128;

% Show the image
figure; clf;
imshow(I);

% Draw the detections. Draw a rectangle. use color to encode confidence of 
% detection top scoring are green, fading to red.
ndet = length(x);
for i = 1 : ndet
    hold on;
    rectangle('Position', [x(i)-RectSize/2 y(i)-RectSize/2 RectSize RectSize], ...
        'EdgeColor', [(i/ndet) ((ndet-i)/ndet)  0], 'LineWidth', 3, ...
        'Curvature', [0.3 0.3]); 
    hold off;
end

end