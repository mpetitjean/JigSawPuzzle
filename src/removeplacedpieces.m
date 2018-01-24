function [ssd, startpiecelist] = removeplacedpieces(ssd,pattern)
[piecesrow,piecescol] = find(pattern~=0);
[m, n] = size(pattern);
startpiecelist = [];
for ii=1:length(piecesrow)
    neighbour = 0;
    mpiece = pattern(piecesrow(ii),piecescol(ii));
   if piecesrow(ii) -1 > 0
       piece = pattern(piecesrow(ii)-1, piecescol(ii));
       if piece ~= 0
           neighbour = neighbour +1;
           ssd(piece, :,3) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 4) = Inf;
           ssd(:, mpiece, :) = Inf;
       end
   else 
       piece = pattern(end,piecescol(ii));
       if piece ~= 0
           neighbour = neighbour +1;
           ssd(piece, :,3) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 4) = Inf;
           ssd(:, mpiece, :) = Inf;
       end
   end
   if piecesrow(ii) +1 <= m
      piece = pattern(piecesrow(ii)+1, piecescol(ii));
      if piece ~= 0
           neighbour = neighbour + 1;
           ssd(piece, :,4) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 3) = Inf;
           ssd(:, mpiece, :) = Inf;
      end
   else
       piece = pattern(1, piecescol(ii));
      if piece ~= 0
           neighbour = neighbour + 1;
           ssd(piece, :,4) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 3) = Inf;
           ssd(:, mpiece, :) = Inf;
      end
   end
   if piecescol(ii) -1 > 0
       piece = pattern(piecesrow(ii), piecescol(ii)-1);
       if piece ~= 0
           neighbour = neighbour + 1;
           ssd(piece, :,1) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 2) = Inf;
           ssd(:, mpiece, :) = Inf;
       end
   else
       piece = pattern(piecesrow(ii), end);
       if piece ~= 0
           neighbour = neighbour + 1;
           ssd(piece, :,1) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 2) = Inf;
           ssd(:, mpiece, :) = Inf;
       end
   end
   if piecescol(ii) +1 <= n
       piece = pattern(piecesrow(ii), piecescol(ii)+1);
       if piece ~= 0
           neighbour = neighbour + 1;
           ssd(piece, :,2) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 1) = Inf;
           ssd(:, mpiece, :) = Inf;
       end
   else
       piece = pattern(piecesrow(ii),1);
       if piece ~= 0
           neighbour = neighbour + 1;
           ssd(piece, :,2) = Inf;
           ssd(:,piece,:) = Inf;
           ssd(mpiece, :, 1) = Inf;
           ssd(:, mpiece, :) = Inf;
       end
   end
   if neighbour < 4
      startpiecelist = [startpiecelist mpiece];  %#ok<AGROW>
   end
end
