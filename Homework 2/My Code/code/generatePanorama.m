function im3 = generatePanorama(im1, im2)

%% Convert input images to grayscale with values [0..1]
img1 = im1;
img2 = im2;

if size(img1, 3) == 3
    img1 = rgb2gray(img1);
end
if size(img2, 3) == 3
    img2 = rgb2gray(img2);
end

img1 = im2double(img1);
img2 = im2double(img2);

%% Calculate feature matches between images
% Find BRIEF features
[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);

% Match features in the images
matches = briefMatch(desc1, desc2, 0.25);

% Plot the matches to see what's going on
% plotMatches(img1, img2, matches, locs1, locs2);

% Find the location of matches
p1 = locs1(matches(:, 1), 1:2);
p2 = locs2(matches(:, 2), 1:2);

%% Stitch the images using homography (without RANSAC)
% % Calculate homography matrix to convert coordinates of the second image 
% % to the first
% H2to1 = computeH(p1', p2');
% save('../results/q5_1.mat', 'H2to1');
% 
% % Perform image stitching (with clipping)
% im3 = imageStitching(im1, im2, H2to1);
% 
% % Perform image stitching (without clipping)
% im3 = imageStitching_noClip(im1, im2, H2to1);

%% Stitch the images using homography (with RANSAC)
% Calculate homography matrix to convert coordinates of the second image 
% to the first
H2to1 = ransacH(matches, locs1, locs2);

% Perform image stitching (without clipping)
im3 = imageStitching_noClip(im1, im2, H2to1);
