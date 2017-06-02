% todo: project

clear, close all;

% Parameters
image = '20.png';
q = 5;
blk_size = 28;
% Cut in subimages and scramble
[m, n, puzzle, puzzlePatternInit] = scrambleImageSquare(image, blk_size,1);

% Compute Sum of Squared Distance
ssd = computeSSD(puzzle);

% Compute Mahalanobis Gradient Compatibility
mgc = computeMGC(puzzle);

ccc = mgc .* ssd.^(1/q);

endpuzzle = zeros(size(puzzle));
pattern = zeros(m/blk_size,n/blk_size);

for ii = 1:size(puzzle,3)
    ssd(ii,ii,:) = Inf;
end
startpiece = randi([1 size(puzzle,3)]);

endimage = zeros(m,n);
midposrow = round(m/blk_size/2-1)*blk_size;
midposcol = round(n/blk_size/2-1)*blk_size;
endimage(midposrow+1:midposrow+blk_size, midposcol+1:midposcol+blk_size) = ...
    puzzle(:,:,startpiece);

pattern(round(m/blk_size/2),round(n/blk_size/2)) = startpiece;
ssd(:,startpiece,:)= Inf;

figure;
imshow(endimage)
alreadyfullrow = 0;
alreadyfullcol = 0;
%pause;
startposrow = midposrow+1;
startposcol = midposcol+1;
startpiecelist = startpiece;
for ii=1:size(puzzle,3)-1
   % Check if the snake is biting its tail
   pause(0.1);
   
   % Find best match for current piece
   [mpiece, loc, startposrow, startposcol] = findbestmatch(startpiecelist, ssd, pattern, blk_size);
   if ~isempty(find(pattern == mpiece, 1))
       error(' ')
   end
   % TODO
   % Calculer startposrow & startposcol
   
   switch loc
       case 2
           % Piece should be placed on the left
           if startposcol == 1
               % Shift puzzle to the right if needed
               endimage = circshift(endimage,blk_size,2);
               startposcol = startposcol + blk_size;
               pattern = circshift(pattern,1,2);
           end
           
           endimage(startposrow:startposrow+blk_size-1,startposcol-blk_size:startposcol-1)...
               = puzzle(:,:,mpiece);
           
           startposcol = startposcol-blk_size;
           ssd(mpiece,:,1)=Inf;
           ssd(:,mpiece,2)=Inf;
       case 1
           % Piece should be placed on the right
           if startposcol == n-blk_size+1
               % Shift puzzle to the left if needed
               endimage = circshift(endimage,-blk_size,2);
               startposcol = startposcol - blk_size;
               pattern = circshift(pattern,-1,2);
           end
           
           endimage(startposrow:startposrow+blk_size-1,startposcol+blk_size:startposcol+2*blk_size-1)...
               = puzzle(:,:,mpiece);
           startposcol = startposcol+blk_size;
           ssd(mpiece,:,2)=Inf;
           ssd(:,mpiece,1)=Inf;

       case 4
            % Piece should be placed on the top
            if startposrow == 1
               % Shift puzzle to the bottom if needed
               endimage = circshift(endimage,blk_size,1);
               startposrow = startposrow + blk_size;
               pattern = circshift(pattern,1,1);
            end
           
           endimage(startposrow-blk_size:startposrow-1,startposcol:startposcol+blk_size-1)...
               = puzzle(:,:,mpiece);
           startposrow = startposrow-blk_size;
           ssd(mpiece,:,3)=Inf;
           ssd(:,mpiece,4)=Inf;
       case 3
           % Piece should be placed on the bottom
            if startposrow == m-blk_size+1
               % Shift puzzle to the top if needed
               endimage = circshift(endimage,-blk_size,1);
               startposrow = startposrow - blk_size;
               pattern = circshift(pattern,-1,1);
            end
           
           endimage(startposrow+blk_size:startposrow+2*blk_size-1,startposcol:startposcol+blk_size-1)...
               = puzzle(:,:,mpiece);
           startposrow = startposrow + blk_size;
           ssd(mpiece,:,4)=Inf;
           ssd(:,mpiece,3)=Inf;
   end
   
   % Update pattern
   
   patternrow = (startposrow-1)/blk_size+1;
   patterncol = (startposcol-1)/blk_size+1;
   pattern(patternrow,patterncol) = mpiece;
   
   if patternrow -1 > 0
       piece = pattern(patternrow-1, patterncol);
       if piece ~= 0
           ssd(piece, :,3) = Inf;
           ssd(:,piece,4) = Inf;
           ssd(mpiece, :, 4) = Inf;
           ssd(:, mpiece, 3) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
       end
   else 
       piece = pattern(end,patterncol);
       if piece ~= 0
           ssd(piece, :,3) = Inf;
           ssd(:,piece,4) = Inf;
           ssd(mpiece, :, 4) = Inf;
           ssd(:, mpiece, 3) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
       end
   end
   if patternrow +1 <= m/blk_size
      piece = pattern(patternrow+1, patterncol);
      if piece ~= 0
           ssd(piece, :,4) = Inf;
           ssd(:,piece,3) = Inf;
           ssd(mpiece, :, 3) = Inf;
           ssd(:, mpiece, 4) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
      end
   else
       piece = pattern(1, patterncol);
      if piece ~= 0
           ssd(piece, :,4) = Inf;
           ssd(:,piece,3) = Inf;
           ssd(mpiece, :, 3) = Inf;
           ssd(:, mpiece, 4) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
      end
   end
   if patterncol -1 > 0
       piece = pattern(patternrow, patterncol-1);
       if piece ~= 0
           ssd(piece, :,1) = Inf;
           ssd(:,piece,2) = Inf;
           ssd(mpiece, :, 2) = Inf;
           ssd(:, mpiece, 1) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
       end
   else
       piece = pattern(patternrow, end);
       if piece ~= 0
           ssd(piece, :,1) = Inf;
           ssd(:,piece,2) = Inf;
           ssd(mpiece, :, 2) = Inf;
           ssd(:, mpiece, 1) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
       end
   end
   if patterncol +1 <= n/blk_size
       piece = pattern(patternrow, patterncol+1);
       if piece ~= 0
           ssd(piece, :,2) = Inf;
           ssd(:,piece,1) = Inf;
           ssd(mpiece, :, 1) = Inf;
           ssd(:, mpiece, 2) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
       end
   else
       piece = pattern(patternrow,1);
       if piece ~= 0
           ssd(piece, :,2) = Inf;
           ssd(:,piece,1) = Inf;
           ssd(mpiece, :, 1) = Inf;
           ssd(:, mpiece, 2) = Inf;
           if all(all(ssd(piece,:,:)==Inf))
               startpiecelist(startpiecelist == piece) = [];
           end
       end
   end
    if alreadyfullrow || any(ismember(sign(pattern),ones(1, size(pattern,2)),'rows'))
        alreadyfullrow = 1;
        ind = pattern(:,1);
        ind(ind == 0) = [];
        ssd(ind,:,2) = Inf;
        ssd(:,ind,1) = Inf;
        ind = pattern(:,end);
        ind(ind == 0) = [];
        ssd(ind,:,1) = Inf;
        ssd(:,ind,2) = Inf;
    end
    if alreadyfullcol || any(ismember(sign(pattern).',ones(1,size(pattern,1)),'rows'))
        alreadyfullcol = 1;
        ind = pattern(1,:);
        ind(ind == 0) = [];
        ssd(ind,:,4) = Inf;
        ssd(:,ind,3) = Inf;
        ind = pattern(end,:);
        ind(ind == 0) = [];
        ssd(ind,:,3) = Inf;
        ssd(:,ind,4) = Inf;
    end
   % Put processed image SSD value to Inf
   ssd(:,mpiece,:)= Inf;
   % Should systematically put to Inf blocs next to each other
   
   imshow(endimage)
   if ~(all(all(ssd(mpiece,:,:)== Inf)) && all(all(ssd(:,mpiece,:)== Inf)))
        startpiecelist = [startpiecelist mpiece]; %#ok<AGROW>
   end
%    disp(pattern)
%    disp(startpiecelist)
   %startpiece = checkPattern(pattern, startposrow, startposcol, blk_size, ssd);
   
end

errors = computeError(puzzlePatternInit, pattern);
disp(['Finished with ' num2str(errors) '% of errors']);
pattern = pattern(:);
if ~all(diff(sort(pattern)))
    error('more than one occurence')
end


