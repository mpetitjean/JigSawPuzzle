function [y, x, puzzle, puzzlePattern] = scrambleImageSquare(image, Nside,showFlag)

% Read image
A = im2double(rgb2gray(imread(image)));
[y, x] = size(A);

if (mod(y,Nside) ~= 0)
    error('Vertical dimension not compatible')
elseif(mod(x,Nside) ~= 0)
    error('Horizontal dimension not compatible')
end

% Division in subimages
puzzle = reshape(permute(reshape(A, Nside, y/Nside, []),[1 3 2]), Nside, Nside, []);
puzzlePattern =  reshape(1:y*x/(Nside^2), y/Nside, x/Nside).';

if showFlag
    figure;
    for i = 1:y*x/(Nside^2)
       subplot(y/Nside,x/Nside,i)
       imshow(puzzle(:,:,i));
    end
    mtit('Cut image');
end

% Scrambling
scramble = randperm(y*x/(Nside^2));
puzzle = puzzle(:,:,scramble);
puzzlePattern = reshape(scramble, y/Nside, x/Nside).';

if showFlag
    figure;
    for i = 1:y*x/(Nside^2)
       subplot(y/Nside,x/Nside,i)
       imshow(puzzle(:,:,i));
    end
    mtit('Scrambled image');
end
