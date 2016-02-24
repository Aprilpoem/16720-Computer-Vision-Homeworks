function [compareX, compareY] = makeTestPattern(patchWidth, nbits)

% Use the uniform distribution to generate random pairs
compareX = randi(patchWidth^2, nbits, 1);
compareY = randi(patchWidth^2, nbits, 1);

% Save the random pairs to a file
save('testPattern.mat', 'compareX', 'compareY');

% % Plot the generated test patterns
% figure; 
% hold on
% [X1, Y1] = ind2sub([patchWidth, patchWidth], compareX);
% [X2, Y2] = ind2sub([patchWidth, patchWidth], compareY);
% plot([X1'; X2'], [Y1'; Y2'], 'b');
% ax = gca;
% half = floor(patchWidth / 2);
% ax.XTickLabel = -half : half;
% ax.YTickLabel = -half : half;
