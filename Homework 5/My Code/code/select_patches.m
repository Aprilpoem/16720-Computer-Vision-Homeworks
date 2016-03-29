function select_patches()

clc;
close all;

%% Initialize parameters

% Define the block size
BlockSize = 8;

% Load a training example image
I = im2double(rgb2gray(imread('../data/test2.jpg')));

% Ask for the number of positive examples
NumOfPositives = input('Please enter the number of positive examples: ');

% Ask for the number of negative examples
NumOfNegatives = input('Please enter the number of negative examples: ');

%% Select the patches

% Show the image
figure; clf;
imshow(I);

% Allocate space for the templates
PatchRects = zeros(NumOfPositives + NumOfNegatives, 4);
template_images_pos = cell(NumOfPositives, 1);
template_images_neg = cell(NumOfNegatives, 1);

% Select the positive patches on the image
for i = 1 : NumOfPositives

    % Update the title on the image
    title(['Select the positive example #', num2str(i)]);

    % Get a patch area from user
    PatchRects(i, :) = round(getrect);

    % Retrieve the patch
    template_images_pos{i} = I(PatchRects(i, 2) : PatchRects(i, 2) + PatchRects(i, 4), ...
        PatchRects(i, 1) : PatchRects(i, 1) + PatchRects(i, 3));

end

for i = 1 : NumOfNegatives

    % Update the title on the image
    title(['Select the negative example #', num2str(i)]);

    % Get a patch area from user
    j = i + NumOfPositives;
    PatchRects(j, :) = round(getrect);

    % Retrieve the patch
    template_images_neg{i} = I(PatchRects(j, 2) : PatchRects(j, 2) + PatchRects(j, 4), ...
        PatchRects(j, 1) : PatchRects(j, 1) + PatchRects(j, 3));

end

%% Resize the patches with the stated requirements

% Find the average width and height of the templates
AverageWidth = mean(PatchRects(:, 3));
AverageHeight = mean(PatchRects(:, 4));

% Change the average height and width to the nearest multiple of BlockSize
AverageWidth = round(AverageWidth / BlockSize) * BlockSize;
AverageHeight = round(AverageHeight / BlockSize) * BlockSize;

% Resize the patches
for i = 1 : numel(template_images_pos)
    template_images_pos{i} = imresize(template_images_pos{i}, [AverageHeight AverageWidth]);
end
for i = 1 : numel(template_images_neg)
    template_images_neg{i} = imresize(template_images_neg{i}, [AverageHeight AverageWidth]);
end

% Show the patches
figure; clf;
for i = 1 : numel(template_images_pos)
    subplot(2, max(NumOfPositives, NumOfNegatives), i);
    imshow(template_images_pos{i});
    title(['Positive #', num2str(i)]);
end

for i = 1 : numel(template_images_neg)
    subplot(2, max(NumOfPositives, NumOfNegatives), i + max(NumOfPositives, NumOfNegatives));
    imshow(template_images_neg{i});
    title(['Negative #', num2str(i)]);
end

%% Save the templates

save('template_images_pos.mat', 'template_images_pos')
save('template_images_neg.mat', 'template_images_neg')

end
