% Close all open figure windows
close all;

% Skip Mode means that the program skips a few frames, (e.g. for 
% SkipRate = 4 it tracks the toy in frames 1, 6, 11, 16, ... skipping 
% 4 frames after each frame)
SkipRate = 0;

% Load frames
load(fullfile('..','data','bookSequence.mat'));

% Skip unwanted frames
frames = frames(:, :, 1 : (SkipRate + 1) : end);

% Load bases
load(fullfile('..','data','bookBases.mat'));
NumOfBases = size(bases, 3);

% Frames that should be reported
reportFrames = ceil([1 200 300 350 400] / (SkipRate + 1));

% Initialization
numOfFrames = size(frames, 3);
firstFrame = squeeze(frames(:, :, 1));
rects = zeros(numOfFrames, 4);
rect_lk = rect;
rect_lkwab = rect;

% Track the car in the consecutive frames with template correction
for i = 1 : numOfFrames
    tic;
    
    % Extract the current frame
    currentFrame = squeeze(frames(:, :, i));
    
    if i ~= 1 
        % Extract the previous frame
        previousFrame = squeeze(frames(:, :, i - 1));
        
        % Calculate new position of the car from previous frame for normal
        % LK algorithm
        [u, v] = LucasKanade(previousFrame, currentFrame, rect_lk);
        rect_lk = rect_lk + [u, v, u, v];
        
        % Calculate new position of the car from previous frame for the
        % LK algorithm with appearance basis
        [u, v] = LucasKanadeBasis(previousFrame, currentFrame, ...
            rect_lkwab, bases);
        rect_lkwab = rect_lkwab + [u, v, u, v];

    end
    
    % Draw current frame
    imshow(currentFrame);
    hold on
    
    % Draw the rectangles
    rectangle('Position', [rect_lk(1), rect_lk(2), rect_lk(3) - rect_lk(1), ...
        rect_lk(4) - rect_lk(2)], 'LineWidth', 2, 'EdgeColor', 'g');

    rectangle('Position', [rect_lkwab(1), rect_lkwab(2), rect_lkwab(3) - rect_lkwab(1), ...
        rect_lkwab(4) - rect_lkwab(2)], 'LineWidth', 2, 'EdgeColor', 'y');
    hold off

    % Check if the frame should be reported as a result
    j = find(reportFrames == i);
    if ~isempty(j)
        % Set title
        title(sprintf('%d (%0.3f milliseconds)', i, toc * 1000));
        
        % Save the image
        path = fullfile('..','results', sprintf('q2_3_book_skip%d_frame_%d', ...
            SkipRate, reportFrames(j(1))));
        print(path, '-djpeg');
    end
    
    % Set the image title
    title(sprintf('Frame %d of %d', i, numOfFrames));

    % Save new position in a variable
    rects(i, :) = rect_lkwab;
    
    % Pause for a few milliseconds
    pause(0.01);

end

% Save the rects
save(fullfile('..','results','bookseqrects.mat'), 'rects');
