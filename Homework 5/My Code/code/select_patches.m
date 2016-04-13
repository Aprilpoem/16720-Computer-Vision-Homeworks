function select_patches()

clc;
close all;

%% Definitions

% Show resulted patches or not
ShowPatches = true;

% Define the block size
BlockSize = 8;

% Define the final size
FinalWidth = 128;
FinalHeight = 128;

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

        % Get a patch area from user (repeat if the patch size is too low)
        while true
            PosPatchRects{n}(i, :) = round(getrect);
            if PosPatchRects{n}(i, 3) > BlockSize / 2 && ...
                PosPatchRects{n}(i, 4) > BlockSize / 2
                break;
            end
        end
        
        % Make the patch sizes a multiple of block size
        px = PosPatchRects{n}(i, 1);
        py = PosPatchRects{n}(i, 2);
        pw = PosPatchRects{n}(i, 3);
        ph = PosPatchRects{n}(i, 4);
        if pw <= ph
            oldph = ph;
            ph = BlockSize * round(ph / BlockSize);
            py = py - round((ph - oldph) / 2);
            py = max(py, 1);
            py = min(py, size(Images{n}, 1) - ph);
        else
            oldpw = pw;
            px = px - round((pw - oldpw) / 2);
            pw = ph;
            px = max(px, 1);
            px = min(px, size(Images{n}, 2) - pw);
        end
        
        % Make the patch square
        if pw < ph
            px = px - (ph - pw) / 2;
            pw = ph;
            px = max(px, 1);
            px = min(px, size(Images{n}, 2) - pw);
        elseif ph < pw
            py = py - (pw - ph) / 2;
            ph = pw;
            py = max(py, 1);
            py = min(py, size(Images{n}, 1) - ph);
        end
        
        % Update the patch box with the new calculated parameters
        PosPatchRects{n}(i, :) = round([px py pw ph]);
        
        % Retrieve the patch
        PosTemplates{n}{i} = Images{n}(PosPatchRects{n}(i, 2) : ...
            PosPatchRects{n}(i, 2) + PosPatchRects{n}(i, 4), ...
            PosPatchRects{n}(i, 1) : PosPatchRects{n}(i, 1) + ...
            PosPatchRects{n}(i, 3));

    end

    % Calculate minimum and maximum patch dimensions
    minPatchSize = min(PosPatchRects{n}(:, 3));
    maxPatchSize = max(PosPatchRects{n}(:, 3));

    % Randomly select the negative patches in the image without an overlap
    % to the other examples
    % Note: It selects an area in the image with size between the
    % maximum and minimum size of the selected positive patches
    for i = 1 : NumOfNegatives

        overlap = 1;
        tries = 0;
        while overlap == 1 && tries < 1000
            
            % Reset the overlap variable
            overlap = 0;

            % Calculate a patch area
            patchx = randi(size(Images{n}, 2) - minPatchSize);
            patchy = randi(size(Images{n}, 1) - minPatchSize);
            patchsize = randi(maxPatchSize - minPatchSize + 1) + minPatchSize;
            patchsize = round(patchsize / BlockSize) * BlockSize;
            
            % Check if the box exceeds image boundaries
            if patchx + patchsize > size(Images{n}, 2) || ...
                    patchy + patchsize > size(Images{n}, 1)
                overlap = 1;
                continue;
            end
            
            % Check for overlap
            for j = 1 : NumOfPositives
                if CheckOverlap([patchx, patchy, patchsize, patchsize], ...
                        PosPatchRects{n}(j, :)) == true
                    overlap = 1;
                    break;
                end
            end
            for j = 1 : i - 1
                if CheckOverlap([patchx, patchy, patchsize, patchsize], ...
                        NegPatchRects{n}(j, :)) == true
                    overlap = 1;
                    break;
                end
            end

            tries = tries + 1;
        end
        
        if overlap == 0
            % Retrieve the patch
            NegPatchRects{n}(i, :) = [patchx patchy patchsize patchsize];
            NegTemplates{n}{i} = Images{n}(NegPatchRects{n}(i, 2) : ...
                NegPatchRects{n}(i, 2) + NegPatchRects{n}(i, 4), ...
                NegPatchRects{n}(i, 1) : ...
                NegPatchRects{n}(i, 1) + NegPatchRects{n}(i, 3));
        else
            NegPatchRects{n} = NegPatchRects{n}(1 : i - 1, :);
            NegTemplates{n} = NegTemplates{n}(1 : i - 1);
            break;
        end
    end

    % Output the number of actual negative examples selected
    fprintf('The total of %d negative examples selected.\n', i - 1);
    
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

%% Resize the patches to final size

for i = 1 : numel(template_images_pos)
    template_images_pos{i} = imresize(template_images_pos{i}, ...
        [FinalHeight FinalWidth]);
end
for i = 1 : numel(template_images_neg)
    template_images_neg{i} = imresize(template_images_neg{i}, ...
        [FinalHeight FinalWidth]);
end

if ShowPatches == true

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
    
end

%% Save the templates

save('template_images_pos.mat', 'template_images_pos')
save('template_images_neg.mat', 'template_images_neg')

end
