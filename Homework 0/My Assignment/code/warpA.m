function [ warp_im ] = warpA( im, A, out_size )
% warp_im=warpAbilinear(im, A, out_size)
% Warps (w,h,1) image im using affine (3,3) matrix A 
% producing (out_size(1),out_size(2)) output image warp_im
% with warped  = A*input, warped spanning 1..out_size
% Uses nearest neighbor mapping.
% INPUTS:
%   im : input image
%   A : transformation matrix 
%   out_size : size the output image should be
% OUTPUTS:
%   warp_im : result of warping im by A

% Initialize output
warp_im = zeros(out_size);

% Retrieve input size
[W H] = size(im);

% Calculate inverse of the affine matrix
A_inv = inv(A);

[Y X] = meshgrid(1:out_size(2), 1:out_size(1));
ind_inv = [X(:), Y(:), ones(out_size(1)*out_size(2), 1)]';
ind = round(A_inv * ind_inv);
%ind2 = ind(1, :) * out_size(2) + ind(2, :);
%warp_im(ind2>0 & ind2<=W*H) = im(ind2(ind2>0 & ind2<W*H));

for i = 1:out_size(1)*out_size(2)
    if ind(1,i) > 0 && ind(1,i) <= W
        if ind(2,i) > 0 && ind(2,i) <= H
            warp_im(i) = im(ind(1,i), ind(2,i));
        end
    end
end
