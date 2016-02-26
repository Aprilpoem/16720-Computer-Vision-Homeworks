function [u, v] = LucasKanade(It, It1, rect)
It = im2double(It);
It1 = im2double(It1);

% Initialize parameters
tol = 0.1;
p = [0 0]';
deltap = 2 * [tol tol]';

% Isolate the template that we want to track
[X, Y] = meshgrid(rect(1) : rect(3), rect(2) : rect(4));
T = interp2(It, X, Y);

% Lucas-Kanade iterative algorithm
while any(abs(deltap) > tol)
    % Isolate current part of the image we want to compare with template
    [X, Y] = meshgrid((rect(1) : rect(3)) + p(1), ...
        (rect(2) : rect(4)) + p(2));
    I = interp2(It1, X, Y);

    % Calculate the gradient
    [Ix, Iy] = gradient(I);
    
    % Calculate delta p
    A = [Ix(:) Iy(:)]' * [Ix(:) Iy(:)];
    b = -[Ix(:) Iy(:)]' * (I(:) - T(:));
    deltap = A \ b;
    
    % Update p
    p = p + deltap;
end

% Update u and v
u = p(1);
v = p(2);

end