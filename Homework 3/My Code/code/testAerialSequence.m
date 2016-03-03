% Close all open figure windows
close all;

% Load frames
load(fullfile('..','data','aerialseq.mat'));

% Frames that should be reported
reportFrames = [30 60 90 120];

% Initialization
numOfFrames = size(frames, 3);

% Detect the moving objects in the frame
for i = 2 : size(frames, 3)
    tic;

    % Extract the current frame
    curFrame = squeeze(frames(:, :, i));

    % Calculate the mask of the moving objects in the image
    mask = SubtractDominantMotion(frames(:, :, i - 1), curFrame);

    % Blend the mask with the image to show the result
    mask = uint8(mask);
    resultFrame = uint8(zeros(size(curFrame, 1), size(curFrame, 2), 3));
    resultFrame(:, :, 1) = max(curFrame, 255 * mask);
    resultFrame(:, :, 2) = curFrame .* (1 - mask);
    resultFrame(:, :, 3) = max(curFrame, 255 * mask);
    
    % Draw current frame
    imshow(resultFrame);
    
    % Check if the frame should be reported as a result
    j = find(reportFrames == i);
    if ~isempty(j)
        % Set title
        title(sprintf('%d (%0.3f milliseconds)', i, toc * 1000));
        
        % Save the image
        path = fullfile('..','results', sprintf('q3_3_frame_%d', ...
            reportFrames(j(1))));
        print(path, '-djpeg');
    end
    
    % Set the image title
    title(sprintf('Frame %d of %d', i, numOfFrames));

    % Pause for a few milliseconds
    pause(0.01);
    
end

%save(fullfile('..','results','aerialseqrects.mat'),'rects');
