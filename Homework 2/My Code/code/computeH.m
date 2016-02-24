function H2to1 = computeH(p1,p2)
% Maps p2 to p1

% Initialize the number of point pairs
N = size(p1, 2);

% Normalize point coordinates
[p1, T1] = normalizePoints(p1);
[p2, T2] = normalizePoints(p2);

% Convert point coordinates to homogeneus coordinates; also change x column
% with y column
p1 = [p1(1, :)', p1(2, :)', ones(N, 1)];
p2 = [p2(1, :)', p2(2, :)', ones(N, 1)];

% Calculate matrix of independent equations A
A = [   -p2,           zeros(N, 3),    p2 .* repmat(p1(:, 1), 1, 3) ;
        zeros(N, 3),    -p2,           p2 .* repmat(p1(:, 2), 1, 3) ];

% Calculate Homography (H2to1) matrix in normalized coordinates
[V, ~] = eig(A' * A);
H2to1 = reshape(V(:, 1), 3, 3)';

% Calculate Homography (H2to1) matrix
H2to1 = T1 \ H2to1 * T2;

% Normalize the Homography matrix to have determinant = 1
H2to1 = real(H2to1 ./ det(H2to1)^(1/3));