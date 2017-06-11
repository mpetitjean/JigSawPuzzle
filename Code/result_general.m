clear all; close all;

ls_mean = [];
ls_method = cellstr(['ssd    ';'lpq    ';'mgc    ';'m+s    ';'m+lpq  ';'wmgc   ';'wmgclpq']);
blk_size = 56;

for j = 1:length(ls_method) % accuracy for each method
    j
    method = char(ls_method(j));
    mean = 0 ;
    for i = 1:20 % for each picture in the set of images
        i
        path = strcat('imData/',int2str(i),'.png');
        res = main(path,blk_size,method,2,2,1);
        mean = mean + res;
    end
    ls_mean(j) = 100 - mean/20; %percentge of badly positioned pieces
end






% [y, x, z] = size(A0);
% 
% subplot(1,2,1);
% imshow(A0);
% 
% Nside=260;
% A=A0;
% 
% if (mod(y,Nside) ~= 0)
%     y = y-mod(y,Nside);
%     A = A(:,1:y,:);
% end
% 
% if(mod(x,Nside) ~= 0)
%     x = x-mod(x,Nside);
%     A = A(1:x,:,:);
% end
% 
% subplot(1,2,2)
% imshow(A);