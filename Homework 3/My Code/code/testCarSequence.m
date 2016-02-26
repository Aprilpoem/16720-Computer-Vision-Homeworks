% Close all open figure windows
close all;

% Load frames
load(fullfile('..','data','carseq.mat')); % variable name = frames. 
numOfFrames = size(frames, 3);

% Initialize position of the car that we want to track
rect = [60, 117, 146, 152];

% Frames that should be reported
reportFrames = [1 100 200 300 400];

% Initialization
rects = zeros(numOfFrames, 4);

% Track the car in the consecutive frames
for i = 1 : numOfFrames
    tic;
    
    % Extract the current frame
    currentFrame = squeeze(frames(:, :, i));
    
    % Calculate new position of the car
    if i ~= 1 
        [u, v] = LucasKanade(squeeze(frames(:, :, i-1)), currentFrame, rect);
        rect = rect + [u, v, u, v];
    end
    
    % Draw current frame
    imshow(currentFrame);
    hold on
    
    % Draw the rectangle
    rectangle('Position', [rect(1), rect(2), rect(3) - rect(1), ...
        rect(4) - rect(2)], 'LineWidth', 2, 'EdgeColor', 'y');
    hold off

    % Check if the frame should be reported as a result
    j = find(reportFrames == i);
    if ~isempty(j)
        % Set title
        title(sprintf('%d (%0.3f milliseconds)', i, toc * 1000));
        
        % Save the image
        path = fullfile('..','results', sprintf('q1_3_frame_%d', reportFrames(j(1))));
        print(path, '-djpeg');
    end
    
    % Set the image title
    title(sprintf('Frame %d of %d', i, numOfFrames));

    % Save new position in a variable
    rects(i, :) = rect;
    
    % Pause for a few milliseconds
    pause(0.01);

end

% Save the rects
save(fullfile('..','results','carseqrects.mat'),'rects');
