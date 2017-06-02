function [bestmpiece, loc, startposrow, startposcol] = findbestmatch(pieces, ssd, pattern, blk_size)
[mini, bestmpiece] = min(min(ssd(pieces(1),:,:),[],3));
[~, loc] = min(ssd(pieces(1),bestmpiece,:));
[m,n] = find(pattern == pieces(1));
startposrow = 1+(m-1)*blk_size;
startposcol = 1+(n-1)*blk_size;
for ii = 2:length(pieces)
    [ismini, mpiece] = min(min(ssd(pieces(ii),:,:),[],3));
    if ismini < mini
        mini = ismini;
        bestmpiece = mpiece;
        [~, loc] = min(ssd(pieces(ii),bestmpiece,:));
        [m,n] = find(pattern == pieces(ii));
        startposrow = 1+(m-1)*blk_size;
        startposcol = 1+(n-1)*blk_size;
    end
end
% disp(pattern(m,n))
% disp(['min = ' num2str(mini)])
if mini == Inf
    error('no solution')
end