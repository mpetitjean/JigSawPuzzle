% From image to puzzle

clear;
close all;

A = im2double(imread('mandrill.tif'));
[m, n] = size(A);

% Number of rows and columns of puzzle
rows    = 3;
cols    = 3;
pattern = round(rand(m,n));
pattern = [2*ones(1,n+2); 2*ones(m,1) pattern 2*ones(m,1); 2*ones(1,n+2)];

% Parameters of the circular shape
r = 20;
shift = 15;

for ii = 1:cols-1
    % Determine randomly if the shape is going to be convex or concave
    if (rand(1) > -1)
        % convex shape
        
        % Center of circular shape
        y_center = m/(4*(rows-1)); % Half of subsquare
        x_center = (n*ii)/(2*(cols-1))-shift+r;    % Side of subsquare

        % Cover zell with zeros
        cell = zeros(m/(2*(rows-1))+2*r-shift,(n)/(2*(cols-1))+2*r-shift);
        alpha = zeros(size(cell));
        alpha(1:m/(2*(rows-1)),1:(n)/(2*(cols-1))) = ones(m/(2*(rows-1)),(n)/(2*(cols-1)));

        % See if coordinates fits in a circle, copy if true
        disp(size(cell(1:m/(2*(rows-1)),1:(n)/(2*(cols-1)))))
        disp(size(A(1:m/(2*(rows-1)),1+(n*(ii-1))/(2*(cols-1)):(n*(ii))/(2*(cols-1)))))
        cell(1:m/(2*(rows-1)),1:(n)/(2*(cols-1))) = A(1:m/(2*(rows-1)),1+(n*(ii-1))/(2*(cols-1)):(n*(ii))/(2*(cols-1)));
        for y = m/(4*(rows-1))-r:m/(4*(rows-1))+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*ii)/(2*(cols-1)):(n*ii)/(2*(cols-1))+2*r-shift
                if (x > min && x < max)
                    cell(y,x-(n*(ii-1))/(2*(cols-1))) = A(y,x);
                    alpha(y,x-(n*(ii-1))/(2*(cols-1))) = 1;
                end
            end
        end
        disp(size(cell))
        % Save in cell
        eval(sprintf('puzzle.cell_%d=cell;', ii));
        eval(sprintf('puzzle.alpha_%d=alpha;', ii));
        subplot(1,cols,ii)
        h = imshow(cell);
        %set(h, 'AlphaData', alpha)
        
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

% ----------------------
% Add right convex shape
% ----------------------
% r = 20;
% shift = 15;
%  y_center = m/4;
%  x_center = n/2-shift+r;
% 
% % Cover zell with zeros
% cell = zeros(m/2+2*r-shift,n/2+2*r-shift);
% alpha = zeros(size(cell));
% alpha(1:m/2,1:n/2) = ones(m/2,n/2);
% 
% % See if coordinates fits in a circle, copy if true
% cell(1:m/2,1:n/2) = A(1:m/2,1:n/2);
% for y = m/4-r:m/4+r
%     min = x_center - sqrt(r^2 - (y-y_center)^2);
%     max = x_center + sqrt(r^2 - (y-y_center)^2);
%     for x = n/2:n/2+2*r-shift
%         if (x > min && x < max)
%             cell(y,x) = A(y,x);
%             alpha(y,x) = 1;
%         end
%     end
% end
% 
% % ----------------------
% % Add bottom convex shape
% % ----------------------
%y_center = m/2-shift+r;
%x_center = n/4;
%
% 
% % See if coordinates fits in a circle, copy if true
% cell(1:m/2,1:n/2) = A(1:m/2,1:n/2);
% for y = m/2:m/2+2*r-shift
%     min = x_center - sqrt(r^2 - (y-y_center)^2);
%     max = x_center + sqrt(r^2 - (y-y_center)^2);
%     for x = n/4-r:n/4+r
%         if (x > min && x < max)
%             cell(y,x) = A(y,x);
%             alpha(y,x) = 1;
%         end
%     end
% end

    
    
    
    
    
    
    
    
    
    
    