function freeloc = updatelocations(x, y, freeloc)
freeloc(x,y) = -1;
[m, n] = size(freeloc);
xn = x + [-1 1 0 0];
yn = y + [0 0 -1 1];
for ii = 1:length(xn)
    if xn(ii) < m+1 && xn(ii) > 0 && yn(ii) < n+1 && yn(ii) > 0
        if ~freeloc(xn(ii), yn(ii))
            freeloc(xn(ii), yn(ii)) = 1;
        end
    end
end