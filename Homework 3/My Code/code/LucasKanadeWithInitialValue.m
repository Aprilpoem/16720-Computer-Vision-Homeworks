function [u, v] = LucasKanadeWithInitialValue(It, It1, rect, p)

% Convert input images to double
It = im2double(It);
It1 = im2double(It1);

% Initialize parameters
tol = 0.1;
deltap = 2 * [tol tol]';

% Compute the template that we want to track
[X, Y] = meshgrid(rect(1) : rect(3), rect(2) : rect(4));
T = interp2(It, X, Y);

%% Implementation of normal Lucas-Kanade algorithm according to the 
% formulation I derived in the writeup

% % Lucas-Kanade iterative algorithm
% while any(abs(deltap) > tol)
%     
%     % Isolate current part of the image we want to compare with template
%     [X, Y] = meshgrid((rect(1) : rect(3)) + p(1), ...
%         (rect(2) : rect(4)) + p(2));
%     I = interp2(It1, X, Y);
% 
%     % Calculate the gradient
%     [Ix, Iy] = gradient(I);
%     
%     % Calculate delta p
%     A = [Ix(:) Iy(:)]' * [Ix(:) Iy(:)];
%     b = -[Ix(:) Iy(:)]' * (I(:) - T(:));
%     deltap = A \ b;
%     
%     % Update p
%     p = p + deltap;
%         
% end
% 
% % Update u and v
% u = p(1);
% v = p(2);

%% Implementation of normal Lucas-Kanade algorithm according to the 
% steps in Ref. [1] of PDF description

% % Caclulate the gradient
% [It1x, It1y] = gradient(It1);
% 
% % Lucas-Kanade iterative algorithm
% while norm(deltap) >= tol
%     
%     % (1) Warp I (select the region of interest)
%     [X, Y] = meshgrid((rect(1) : rect(3)) + p(1), ...
%         (rect(2) : rect(4)) + p(2));
%     I = interp2(It1, X, Y);
% 
%     % (2) Compute the error image
%     D = T - I;
%     
%     % (3) Warp the gradients (select the region of interest)
%     Ix = interp2(It1x, X, Y);
%     Iy = interp2(It1y, X, Y);
%     
%     % (4) Evaluate the Jacobian, (5) compute the steepest descent images
%     % and (6) Compute the Hessian matrix
%     H = [Ix(:) Iy(:)]' * [Ix(:) Iy(:)];
%     
%     % (7) Compute right-hand side of the equation H * deltap = b
%     b = [Ix(:) Iy(:)]' * D(:);
%     
%     % (8) Compute delta p
%     deltap = H \ b;
%     
%     % (9) Update p
%     p = p + deltap;
% 
% end
% 
% % Update u and v
% u = p(1);
% v = p(2);

%% Implementation of Inverse Compositional Lucas-Kanade algorithm 
% according to the steps in section 2.2 of Ref. [2] of PDF description

% (3) Evaluate the gradient of the template
[Tx, Ty] = gradient(T);

% (4) Evaluate the Jacobian, (5) steepest descent images of the template
% and (6) Compute the Hessian matrix
H = [Tx(:) Ty(:)]' * [Tx(:) Ty(:)];

% Lucas-Kanade iterative algorithm
while norm(deltap) >= tol

    % (1) Warp I (select the region of interest)
    [X, Y] = meshgrid((rect(1) : rect(3)) + p(1), ...
        (rect(2) : rect(4)) + p(2));
    I = interp2(It1, X, Y);

    % (2) Compute the error image
    D = I - T;
    
    % (7) Compute right-hand side of the equation H * deltap = b
    b = [Tx(:) Ty(:)]' * D(:);
    
    % (8) Compute delta p
    deltap = H \ b;
    
    % (9) Update warp
    p = p - deltap;
end

% Update u and v
u = p(1);
v = p(2);

end
