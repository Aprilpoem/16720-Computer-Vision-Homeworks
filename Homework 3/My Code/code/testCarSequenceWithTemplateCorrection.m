% Extra credit

% Close all open figure windows
close all;

% Load frames
load(fullfile('..','data','carseq.mat')); % variable name = frames. 
numOfFrames = size(frames, 3);
firstFrame = squeeze(frames(:, :, 1));

% Initialize position of the car that we want to track
rect = [60, 117, 146, 152];

% Frames that should be reported
reportFrames = [1 100 200 300 400];

% Initialization
rects = zeros(numOfFrames, 4);
u1 = 0; v1 = 0; % For normal LK algorithm
u2 = 0; v2 = 0; % For LK algorithm with template correction

% Track the car in the consecutive frames with template correction
for i = 1 : numOfFrames
    tic;
    
    % Extract the current frame
    currentFrame = squeeze(frames(:, :, i));
    
    if i ~= 1 
        % Calculate new position of the car from previous frame for normal
        % LK algorithm
        [delta_u1, delta_v1] = LucasKanade(squeeze(frames(:, :, i-1)), ...
            currentFrame, rect + [u1 v1 u1 v1]);
        u1 = u1 + delta_u1;
        v1 = v1 + delta_v1;
        
        % Calculate new position of the car from previous frame for the
        % LK algorithm with template correction
        [delta_u_n, delta_v_n] = LucasKanade(squeeze(frames(:, :, i-1)), ...
            currentFrame, rect + [u2 v2 u2 v2]);
        u_n = u2 + delta_u_n;
        v_n = v2 + delta_v_n;

        % Calculate new position of the car from the first frame
        [u_star, v_star] = LucasKanadeWithTemplateCorrection(...
            firstFrame, currentFrame, rect, [u_n, v_n]');

        % Update the template
        epsil = 2;
        if norm([u_star, v_star] - [u_n, v_n]) <= epsil
            u2 = u_star;
            v2 = v_star;
        else
            u2 = u_n;
            v2 = v_n;
        end
    end
    
    % Draw current frame
    imshow(currentFrame);
    hold on
    
    % Draw the rectangles
    rectangle('Position', [rect(1) + u1, rect(2) + v1, rect(3) - rect(1), ...
        rect(4) - rect(2)], 'LineWidth', 2, 'EdgeColor', 'g');
    rectangle('Position', [rect(1) + u2, rect(2) + v2, rect(3) - rect(1), ...
        rect(4) - rect(2)], 'LineWidth', 2, 'EdgeColor', 'y');
    hold off

    % Check if the frame should be reported as a result
    j = find(reportFrames == i);
    if ~isempty(j)
        % Set title
        title(sprintf('%d (%0.3f milliseconds)', i, toc * 1000));
        
        % Save the image
        path = fullfile('..','results', sprintf('q1_4_frame_%d', reportFrames(j(1))));
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
save(fullfile('..','results','carseqrects-wcrt.mat'),'rects');
