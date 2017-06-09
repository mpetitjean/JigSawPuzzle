function estimation = myestimate(pattern, bestbuddy)
estimation = 0;
[m, n] = size(pattern);
for ii=1:m-1
    for jj= 1:n
        estimation = estimation + (bestbuddy(pattern(ii,jj),3) == pattern(ii+1,jj));
    end
end

for jj= 1:n-1
    for ii=1:m
        estimation = estimation + (bestbuddy(pattern(ii,jj),1) == pattern(ii,jj+1));
    end
end