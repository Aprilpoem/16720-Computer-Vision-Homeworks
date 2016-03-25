function [M1, M2, P] = computeProjectiveMatrices(F, K1, K2, pts1, pts2)

% Compute the essential matrix from the fundamental matrix
E = essentialMatrix(F, K1, K2);

% Define the projective camera matrix M1
M1 = [eye(3), zeros(3, 1)];

% Calculate the candidate projective camera matrices M2
M2s = camera2(E);

% Multiply the given intrinsics matrices with the canonical camera matrices
M1 = K1 * M1;
for i = 1 : size(M2s, 3)
    M2s(:, :, i) = K2 * squeeze(M2s(:,:,i));
end

% Find the correct M2 from M2s
P = [];
M2 = [];
for i = 1 : size(M2s, 3)
    
    % Obtain the current M2 matrix
    M2_i = squeeze(M2s(:, :, i));
    
    % Perform the triangulation
    [P_i, ~] = triangulate(M1, pts1, M2_i, pts2);

    % Check if all 3D points are in front of the cameras
    if all(P_i(:, 3) > 0)
        P = P_i;
        M2 = M2_i;
    end
    
end
