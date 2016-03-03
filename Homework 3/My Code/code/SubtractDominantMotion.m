function mask = SubtractDominantMotion(image1, image2)

% Convert values of the images to double
image1 = im2double(image1);
image2 = im2double(image2);

% Compute the transformation matrix
M = LucasKanadeAffine(image1, image2);

% Calculate the warped image using M
image_warped = warpH(image1, M, [size(image2, 1), size(image2, 2)], NaN);

% Find the common regions between warped and unwarped images
common = ~isnan(image_warped);
image_warped(~common) = 0;

%% Compute the mask
% Initial mask is the difference of the warped image 1 and image 2
mask = abs(image2 - image_warped) .* common;

% Convert mask to black & white
thresh = graythresh(mask);
mask = im2bw(mask, thresh);

% Remove Salt & Pepper noise from the mask
mask = medfilt2(mask);

% Create morphological structuring element
SE = strel('disk', 8);

% Dilate and erode the mask to fill the holes
mask = imdilate(mask, SE);
mask = imerode(mask, SE);

% Remove very large patches
mask = mask - bwareaopen(mask, 500);

end
