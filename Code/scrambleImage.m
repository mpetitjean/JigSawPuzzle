% From image to puzzle

clear;
close all;

A = im2double(imread('mandrill.tif'));
[m, n] = size(A);

% Number of rows and columns of puzzle
rows    = 2;
col     = 1;

for ii = 1:rows
    % Determine randomly if the shape is going to be convex or concave
    if (rand(1) > 0.5)
        % convex shape
    else
        % concave shape
    end
end

% for a=1:4
% s=strcat('vec_',num2str(a)); %make the name of the vector
% s1=eval(s); %get the value of the vector
% s1(3:end)=[]; %keep only column 1 and 2
% assignin('base',s,s1) %update the value of the vector
% end

%eval(sprintf('vec_%d=A(1:20,1:20)', a));