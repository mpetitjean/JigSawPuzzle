function bestbuddy =  computebestbuddy(ssd)
bestbuddy = zeros(size(ssd,1),4);
for start = 1:size(ssd,1)
    for loc = 1:4
        [~, bestmatch] =  min(ssd(start,:,loc));
        if (loc == 1 || loc == 3)
            op = loc+1;
        else
            op = loc-1;
        end
        [~, stop] = min(ssd(bestmatch,:,op));
        if stop == start
            bestbuddy(start,loc) = bestmatch;
        end
   end
end