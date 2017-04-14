function puzzle = scrambleImage(image, rows, cols)

A = im2double(imread(image));
[m, n] = size(A);

% Number of subdivisions of puzzle
rows    = rows-1;
cols    = cols-1;

% Check if image dimension are comaptible with wanted subdivision
if( mod(m,(2*(rows-1))) ~= 0)
    error('Incompatible image dimension and number of rows');
elseif(mod(n,(2*(cols-1))) ~= 0)
    error('Incompatible image dimension and number of columns');
end

figure;
imshow(A)
title('Original image');

% Determine randomly if the shape is going to be convex or concave

% Left and Right
patternLR = round(rand(rows+1,cols));
patternLR = [2*ones(1,cols+2); 2*ones(rows+1,1) patternLR 2*ones(rows+1,1); 2*ones(1,cols+2)];

% Top and Bottom
patternTB = round(rand(rows,cols+1));
patternTB = [2*ones(1,cols+3); 2*ones(rows,1) patternTB 2*ones(rows,1); 2*ones(1,cols+3)];

% Parameters of the circular shape
r = round((m+1)/(5*(rows+1)));
shift = r;
offset = 2*r-shift;


figure;
count = 1;
title('Cut image');
for jj = 1:rows+1
for ii = 1:cols+1
    
    % Cover zell with zeros
    % Big enough to contain convex shapes on all sides
    cell = zeros(m/(2*(rows-1))+4*r-2*shift,n/(2*(cols-1))+4*r-2*shift);
    alpha = zeros(size(cell));
    
    % Copy initial square of subimage
    alpha(1+offset:m/(2*(rows-1))+offset,1+offset:(n)/(2*(cols-1))+offset) = ones(m/(2*(rows-1)),(n)/(2*(cols-1)));
    cell(1+offset:m/(2*(rows-1))+offset,1+offset:(n)/(2*(cols-1))+offset) = A(1+(m*(jj-1))/(2*(rows-1)):(m*jj)/(2*(rows-1)),1+(n*(ii-1))/(2*(cols-1)):(n*(ii))/(2*(cols-1)));
    
    %---------------------------
    % Check pattern on the right
    %---------------------------
    if (patternLR(jj+1,ii+1) == 1)
        % Equal to 1 => convex shape
        
        % Center of circular shape
        y_center = (m)/(4*(rows-1))+(m*(jj-1))/(2*(rows-1)); % Half of subsquare
        x_center = (n*ii)/(2*(cols-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = y_center-r:y_center+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*ii)/(2*(cols-1)):(n*ii)/(2*(cols-1))+offset
                if (x > min && x < max)
                    cell(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = A(y,x);
                    alpha(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 1;
                end
            end
        end
        
    elseif (patternLR(jj+1,ii+1) == 0)
        % Equal to 0 => concave shape
 
        % Center of circular shape
        y_center = m*jj/(4*(rows-1));                  % Half of subsquare
        x_center = (n*ii)/(2*(cols-1))+shift-r;     % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = m*jj/(4*(rows-1))-r:m*jj/(4*(rows-1))+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*ii)/(2*(cols-1))-2*r+shift:(n*ii)/(2*(cols-1))
                if (x > min && x < max)
                    cell(y-m*(jj-1)/(4*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                    alpha(y-m*(jj-1)/(4*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                end
            end
        end
        
    end
    % Do nothing if on the border of the picture (pattern == 2)
    
    %---------------------------
    % Check pattern on the left
    %---------------------------
    if (patternLR(jj+1,ii) == 1)
        % Equal to 1 => concave shape
        
         % Center of circular shape
        y_center = (m)/(4*(rows-1))+(m*(jj-1))/(2*(rows-1));                 % Half of subsquare
        x_center = (n*(ii-1))/(2*(cols-1))+shift-r;     % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = y_center-r:y_center+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*(ii-1))/(2*(cols-1)):(n*(ii-1))/(2*(cols-1))+offset
                if (x > min && x < max)
                    cell(y-m*(jj-1)/(2*(rows-1))+r,x+1-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                    alpha(y-m*(jj-1)/(2*(rows-1))+r,x+1-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                end
            end
        end
        
    elseif (patternLR(jj+1,ii) == 0)
        % Equal to 0 => convex shape
        
        % Center of circular shape
        y_center = (m)/(4*(rows-1))+(m*(jj-1))/(2*(rows-1)); % Half of subsquare
        x_center = (n*(ii-1))/(2*(cols-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for y = y_center-r:y_center+r
            min = x_center - sqrt(r^2 - (y-y_center)^2);
            max = x_center + sqrt(r^2 - (y-y_center)^2);
            for x = (n*(ii-1))/(2*(cols-1))-2*r+shift:(n*(ii-1))/(2*(cols-1))
                if (x > min && x < max)
                    cell(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = A(y,x);
                    alpha(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 1;
                end
            end
        end
    end
    % Do nothing if on the border of the picture (pattern == 2)
    
    %----------------------------
    % Check pattern on the bottom
    %----------------------------
    if (patternTB(jj+1,ii+1) == 0)
        % 0 => Convex at the bottom
        % Center of circular shape
        x_center = (n)/(4*(cols-1))+(n*(ii-1))/(2*(cols-1)); % Half of subsquare
        y_center = (m*jj)/(2*(rows-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for x = x_center-r:x_center+r
            min = y_center - sqrt(r^2 - (x-x_center)^2);
            max = y_center + sqrt(r^2 - (x-x_center)^2);
            for y = (m*jj)/(2*(rows-1)):(m*jj)/(2*(rows-1))+offset
                if (y > min && y < max)
                    cell(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = A(y,x);
                    alpha(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 1;
                end
            end
        end
        
    elseif(patternTB(jj+1,ii+1) == 1)
        % 1 => Concave at the bottom
        
        % Center of circular shape
        x_center = (n)/(4*(cols-1))+(n*(ii-1))/(2*(cols-1)); % Half of subsquare
        y_center = (m*jj)/(2*(rows-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, erase if true        
        for x = x_center-r:x_center+r
            min = y_center - sqrt(r^2 - (x-x_center)^2);
            max = y_center + sqrt(r^2 - (x-x_center)^2);
            for y = (m*jj)/(2*(rows-1))-offset:(m*jj)/(2*(rows-1))
                if (y > min && y < max)
                    cell(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                    alpha(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                end
            end
        end
    % Do nothing if at the border of the image    
    end
    
    %-------------------------
    % Check pattern on the top
    %-------------------------
    if (patternTB(jj,ii+1) == 1)
        % Convex shape at the top
        
        % Center of circular shape
        x_center = (n)/(4*(cols-1))+(n*(ii-1))/(2*(cols-1)); % Half of subsquare
        y_center = (m*(jj-1))/(2*(rows-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for x = x_center-r:x_center+r
            min = y_center - sqrt(r^2 - (x-x_center)^2);
            max = y_center + sqrt(r^2 - (x-x_center)^2);
            for y = (m*(jj-1))/(2*(rows-1))-r:(m*(jj-1))/(2*(rows-1))+offset
                if (y > min && y < max)
                    cell(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = A(y,x);
                    alpha(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 1;
                end
            end
        end

    elseif (patternTB(jj,ii+1) == 0)
        % Concave shape at the top
        
        % Center of circular shape
        x_center = (n)/(4*(cols-1))+(n*(ii-1))/(2*(cols-1)); % Half of subsquare
        y_center = (m*(jj-1))/(2*(rows-1))-shift+r;    % Side of subsquare

        % See if coordinates fits in a circle, copy if true        
        for x = x_center-r:x_center+r
            min = y_center - sqrt(r^2 - (x-x_center)^2);
            max = y_center + sqrt(r^2 - (x-x_center)^2);
            for y = y_center:y_center+offset
                if (y > min && y < max)
                    cell(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                    alpha(y-m*(jj-1)/(2*(rows-1))+r,x-(n*(ii-1))/(2*(cols-1))+offset) = 0;
                end
            end
        end
    % Do nothing if at the border    
    end
    
    %----------------------
    % Save cell and display
    %----------------------
    eval(sprintf('puzzle.cell_%d=cell;', count));
    eval(sprintf('puzzle.alpha_%d=alpha;', count));
    subplot(rows+1,cols+1,ii+(jj-1)*rows+jj-1)
    h = imshow(cell);
    set(h, 'AlphaData', alpha)
    count = count + 1;
end
end

% Function found on Matlab File exchange to have a supertitle on a subplot
% http://nl.mathworks.com/matlabcentral/fileexchange/3218-mtit--a-pedestrian-major-title-creator
mtit('Cut image in order');

%------------------
% Display scrambled
%------------------

puzzle_size = (rows+1)*(cols+1);
select = 1:puzzle_size;
figure;
count = 1;
a = 'AlphaData';
while (~isempty(select))
    index = round(length(select*(rand(1))+1));
    subplot(rows+1,cols+1,select(index));
    select = select(select~=select(index));
    eval(sprintf('h = imshow(puzzle.cell_%d);', count));
    eval(sprintf('set(h,a, puzzle.alpha_%d);', count));
    count = count + 1;
end
mtit('Cut and scrambled image');
    
    
    
    
    