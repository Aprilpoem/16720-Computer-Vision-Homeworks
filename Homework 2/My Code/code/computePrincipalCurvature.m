function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)

% Initialize output with zeros
PrincipalCurvature = zeros(size(DoGPyramid));

for l = 1 : size(DoGPyramid, 3)
    % Calculate Hessian elements
    [Dx, Dy] = gradient(DoGPyramid(:, :, l));
    [Dxx, Dxy] = gradient(Dx);
    [Dyx, Dyy] = gradient(Dy);
    
    % Calculate Principal Curvatures
    PrincipalCurvature(:, :, l) = (Dxx + Dyy).^2 ./ (Dxx .* Dyy - Dxy .* Dyx);
end
