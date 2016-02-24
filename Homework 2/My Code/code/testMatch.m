function testMatch

% Paths to Chicken Broth images
path1 = '../data/model_chickenbroth.jpg';
path2 = '../data/chickenbroth_01.jpg';

% % Paths to Computer Vision Textbook Cover images
% path1 = '../data/pf_scan_scaled.jpg';
% path2 = '../data/pf_desk.jpg';
% % path2 = '../data/pf_floor.jpg';
% % path2 = '../data/pf_floor_rot.jpg';
% % path2 = '../data/pf_pile.jpg';
% % path2 = '../data/pf_stand.jpg';

% % Paths to Incline images
% path1 = '../data/incline_L.png';
% path2 = '../data/incline_R.png';

% Load two images and convert to greyscale with values in [0..1] range
im1 = imread(path1);
im2 = imread(path2);
if size(im1, 3) == 3
    im1 = rgb2gray(im1);
end
if size(im2, 3) == 3
    im2 = rgb2gray(im2);
end
im1 = im2double(im1);
im2 = im2double(im2);

% Calculate BRIEF descriptors on the images
[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

% Calculate feature matches between images
matches = briefMatch(desc1, desc2);

% Visualize the feature matches betwen images
plotMatches(im1, im2, matches, locs1, locs2);
