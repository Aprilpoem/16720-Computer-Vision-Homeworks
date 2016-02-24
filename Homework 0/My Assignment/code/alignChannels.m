function [rgbResult] = alignChannels(red, green, blue)
% alignChannels - Given 3 images corresponding to different channels of a 
%       color image, compute the best aligned result with minimum 
%       aberrations
% Args:
%   red, green, blue - each is a matrix with H rows x W columns
%   corresponding to an H x W image
% Returns:
%   rgb_output - H x W x 3 color image output, aligned as desired
        
%% Write code here
d = 30; % maximum displacement

rgscore = zeros(2*d + 1, 2*d + 1);
rbscore = zeros(size(rgscore));

for i = -d : d
    for j = -d : d
        % Generate shifted versions of green and blue layers
        gshift = circshift(green, [i j]);
        bshift = circshift(blue, [i j]);
        % Calculate scores of shifted blue and green layers wrt red
        rgscore(i+d+1, j+d+1) = ssd(red,gshift);
        rbscore(i+d+1, j+d+1) = ssd(red, bshift);
        % rgscore(i+d+1, j+d+1) = -ncc(red,gshift);
        % rbscore(i+d+1, j+d+1) = -ncc(red, bshift);
    end
end

% Find best alignment for green wrt red
[~, imin] = min(rgscore(:));
[gi, gj] = ind2sub(size(rgscore), imin);

% Find best alignment for blue wrt red
[~, imin] = min(rbscore(:));
[bi, bj] = ind2sub(size(rbscore), imin);

% Reconstruct the correctly-aligned picture
rgbResult = uint8(zeros([size(red, 1), size(red, 2), 3]));
rgbResult(:, :, 1) = red;
rgbResult(:, :, 2) = circshift(green, [gi-d-1, gj-d-1]);
rgbResult(:, :, 3) = circshift(blue, [bi-d-1, bj-d-1]);

end