function puzzle = scrambleImageSquare(image, Nside)

% Read image
A = im2double(imread(image));
[y, x] = size(A);

if (mod(y,Nside) ~= 0)
    error('Vertical dimension not compatible')
elseif(mod(x,Nside) ~= 0)
    error('Horizontal dimension not compatible')
end

% Division in subimages
puzzle = reshape(permute(reshape(A, Nside, y/Nside, []),[1 3 2]), Nside, Nside, []);

% figure;
% for i = 1:y*x/(Nside^2)
%    subplot(y/Nside,x/Nside,i)
%    imshow(puzzle(:,:,i));
% end
% mtit('Cut image');

% Scrambling
puzzle = puzzle(:,:,randperm(y*x/(Nside^2)));
 
% figure;
% for i = 1:y*x/(Nside^2)
%    subplot(y/Nside,x/Nside,i)
%    imshow(puzzle(:,:,i));
% end
% mtit('Scrambled image');

