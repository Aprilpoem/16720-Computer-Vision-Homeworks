function [u, v] = LucasKanadeBasis(It, It1, rect, basis)
% Convert input images to double
It = im2double(It);
It1 = im2double(It1);

% Initialize parameters
tol = 0.1;
deltap = 2 * [tol tol]';
p = [0 0]';

% Compute the template that we want to track
[X, Y] = meshgrid(rect(1) : rect(3), rect(2) : rect(4));
T = interp2(It, X, Y);

%% Implementation of normal Lucas-Kanade algorithm according to the 
% steps in Ref. [1] of PDF description

% Caclulate the gradient
[It1x, It1y] = gradient(It1);

% Lucas-Kanade iterative algorithm
while norm(deltap) >= tol
    
    % (1) Warp I (select the region of interest)
    [X, Y] = meshgrid((rect(1) : rect(3)) + p(1), ...
        (rect(2) : rect(4)) + p(2));
    I = interp2(It1, X, Y);

    % (2) Compute the error image
    D = T - I;
    
    % (3) Warp the gradients (select the region of interest)
    Ix = interp2(It1x, X, Y);
    Iy = interp2(It1y, X, Y);
    
    % (4) Evaluate the Jacobian, (5) compute the steepest descent images
    % and (6) Compute the Hessian matrix
    H = [Ix(:) Iy(:)]' * [Ix(:) Iy(:)];
    
    % (7) Compute right-hand side of the equation H * deltap = b
    b = [Ix(:) Iy(:)]' * D(:);
    
    % (8) Compute delta p
    deltap = H \ b;
    
    % (9) Update p
    p = p + deltap;

end

% Update u and v
u = p(1);
v = p(2);

end

