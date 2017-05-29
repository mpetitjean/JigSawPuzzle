function [startposrow, startposcol, ssd, startpiece, patternCheck] = ...
    checkPattern(pattern, startposrow, startposcol, blk_size, ssd)

ii = round((startposrow-1)/blk_size)+2;
jj = round((startposcol-1)/blk_size)+2;

patternCheck = [ones(1,size(pattern,2)+2); ...
                ones(size(pattern,1),1), pattern, ones(size(pattern,1),1); ...
                ones(1,size(pattern,2)+2)]
    
% Find 0's in the pattern
[iNz, jNz] = find(patternCheck==0);
changed = 0;
% Check if the piece is cornered
while( patternCheck(ii+1,jj) ~= 0 && patternCheck(ii-1,jj) ~= 0 && ...
        patternCheck(ii,jj-1) ~= 0 && patternCheck(ii,jj+1) ~= 0 )
    
    disp('Cornered !') 
    disp(patternCheck)
    
    % Find new position
    ii = iNz(1);
    jj = jNz(1);
    
    iNz(1) = [];
    jNz(1) = [];
    
    if (patternCheck(ii-1,jj) ~= 1 && patternCheck(ii-1,jj) ~= 0)
        startpiece = pattern(ii-2,jj-1)
    elseif (patternCheck(ii+1,jj) ~= 1 && patternCheck(ii+1,jj) ~= 0)
        startpiece = pattern(ii,jj-1)
    elseif (patternCheck(ii,jj-1) ~= 1 && patternCheck(ii,jj-1) ~= 0)
        startpiece = pattern(ii-1,jj-2)
    elseif (patternCheck(ii,jj+1) ~= 1 && patternCheck(ii,jj+1) ~= 0)
        startpiece = pattern(ii-1,jj)
    end
    
    changed = 1;
end

startposrow = (ii-2)*blk_size + 1;
startposcol = (jj-2)*blk_size + 1;
disp(ii)
disp(jj)

disp(pattern)

if changed == 0
    startpiece = pattern(ii-1,jj-1)
end



