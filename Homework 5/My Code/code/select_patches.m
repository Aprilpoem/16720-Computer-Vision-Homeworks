function select_patches()

clc;
close all;

%% Definitions

% Define the block size
BlockSize = 8;

% Ask for the number of training images
NumOfImages = input('Please enter the number of training images [1]: ');
if isempty(NumOfImages)
    NumOfImages = 1;
end

% Default image path
DefaultPath = '../data/';

% Initialize variables
Images = cell(NumOfImages, 1);
PosPatchRects = cell(NumOfImages, 1);
NegPatchRects = cell(NumOfImages, 1);
PosTemplates = cell(NumOfImages, 1);
NegTemplates = cell(NumOfImages, 1);
TotalExamples = 0;
TotalWidth = 0;
TotalHeight = 0;

%% Loop through the images
for n = 1 : NumOfImages

    % Ask for the name of training image
    fprintf('Please enter the path of the training image #%d [test%d.jpg]:\n', n, n - 1);
    ImagePath = input(['File path = ', DefaultPath], 's');
    if isempty(ImagePath)
        ImagePath = sprintf('test%d.jpg', n - 1);
    end
    
    % Load the training example image
    Images{n} = im2double(rgb2gray(imread([DefaultPath ImagePath])));

    % Ask for the number of positive examples
    NumOfPositives = input('Please enter the number of positive examples [2]: ');
    if isempty(NumOfPositives)
        NumOfPositives = 2;
    end

    % Ask for the number of negative examples
    NumOfNegatives = input('Please enter the number of negative examples [3]: ');
    if isempty(NumOfNegatives)
        NumOfNegatives = 3;
    end

    %% Select the patches
    
    % Initialize variables
    PosPatchRects{n} = zeros(NumOfPositives, 4);
    NegPatchRects{n} = zeros(NumOfPositives, 4);
    PosTemplates{n} = cell(NumOfPositives, 1);
    NegTemplates{n} = cell(NumOfNegatives, 1);
    
    % Show the image
    figure; clf;
    imshow(Images{n});
    title(['Training image #', num2str(n)]);

    % Select the positive patches on the image
    for i = 1 : NumOfPositives

        % Update the title on the image
        title(['Select the positive example #', num2str(i)]);

        % Get a patch area from user
        PosPatchRects{n}(i, :) = round(getrect);

        % Retrieve the patch
        PosTemplates{n}{i} = Images{n}(PosPatchRects{n}(i, 2) : ...
            PosPatchRects{n}(i, 2) + PosPatchRects{n}(i, 4), ...
            PosPatchRects{n}(i, 1) : PosPatchRects{n}(i, 1) + PosPatchRects{n}(i, 3));

    end

    % Calculate minimum and maximum patch dimensions
    minWidth = min(PosPatchRects{n}(:, 3));
    maxWidth = max(PosPatchRects{n}(:, 3));
    minHeight = min(PosPatchRects{n}(:, 4));
    maxHeight = max(PosPatchRects{n}(:, 4));

    % Randomly select the negative patches in the image without an overlap to
    % other examples
    % Note: It select an area in the image with width/height between the
    % maximum and minimum width/heigh of the selected positive patches
    for i = 1 : NumOfNegatives

        overlap = 1;
        while overlap == 1
            
            % Reset the overlap variable
            overlap = 0;

            % Calculate a patch area
            patchx = randi(size(Images{n}, 2) - minWidth);
            patchy = randi(size(Images{n}, 1) - minHeight);
            patchw = randi(maxWidth - minWidth + 1) + minWidth;
            patchh = randi(maxHeight - minHeight + 1) + minHeight;

            % Check if the box exceeds image boundaries
            if patchx + patchw > size(Images{n}, 2) || ...
                    patchy + patchh > size(Images{n}, 1)
                overlap = 1;
                continue;
            end
            
            % Check for overlap
            for j = 1 : NumOfPositives
                if abs(patchx - PosPatchRects{n}(j, 1)) * 2 < ...
                        patchw + PosPatchRects{n}(j, 3) && ...
                        abs(patchy - PosPatchRects{n}(j, 2)) * 2 < ...
                        patchh + PosPatchRects{n}(j, 4)
                    overlap = 1;
                    break;
                end
            end
            for j = 1 : i - 1
                if abs(patchx - NegPatchRects{n}(j, 1)) * 2 < ...
                        patchw + NegPatchRects{n}(j, 3) && ...
                        abs(patchy - NegPatchRects{n}(j, 2)) * 2 < ...
                        patchh + NegPatchRects{n}(j, 4)
                    overlap = 1;
                    break;
                end
            end
            
        end
        
        NegPatchRects{n}(i, :) = [patchx patchy patchw patchh];
        
        % Retrieve the patch
        NegTemplates{n}{i} = Images{n}(NegPatchRects{n}(i, 2) : ...
            NegPatchRects{n}(i, 2) + NegPatchRects{n}(i, 4), ...
            NegPatchRects{n}(i, 1) : NegPatchRects{n}(i, 1) + NegPatchRects{n}(i, 3));

    end

    % Update the total number of examples
    TotalExamples = TotalExamples + NumOfPositives + NumOfPositives;
    
    % Update the total width and height of the templates
    TotalWidth = TotalWidth + sum(PosPatchRects{n}(:, 3)) + sum(NegPatchRects{n}(:, 3));
    TotalHeight = TotalHeight + sum(PosPatchRects{n}(:, 4)) + sum(NegPatchRects{n}(:, 4));

    % Close the image
    close all;

end

% Flatten the patch cell arrays
template_images_pos = {};
template_images_neg = {};
for i = 1 : NumOfImages
    for j = 1 : numel(PosTemplates{i})
        template_images_pos = [template_images_pos, PosTemplates{i}{j}];
    end
end
for i = 1 : NumOfImages
    for j = 1 : numel(NegTemplates{i})
        template_images_neg = [template_images_neg, NegTemplates{i}{j}];
    end
end

%% Resize the patches with the stated requirements

% Find the average width and height of the templates
AverageWidth = TotalWidth / TotalExamples;
AverageHeight = TotalHeight / TotalExamples;

% Change the average height and width to the nearest multiple of BlockSize
AverageWidth = round(AverageWidth / BlockSize) * BlockSize;
AverageHeight = round(AverageHeight / BlockSize) * BlockSize;

% Resize the patches
for i = 1 : numel(template_images_pos)
    template_images_pos{i} = imresize(template_images_pos{i}, ...
        [AverageHeight AverageWidth]);
end
for i = 1 : numel(template_images_neg)
    template_images_neg{i} = imresize(template_images_neg{i}, ...
        [AverageHeight AverageWidth]);
end

%% Show the patches
SubPlotCols = max(numel(template_images_pos), numel(template_images_neg));
figure; clf;
for i = 1 : numel(template_images_pos)
    subplot(2, SubPlotCols, i);
    imshow(template_images_pos{i});
    title(['Positive #', num2str(i)]);
end

for i = 1 : numel(template_images_neg)
    subplot(2, SubPlotCols, i + SubPlotCols);
    imshow(template_images_neg{i});
    title(['Negative #', num2str(i)]);
end

%% Draw the images with the selected areas
for n = 1 : NumOfImages
    figure; clf;
    imshow(Images{n});
    
    % Draw positive selections
    for i = 1 : size(PosPatchRects{n}, 1)
        hold on;
        rectangle('Position', PosPatchRects{n}(i, :), 'EdgeColor', 'green', ...
            'LineWidth', 3, 'Curvature', [0.3 0.3]);
        hold off;
    end

    % Draw negative selections
    for i = 1 : size(NegPatchRects{n}, 1)
        hold on;
        rectangle('Position', NegPatchRects{n}(i, :), 'EdgeColor', 'red', ...
            'LineWidth', 3, 'Curvature', [0.3 0.3]);
        hold off;
    end
end

%% Save the templates

save('template_images_pos.mat', 'template_images_pos')
save('template_images_neg.mat', 'template_images_neg')

end
