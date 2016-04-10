function det_res = multiscale_detect(image, template, ndet)
% input:
%     image - test image.
%     template - [16 x 16 x 9] matrix.
%     ndet - the number of return values.
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..

%% Initialize the parameters

% Block size and number of feature types
BlockSize = 8;

% Scale factor to rescale image at each layer
ScaleFactor = 0.7;

% Keep the curent scale
CurrentScale = 1;

% Keep the scores
Scores = zeros(ndet, 1);

% Initialize the output
det_res = inf * ones(ndet, 3);

%% Perform the detection at different scales
while true

    % Resize the image for the new level in the pyramid
    image_scaled = imresize(image, CurrentScale);
    
    % Check if the image is larger than the template
    if size(image_scaled, 1) < size(template, 1) * BlockSize || ...
        size(image_scaled, 2) < size(template, 2) * BlockSize
        break;
    end
    
    % Perform the detection at the current scale
    [x, y, score] = detect(image_scaled, template, ndet);
    x = round(x ./ CurrentScale);
    y = round(y ./ CurrentScale);
    
    for i = 1 : ndet
        % Check for overlaps with previous results
        hasOverlaps = false;
        for j = 1 : ndet
            if score > Scores(j) &&...
              abs(x(i) - det_res(1, j)) < size(template, 1) * BlockSize &&...
              abs(y(i) - det_res(2, j)) < size(template, 2) * BlockSize
                hasOverlaps = true;
            end
        end
        
        % Add the new detection
        if ~hasOverlaps
            % Find the lowest score
            [minScore, minInd] = min(Scores);
            if minScore < score
                det_res(minInd, :) = [x, y, CurrentScale * ones(size(x, 1), 1)];
                Scores(minInd) = score;
            end
        end
    end
    
    % Update the scale
    CurrentScale = CurrentScale * ScaleFactor;
    
end

end
