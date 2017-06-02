function [bestmpiece, loc, startposrow, startposcol] = findbestmatch(pieces, ssd, pattern, blk_size)
[maxi, bestmpiece] = max(max(ssd(pieces(1),:,:),[],3));
[~, loc] = max(ssd(pieces(1),bestmpiece,:));
[m,n] = find(pattern == pieces(1));
startposrow = 1+(m-1)*blk_size;
startposcol = 1+(n-1)*blk_size;
for ii = 2:length(pieces)
    [ismaxi, mpiece] = max(max(ssd(pieces(ii),:,:),[],3));
    if ismaxi > maxi
        maxi = ismaxi;
        bestmpiece = mpiece;
        [~, loc] = max(ssd(pieces(ii),bestmpiece,:));
        [m,n] = find(pattern == pieces(ii));
        startposrow = 1+(m-1)*blk_size;
        startposcol = 1+(n-1)*blk_size;
    end
end
disp(pattern(m,n))
if maxi == -Inf
    error("no solution")
end