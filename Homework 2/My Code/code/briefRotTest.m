function briefRotTest

% Initialize parameters
incDegree = 10;

% Load an image and convert to greyscale with values in [0..1] range
imorig = im2double(rgb2gray(imread('../data/model_chickenbroth.jpg')));

% Calculate BRIEF descriptors on the image
[~, descorig] = briefLite(imorig);

% Initialize increments and array for number of matches
increments = 0 : incDegree : 359;
matches = zeros(1, length(increments));

for i = 1 : length(increments)
    % Rotate the original image
    imrot = imrotate(imorig, increments(i));
    
    % Calculate BRIEF descriptors on the rotated image
    [~, descrot] = briefLite(imrot);
    
    % Calculate feature matches between original and rotated images
    matches(i) = size(briefMatch(descorig, descrot), 1);
end

% Plot the bar graph of angles vs. number of matches
bar(increments, matches);
axis([-10 359 0 1]);
axis 'auto y'
title('Number of matched BRIEF featuers in rotated vs original image');
xlabel('Rotation degree');
ylabel('Number of matched features');
