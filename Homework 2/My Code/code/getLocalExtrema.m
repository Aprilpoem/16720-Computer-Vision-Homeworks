function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, ...
    PrincipalCurvature, th_contrast, th_r)

% Calculate extremums in DoG pyramid
Extremums = abs(DoGPyramid) > th_contrast & ...
            PrincipalCurvature < th_r & ...
            (imregionalmax(DoGPyramid, 26) | imregionalmin(DoGPyramid, 26));

% Calculate the output extremum indices
[Y, X, L] = ind2sub(size(DoGPyramid), find(Extremums));
locsDoG = [X, Y, DoGLevels(L)'];
