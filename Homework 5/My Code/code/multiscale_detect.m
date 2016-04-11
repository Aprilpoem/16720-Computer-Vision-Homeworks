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

% Calculate the maximum scale
MaxScale = min(size(image, 1) / (BlockSize * size(template, 1)), ...
               size(image, 2) / (BlockSize * size(template, 2)));
MaxScale = fix(log(MaxScale) / log(ScaleFactor));

% Keep the curent scale
CurrentScale = ScaleFactor ^ MaxScale;

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
            if abs(x(i) - det_res(j, 1)) < size(template, 1) * BlockSize / CurrentScale &&...
              abs(y(i) - det_res(j, 2)) < size(template, 2) * BlockSize / CurrentScale
                hasOverlaps = true;
                % Replace the overlapped result if has higher score
                if score(i) > Scores(j)
                    det_res(j, :) = [x(i), y(i), CurrentScale];
                    Scores(j) = score(i);
                end
                break;
            end
        end
        
        % Add the new detection
        if ~hasOverlaps
            % Find the lowest score
            [minScore, minInd] = min(Scores);
            if minScore < score(i)
                det_res(minInd, :) = [x(i), y(i), CurrentScale];
                Scores(minInd) = score(i);
            end
        end
    end
    
    % Update the scale
    CurrentScale = CurrentScale * ScaleFactor;
    
end

end
