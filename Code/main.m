% todo: project

clear, close all;

% Parameters
image = 'lenagray.tif';

% Cut in subimages and scramble
puzzle = scrambleImageSquare(image, 128);

% Compute Sum of Squared Distance
ssd = computeSSD(puzzle);

% Compute Mahalanobis Gradient Compatibility
mgc = computeMGC(puzzle);
