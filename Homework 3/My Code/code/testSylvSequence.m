% Close all open figure windows
close all;

% Load frames
load(fullfile('..','data','sylvseq.mat'));
numOfFrames = size(frames, 3);
firstFrame = squeeze(frames(:, :, 1));

% Load bases
load(fullfile('..','data','sylvbases.mat'));
NumOfBases = size(bases, 3);

% Initialize position of the car that we want to track
rect0 = [102, 62, 156, 108];

% Frames that should be reported
reportFrames = [1 200 300 350 400];

% Initialization
rects = zeros(numOfFrames, 4);
rect_lk = rect0;
rect_lkwtc = rect0;

% Track the car in the consecutive frames with template correction
for i = 1 : numOfFrames
    tic;
    
    % Extract the current frame
    currentFrame = squeeze(frames(:, :, i));
    
    if i ~= 1 
        % Extract the previous frame
        previousFrame = squeeze(frames(:, :, i-1));
        
        % Calculate new position of the car from previous frame for normal
        % LK algorithm
        [u, v] = LucasKanade(previousFrame, currentFrame, rect_lk);
        rect_lk = rect_lk + [u, v, u, v];
        
        % Calculate new position of the car from previous frame for the
        % LK algorithm with template correction
        [u, v] = LucasKanadeWithTemplateCorrection(previousFrame, ...
            currentFrame, rect_lkwtc, firstFrame, rect0);
        rect_lkwtc = rect_lkwtc + [u, v, u, v];

    end
    
    % Draw current frame
    imshow(currentFrame);
    hold on
    
    % Draw the rectangles
    rectangle('Position', [rect_lk(1), rect_lk(2), rect_lk(3) - rect_lk(1), ...
        rect_lk(4) - rect_lk(2)], 'LineWidth', 2, 'EdgeColor', 'g');
    rectangle('Position', [rect_lkwtc(1), rect_lkwtc(2), rect_lkwtc(3) - rect_lkwtc(1), ...
        rect_lkwtc(4) - rect_lkwtc(2)], 'LineWidth', 2, 'EdgeColor', 'y');
    hold off

    % Check if the frame should be reported as a result
    j = find(reportFrames == i);
    if ~isempty(j)
        % Set title
        title(sprintf('%d (%0.3f milliseconds)', i, toc * 1000));
        
        % Save the image
        path = fullfile('..','results', sprintf('q2_3_frame_%d', reportFrames(j(1))));
        print(path, '-djpeg');
    end
    
    % Set the image title
    title(sprintf('Frame %d of %d', i, numOfFrames));

    % Save new position in a variable
    rects(i, :) = rect_lkwtc;
    
    % Pause for a few milliseconds
    pause(0.01);

end

% Save the rects
save(fullfile('..','results','sylvseqrects.mat'), 'rects');
