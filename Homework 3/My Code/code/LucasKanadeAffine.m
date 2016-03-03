function M = LucasKanadeAffine(It, It1)
% Finds transformation M to warp It to It1

% Convert input images to double
It = im2double(It);
It1 = im2double(It1);

% Initialize parameters
tol = 0.1;
p = zeros(6, 1);
deltap = 2 * ones(size(p));

% Compute the template that we want to track
% Initialize point coordinates to warp It to It1
[X, Y] = meshgrid(1 : size(It, 2), 1 : size(It, 1));
ImagePoints = [X(:)'; Y(:)'; ones(size(X(:)'))];

%% Implementation of normal Lucas-Kanade affine algorithm according to the 
% steps in Ref. [1] of PDF description

% Caclulate the gradient
[It1x, It1y] = gradient(It1);

% Lucas-Kanade iterative algorithm
while norm(deltap) >= tol
    
    % (0) Define transformation matrix
    M = [1 + p(1),    p(3),         p(5);
         p(2),        1 + p(4),     p(6);
         0,           0,            1       ];

    % (1) Warp I (select the region of interest)
    % Warp image points
    WX = M * ImagePoints;
    
    % Interpolate the image to get the warped image
    % I'm not sure why I = warpH(It1, M, size(It1)); gives awful results!!!
    I = interp2(X, Y, It1, WX(1, :)', WX(2, :)');
    I = reshape(I, size(It1));

    % Find the common regions between warped image of It1 and It
    common = ~isnan(I);
    
    % Correct NaNs in the warped image and reshape
    I(isnan(I)) = 0;

    % (2) Compute the error image
    D = It - I;

    % (3) Warp the gradients of I (select the region of interest)
    Ix = interp2(X, Y, It1x, WX(1, :)', WX(2, :)');
    Ix(~common) = 0;
    Iy = interp2(X, Y, It1y, WX(1, :)', WX(2, :)');
    Iy(~common) = 0;
    
    % (4) Evaluate the Jacobian (dW/dp) and
    % (5) compute the steepest descent images
    SD = [Ix(:) .* X(:),    Iy(:) .* X(:),     Ix(:) .* Y(:), ...
          Iy(:) .* Y(:),    Ix(:),              Iy(:)           ];
    
    % (6) Compute the Hessian matrix
    H = SD' * SD;
    
    % (7) Compute right-hand side of the equation H * deltap = b
    b = SD' * D(:);
    
    % (8) Compute delta p
    deltap = H \ b;
    
    % (9) Update p
    p = p + deltap;

end

end
