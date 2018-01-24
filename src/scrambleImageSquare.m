function [y, x, z, puzzle, scramble] = scrambleImageSquare(image, Nside,showFlag)

% Read image
A = im2double(imread(image));
[y, x, z] = size(A);

if (mod(y,Nside) ~= 0)
    error('Vertical dimension not compatible')
elseif(mod(x,Nside) ~= 0)
    error('Horizontal dimension not compatible')
end

% Division in subimages
puzzle = mat2cell(A,repmat(Nside,1,y/Nside),repmat(Nside,1,x/Nside),z).';

if showFlag
    figure;
    for i = 1:numel(puzzle)
       subplot(y/Nside,x/Nside,i)
       imshow(puzzle{i});
    end
    mtit('Cut image');
end

% Scrambling
scramble = randperm(numel(puzzle));
puzzle = puzzle(scramble);

if showFlag
    figure;
    for i = 1:numel(puzzle)
       subplot(y/Nside,x/Nside,i)
       imshow(puzzle{i});
    end
    mtit('Scrambled image');
end
