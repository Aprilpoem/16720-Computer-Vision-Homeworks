function [u, v] = LucasKanadeBasis(It, It1, rect, basis)

% Convert input images to double
It = im2double(It);
It1 = im2double(It1);

% Initialize parameters
tol = 0.1;
lambda = zeros(size(basis, 3), 1);
started = 0;
p = [0 0]';
errcomp = 0.1; % To compensate the floating point operation error 

% Compute the initial template that we want to track
[X, Y] = meshgrid(rect(1) : rect(3) + errcomp, rect(2) : rect(4) + errcomp);
T = interp2(It, X, Y);

%% Lucas-Kanade Tracking with Appearance Basis
while norm(lambda) >= tol || started == 0

    started = 1;
    
    deltap = 2 * [tol tol]';

    % Compute the template that we want to track
    for i = 1 : size(basis, 3)
        T = T + lambda(i) * basis(:, :, i);
    end

    %% Find optimal p = [u, v]
    % Implementation of Inverse Compositional Lucas-Kanade algorithm with
    % weighted L2 norm according to the steps in section 3.1 and 3.4 of 
    % Ref. [2] of PDF description

    % (3) Evaluate the gradient of the template
    [Tx, Ty] = gradient(T);

    % % Calculate the Weight Matrix
    % Q = eye(size(basis, 1) * size(basis, 2));
    % for m = 1 : size(basis, 3)
    %     basism = basis(:, :, m);
    %     Q = Q - kron(basism(:), basism(:)');
    % end

    % (4) Evaluate the Jacobian, (5) compute steepest descent images of the 
    % template (Equation (46) of Ref [2]).
    SDQ = [Tx(:) Ty(:)]';
    for m = 1 : size(basis, 3)
        basism = basis(:, :, m);
        SDQ = SDQ - (basism(:)' * [Tx(:) Ty(:)])' * basism(:)';
    end

    % (6) Compute the Hessian matrix using Equation (48) of Ref. [2].
    H = SDQ * SDQ';

    % Lucas-Kanade iterative algorithm
    ps = [];
    while norm(deltap) >= tol

        % (1) Warp I (select the region of interest)
        [X, Y] = meshgrid((rect(1) : rect(3) + errcomp) + p(1), ...
            (rect(2) : rect(4) + errcomp) + p(2));
        I = interp2(It1, X, Y);

        % (2) Compute the error image
        D = I - T;

        % (7) Compute right-hand side of the equation H * deltap = b
        b = SDQ * D(:);

        % (8) Compute delta p
        deltap = H \ b;

        % (9) Update warp
        p = p - deltap;
        ps = [ps, deltap];
    end

%     subplot(2,1,1);
%     plot(ps(1, 1:end-1));
%     subplot(2,1,2);
%     plot(ps(2, 1:end-1));
    % Update u and v
    u = p(1);
    v = p(2);

    %% Find optimal weights
    % According to Equation (43) in Ref. [2] of the PDF description

    % Calculate Error Image
    [X, Y] = meshgrid((rect(1) : rect(3) + errcomp) + u, ...
        (rect(2) : rect(4) + errcomp) + v);
    I = interp2(It1, X, Y);
    D = I - T;

    % Calculation of the weights
    lambda = zeros(size(basis, 3), 1);
    for i = 1 : size(basis, 3)
        basisi = basis(:, :, i);
        lambda(i) = basisi(:)' * D(:);
    end
    
end

end
