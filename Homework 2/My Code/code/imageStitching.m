function [panoImg] = imageStitching(img1, img2, H2to1)

% Define output image size
outsize = [600 1500];

% Warp image 2 to image 1 coordinates
img2_warped = warpH(img2, H2to1, outsize);

% Blend the two images together
panoImg = blendImages(img1, img2_warped);
