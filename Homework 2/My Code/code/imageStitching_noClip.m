function [panoImg] = imageStitching_noClip(img1, img2, H2to1)

% Define width of output image
Width = 1000;

% Calculate the output boundaries of images
img2_corners = [1,      1,              size(img2, 2)   size(img2, 2);
                1,      size(img2, 1),  1,              size(img2, 1);
                1,      1,              1,              1           ];

img2_warped_corners = H2to1 * img2_corners;
img2_warped_corners = img2_warped_corners ./ ...
    repmat(img2_warped_corners(3, :), 3, 1);

top = floor(min(1, min(img2_warped_corners(2, :))));
bottom = floor(max(size(img1, 1), max(img2_warped_corners(2, :))));
left = floor(min(1, min(img2_warped_corners(1, :))));
right = floor(max(size(img1, 2), max(img2_warped_corners(1, :))));

% Calculate output height
Height = floor(Width * (bottom - top) / (right-left));
out_size = [Height Width];

% Calculate scale and translation matrices
Trans = [1  0   -left;
         0  1   -top;
         0  0   1];
     
Scale = [ (Width / (right - left))  0                           0;
          0                         (Height / (bottom - top))   0;
          0                         0                           1];

M = Scale * Trans;

% Warp both images to new coordinates
warp_im1 = warpH(img1, M, out_size);
warp_im2 = warpH(img2, M * H2to1, out_size);

% Blend the two images together
panoImg = blendImages(warp_im1, warp_im2);
