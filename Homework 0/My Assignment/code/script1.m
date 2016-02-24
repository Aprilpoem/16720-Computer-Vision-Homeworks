% Problem 1: Image Alignment

%% 1. Load images (all 3 channels)
load '..\data\blue.mat';
load '..\data\red.mat';
load '..\data\green.mat';
% Red channel as 'red'
% Green channel as 'green'
% Blue channel as 'blue'

%% 2. Find best alignment
% Hint: Lookup the 'circshift' function
rgbResult = alignChannels(red, green, blue);

%% 3. Save result to rgb_output.jpg (IN THE "results" folder)
imwrite(rgbResult, '..\results\rgb_output.jpg');

% Reconstruct original image to show it
% orig = uint8(zeros([size(red, 1), size(red, 2), 3]));
% orig(:, :, 1) = red;
% orig(:, :, 2) = green;
% orig(:, :, 3) = blue;

% Show original and aligned pictures
% imshow(orig);
figure; imshow(rgbResult);