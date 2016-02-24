function histInter = distanceToSet(wordHist, histograms)

% Calculate the histogram intersections
intersections = bsxfun(@min, histograms, repmat(wordHist, 1, size(histograms, 2)));

% Calculate the similarities
histInter = sum(intersections);
