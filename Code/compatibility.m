function rate = compatibility(start, candidate, loc, pattern,ssd)
[x, y] = find(pattern==start);
[m, n] = size(pattern);
switch loc
    case 1
        y = y +1;
        if y > n
            y = n;
            pattern = circshift(pattern,-1,2);
        end
    case 2
        y = y -1;
        if y < 1
            y = 1;
            pattern = circshift(pattern,1,2);
        end
    case 3
        x = x + 1;
        if x > m
            x = m;
            pattern = circshift(pattern,-1,1);
        end
    case 4
        x = x -1;
        if x < 1
            x = 1;
            pattern = circshift(pattern,1,1);
        end
end
rate = 1;
if x > 1 && pattern(x-1,y) ~= 0
   rate = rate * ssd(pattern(x-1,y),candidate,3);
end
if y > 1 && pattern(x,y-1) ~= 0 
   rate = rate * ssd(pattern(x,y-1),candidate,1);
end
if x < m && pattern(x+1,y) ~= 0
   rate = rate * ssd(pattern(x+1,y),candidate,4);
end
if y < n && pattern(x,y+1) ~= 0
   rate = rate * ssd(pattern(x,y+1),candidate,2);
end
% if rate == 1
%     keyboard
% end