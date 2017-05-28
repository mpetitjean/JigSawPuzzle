function [mpiece, loc] = findbestmatch(piece, ssd)

[~, mpiece] = min(min(ssd(piece,:,:),[],3));
[~, loc] = min(ssd(piece,mpiece,:));


