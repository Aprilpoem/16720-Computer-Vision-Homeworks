function tl_detect_script_custom

%% Determine the number of templates in the mixture
NumOfTemplates = input('Please enter the number of training templates [2]: ');
if isempty(NumOfTemplates)
    NumOfTemplates = 2;
end

%% Create the templates
Templates = cell(NumOfTemplates, 1);

for t = 1 : NumOfTemplates

    % Select patches for the first point of view
    select_patches

    % Load templates
    load('template_images_pos.mat');
    load('template_images_neg.mat');

    % Calculate the LDA template
    lambda = 0.01;
    Templates{t} = tl_lda(template_images_pos, template_images_neg, lambda);

end

%% Perform the detection

% Load the test image
Itest = im2double(rgb2gray(imread('../data/test22.jpg')));

% Detect the objects
ndet = 5;
x = [];
y = [];
scores = [];
for t = 1 : NumOfTemplates
    [xt, yt, scoret] = detect(Itest, Templates{t}, ndet);
    x = [x; xt];
    y = [y; yt];
    scores = [scores; scoret];
    
    % Calculate the top detections
    [~, ind] = sort(scores, 'descend');
    x = x(ind(1 : ndet), :);
    y = y(ind(1 : ndet), :);
    scores = scores(ind(1 : ndet), :);
end

%% Draw the results
draw_detection(Itest, ndet, x, y, ones(ndet, 1));

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