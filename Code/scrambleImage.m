% From image to puzzle

clear;
close all;

A = im2double(imread('mandrill.tif'));
[m, n] = size(A);

% Number of rows and columns of puzzle
rows    = 3;
cols    = 3;
% Determine randomly if the shape is going to be convex or concave
pattern = round(rand(rows,cols));
pattern = [2*ones(1,cols+2); 2*ones(rows,1) pattern 2*ones(rows,1); 2*ones(1,cols+2)];

% Parameters of the circular shape
r = 15;
shift = 15;
offset = 2*r-shift;

for jj = 1:rows
for ii = 1:cols+1
    
    % Cover zell with zeros
    % Big enough to contain convex shapes
    cell = zeros(m/(2*(rows-1))+4*r-2*shift,n/(2*(cols-1))+4*r-2*shift);
    alpha = zeros(size(cell));
    
    % Copy initial square of subimage
    alpha(1+offset:m/(2*(rows-1))+offset,1+offset:(n)/(2*(cols-1))+offset) = ones(m/(2*(rows-1)),(n)/(2*(cols-1)));
    cell(1+offset:m/(2*(rows-1))+offset,1+offset:(n)/(2*(cols-1))+offset) = A(1:m/(2*(rows-1)),1+(n*(ii-1))/(2*(cols-1)):(n*(ii))/(2*(cols-1)));
    
    %---------------------------
    % Check pattern on the right
    %---------------------------
    if (pattern(jj+1,ii+1) == 1)
        % Equal to 1 => convex shape
        
        % Center of circular shape
        y_center = m/(4*(rows-1)); % Half of subsquare
        x_center = (n*ii)/(2*(cols-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = m/(4*(rows-1))-r:m/(4*(rows-1))+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*ii)/(2*(cols-1)):(n*ii)/(2*(cols-1))+offset
                if (x > min && x < max)
                    cell(y+offset,x-(n*(ii-1))/(2*(cols-1))+offset) = A(y,x);
                    alpha(y+offset,x-(n*(ii-1))/(2*(cols-1))+offset) = 1;
                end
            end
        end
        
    elseif (pattern(jj+1,ii+1) == 0)
        % Equal to 0 => concave shape
 
        % Center of circular shape
        y_center = m/(4*(rows-1));                  % Half of subsquare
        x_center = (n*ii)/(2*(cols-1))+shift-r;     % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = m/(4*(rows-1))-r:m/(4*(rows-1))+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*ii)/(2*(cols-1))-2*r+shift:(n*ii)/(2*(cols-1))
                if (x > min && x < max)
                    cell(y+offset,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                    alpha(y+offset,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                end
            end
        end
        
    end
    % Do nothing if on the border of the picture
    
    %---------------------------
    % Check pattern on the left
    %---------------------------
    if (pattern(jj+1,ii) == 1)
        % Equal to 1 => concave shape
        
         % Center of circular shape
        y_center = m/(4*(rows-1));                  % Half of subsquare
        x_center = (n*(ii-1))/(2*(cols-1))+shift-r;     % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = m/(4*(rows-1))-r:m/(4*(rows-1))+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*(ii-1))/(2*(cols-1)):(n*(ii-1))/(2*(cols-1))+offset
                if (x > min && x < max)
                    cell(y+offset,x+1-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                    alpha(y+offset,x+1-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                end
            end
        end
        
    elseif (pattern(jj+1,ii) == 0)
        % Equal to 0 => convex shape
        
        % Center of circular shape
        y_center = m/(4*(rows-1)); % Half of subsquare
        x_center = (n*(ii-1))/(2*(cols-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = m/(4*(rows-1))-r:m/(4*(rows-1))+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*(ii-1))/(2*(cols-1))-2*r+shift:(n*(ii-1))/(2*(cols-1))
                if (x > min && x < max)
                    cell(y+offset,x-(n*(ii-1))/(2*(cols-1))+offset) = A(y,x);
                    alpha(y+offset,x-(n*(ii-1))/(2*(cols-1))+offset) = 1;
                end
            end
        end
    end
    % Do nothing if on the border of the picture
    
    eval(sprintf('puzzle.cell_%d=cell;', ii));
    eval(sprintf('puzzle.alpha_%d=alpha;', ii));
    subplot(rows+1,cols+1,ii+(jj-1)*rows+jj-1)
    h = imshow(cell);
    set(h, 'AlphaData', alpha)
end
end

disp(pattern)

    
    
    
    
    
    
    
    
    
    
    