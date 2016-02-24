function [panoImg] = blendImages(img1, img2)

%% Blend the two images together by taking the maximum intensity of each pixel

% Copy images to the destination (rewriting each other)
panoImg = uint8(zeros(max(size(img2), size(img1))));
panoImg(1 : size(img1, 1), 1 : size(img1, 2), :) = img1;
panoImg(1 : size(img2, 1), 1 : size(img2, 2), :) = img2;

% Create blending mask
minsize = min(size(img1), size(img2));
mask = sum(img1(1:minsize(1), 1:minsize(2), :), 3) > ...
    sum(img2(1:minsize(1), 1:minsize(2), :), 3);
mask = uint8(repmat(mask, 1, 1, size(img1, 3)));

% Apply blending mask
panoImg(1 : minsize(1), 1 : minsize(2), :) = ...
    img1(1:minsize(1), 1:minsize(2), :) .* mask + ...
    img2(1:minsize(1), 1:minsize(2), :) .* (1 - mask);
