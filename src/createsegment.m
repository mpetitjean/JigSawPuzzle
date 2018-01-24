function [mysegment, segname] = createsegment(pattern, bestbuddy)
[m, n] = size(pattern);
mysegment = zeros(m,n);
segname = 0;
queue = zeros(min(m,n),1);

while ~all(all(mysegment))
   segname = segname + 1;
   possibility = pattern(mysegment==0);
   ind = randperm(length(possibility));
   queue(1)=possibility(ind(1));
   while queue(1) ~= 0
       start = queue(1);
       [x, y] = find(pattern == start);
       mysegment(x,y) = segname;
       queue(1) = 0;
       queue = circshift(queue, -1);
       for dx = -1:1
           for dy = -1:1
               res = 1;
               xn = x+dx;
               yn = y+dy;
               if (dx * dy == 0 && dx ~= dy) && ...
                       (xn >= 1 && xn <= m && yn >= 1 && yn <= n)
                   if mysegment(xn,yn) == 0
                       if xn > 1 && mysegment(xn-1,yn) == segname
                           res = res & bestbuddy(pattern(xn,yn),4) == ...
                               pattern(xn-1,yn);
                       end
                       if yn > 1 && mysegment(xn,yn-1) == segname 
                           res = res & bestbuddy(pattern(xn,yn), 2)== ...
                               pattern(xn,yn-1);
                       end
                       if xn < m && mysegment(xn+1,yn) == segname
                           res = res & bestbuddy(pattern(xn,yn),3) == ...
                               pattern(xn+1,y);
                       end
                       if yn < n && mysegment(xn,yn+1) == segname
                           res = res & bestbuddy(pattern(xn,yn), 1)== ...
                               pattern(xn,yn+1);
                       end
                       if res
                           mysegment(xn,yn) = segname;
                           queue(find(queue==0,1)) = pattern(xn,yn);
                       else
                           mysegment(xn,yn) = -1;
                       end
                   end
               end
           end
       end
   end
   mysegment(mysegment == -1) = 0;
end