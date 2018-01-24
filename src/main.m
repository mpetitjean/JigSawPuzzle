function accuracy = main(image,blk_size,method,p,q,r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Inputs: - image: path of the image to cut (string)
%%%             - blk_size: length of the corner of each piece (double)
%%%             - method: compatibility method (string):
%%%                             - SSD: 
%%%                             - (L_p)^q:
%%%                             - MGC: 
%%%                             - M+S:
%%%                             - M+(L_p)^q
%%%             - p: parameter for the (L_p)^q, default is 3/10 (double)
%%%             - q: parameter for the (L_p)^q, default is 1/16 (double)
%%%             - r: parameter for the combined methods, default is 16 for
%%%             M+S ans 9 for M+(L_p)^q (double)
%%%     
%%%     Output: accuracy: the accuracy with regard to piece placements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create the puzzle
[m, n, z, puzzle, scramble] = scrambleImageSquare(image, blk_size,0);

% Compute the method
switch method
    case 'ssd'
        ssd = computeSSD(puzzle,2,2);
    case 'lpq'
        if ~exist('p','var')
            p = 3/10;
        end
        if ~exist('q','var')
            q = 1/16;
        end
        ssd = computeSSD(puzzle,p,q);
    case 'mgc'
        ssd = computeMGC(puzzle, blk_size);
    case 'm+s'
        if ~exist('r','var')
            r = 16;
        end
        ssd = computeSSD(puzzle,2,2);
        mgc = computeMGC(puzzle, blk_size);
        ssd = mgc .* ssd.^(1/r);
    case 'm+lpq'
        if ~exist('p','var')
            p = 3/10;
        end
        if ~exist('q','var')
            q = 1/16;
        end
        if ~exist('r','var')
            r = 9;
        end
        ssd = computeSSD(puzzle,p,q);
        mgc = computeMGC(puzzle, blk_size);
        ssd = mgc .* ssd.^(1/r);
    otherwise
        error('wrong method')
end

% map from 0 to 1;
ssd = ssd/max(max(max(ssd)));
% avoid absorbent;
ssd(ssd==0) = realmin;

% Create the piece map
pattern = zeros(m/blk_size,n/blk_size);

bestpattern = pattern;

% Create the position possibilities map
freeloc = pattern;

bestestimation = 0;

% Piece cannot match itself
for ii = 1:numel(puzzle)
    ssd(ii,ii,:) = Inf;
end


savessd = ssd;

% Compute best buddies
bestbuddy = computebestbuddy(savessd);
% Compute stable mariage
mariage = computemariage(savessd,numel(puzzle));

% Select a piece
[~, startpiece] = min(min(min(ssd,[],3),[],2));

% Initialize the reconstructed image
endimage = zeros(m,n,z);

% Place the piece at the middle of the image
midposrow = round(m/blk_size/2-1)*blk_size;
midposcol = round(n/blk_size/2-1)*blk_size;
endimage(midposrow+1:midposrow+blk_size, midposcol+1:midposcol+blk_size,:)...
    = puzzle{startpiece}(:,:,:);

% Place the piece on the piece map
pattern(round(m/blk_size/2),round(n/blk_size/2)) = startpiece;

% Remove the piece from possibilities
ssd(:,startpiece,:)= Inf;

% List of unplaced pieces
unplacedpieces = 1:numel(puzzle);
unplacedpieces = unplacedpieces(unplacedpieces~=startpiece);

% Update the possible locations map
freeloc = updatelocations(round(m/blk_size/2),round(n/blk_size/2),freeloc);

p = figure;
imshow(endimage)

% Initialize 
alreadyfullrow = 0;
alreadyfullcol = 0;

% List of pieces that can accept at least one neighboor
startpiecelist = startpiece;

while 1
    
    % Place all the pieces
    while ~isempty(unplacedpieces)
       pause(0.01);

       % Find best match
       [mpiece, loc, startposrow, startposcol] = findbestmatch(...
           startpiecelist, ssd, pattern, blk_size, bestbuddy, mariage, ...
           unplacedpieces, freeloc, alreadyfullrow, alreadyfullcol);

       % Remove the selected piece from the unplaced pieces list
       unplacedpieces = unplacedpieces(unplacedpieces~=mpiece);

       
       % Place the piece on the figure, compute the next starting
       % point, move pattern and freeloc if needed
       switch loc
           case 2
               % Piece should be placed on the left
               if startposcol == 1
                   % Shift puzzle to the right if needed
                   endimage = circshift(endimage,blk_size,2);
                   startposcol = startposcol + blk_size;
                   pattern = circshift(pattern,1,2);
                   freeloc = circshift(freeloc,1,2);
                   freeloc(:,1) = freeloc(:,2)==-1;                   
               end

               endimage(startposrow:startposrow+blk_size-1,...
                   startposcol-blk_size:startposcol-1,:)...
                   = puzzle{mpiece}(:,:,:);

               startposcol = startposcol-blk_size;
               ssd(mpiece,:,1)=Inf;
               ssd(:,mpiece,:)=Inf;
           case 1
               % Piece should be placed on the right
               if startposcol == n-blk_size+1
                   % Shift puzzle to the left if needed
                   endimage = circshift(endimage,-blk_size,2);
                   startposcol = startposcol - blk_size;
                   pattern = circshift(pattern,-1,2);
                   freeloc = circshift(freeloc,-1,2);
                   freeloc(:,end) = freeloc(:,end-1)==-1;
               end

               endimage(startposrow:startposrow+blk_size-1,...
                   startposcol+blk_size:startposcol+2*blk_size-1,:)...
                   = puzzle{mpiece}(:,:,:);

               startposcol = startposcol+blk_size;
               ssd(mpiece,:,2)=Inf;
               ssd(:,mpiece,:)=Inf;

           case 4
                % Piece should be placed on the top
                if startposrow == 1
                   % Shift puzzle to the bottom if needed
                   endimage = circshift(endimage,blk_size,1);
                   startposrow = startposrow + blk_size;
                   pattern = circshift(pattern,1,1);
                   freeloc = circshift(freeloc,1,1);
                   freeloc(1,:) = freeloc(2,:)==-1;
                end

               endimage(startposrow-blk_size:startposrow-1,...
                   startposcol:startposcol+blk_size-1,:)...
                   = puzzle{mpiece}(:,:,:);

               startposrow = startposrow-blk_size;
               ssd(mpiece,:,3)=Inf;
               ssd(:,mpiece,:)=Inf;
           case 3
               % Piece should be placed on the bottom
                if startposrow == m-blk_size+1
                   % Shift puzzle to the top if needed
                   endimage = circshift(endimage,-blk_size,1);
                   startposrow = startposrow - blk_size;
                   pattern = circshift(pattern,-1,1);
                   freeloc = circshift(freeloc,-1,1);
                   freeloc(end,:) = freeloc(end-1,:)==-1;
                end

               endimage(startposrow+blk_size:startposrow+2*blk_size-1,...
                   startposcol:startposcol+blk_size-1,:)...
                   = puzzle{mpiece}(:,:,:);

               startposrow = startposrow + blk_size;
               ssd(mpiece,:,4)=Inf;
               ssd(:,mpiece,:)=Inf;
       end
       
       % Place the piece in pattern
       patternrow = (startposrow-1)/blk_size+1;
       patterncol = (startposcol-1)/blk_size+1;
       pattern(patternrow,patterncol) = mpiece;
       
       % Update freeloc
       freeloc = updatelocations(patternrow,patterncol,freeloc);
       
       % Update piece matches
       % Should systematically put to Inf blocs next to each other
       if patternrow -1 > 0
           piece = pattern(patternrow-1, patterncol);
           if piece ~= 0
               ssd(piece, :,3) = Inf;
               ssd(:,piece,4) = Inf;
               ssd(mpiece, :, 4) = Inf;
               ssd(:, mpiece, 3) = Inf;
               % if piece is completely surrounded
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
       
       % Check if shifting is still authorized
        if alreadyfullrow || all(any(pattern))
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
        if alreadyfullcol || all(any(pattern,2))
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
        
       % Show the result
       figure(p);
       imshow(endimage)
       
       % Check if new placed piece can accept neighboors
       if ~(all(all(ssd(mpiece,:,:)== Inf)) && all(all(ssd(:,mpiece,:)== Inf)))
            startpiecelist = [startpiecelist mpiece]; %#ok<AGROW>
       end
    end

% Map is full

% Calculate the different segments
[mysegment, maxseg] = createsegment(pattern, bestbuddy);

% Find the biggest one
frame = histcounts(mysegment(:),maxseg);
[~, biggestseg] = max(frame);

% Take the biggest one and store it on a new image at position (1,1)
newimage = zeros(size(endimage));
[piecesegrow,piecesegcol] = find(mysegment==biggestseg);
piecesegrowshifted = piecesegrow - min(piecesegrow) +1;
piecesegcolshifted = piecesegcol - min(piecesegcol) +1;
startposrow = (piecesegrow-1)*blk_size+1;
startposcol = (piecesegcol-1)*blk_size+1;
startposrowshifted = (piecesegrowshifted-1)*blk_size+1;
startposcolshifted = (piecesegcolshifted-1)*blk_size+1;
for ii=1:length(startposrow)
    newimage(startposrowshifted(ii):startposrowshifted(ii)+blk_size-1,...
        startposcolshifted(ii):startposcolshifted(ii)+blk_size-1,:) = ...
        endimage(startposrow(ii):startposrow(ii)+blk_size-1,...
        startposcol(ii):startposcol(ii)+blk_size-1,:);
end

% Compute the Image accuracy from best buddies
estimation = myestimate(pattern, bestbuddy);

% If current estimation less good than previous one, stop
if estimation <= bestestimation
    figure(p)
    imshow(bestimage)
    break
end

% Else prepare for next iteration
imshow(newimage);
bestimage = endimage;
endimage = newimage;

bestestimation = estimation;

bestpattern = pattern;

% Recreate the piece map, containing the segment
pattern = zeros(size(bestpattern));
pattern(sub2ind(size(pattern),piecesegrowshifted, piecesegcolshifted))...
    = bestpattern(sub2ind(size(pattern),piecesegrow,piecesegcol));

% Recreate the possible positions map
freeloc = bwdist(sign(pattern));
freeloc(freeloc==0) = -1;
freeloc(freeloc>1) = 0;

unplacedpieces = setdiff(1:numel(puzzle),pattern);

% Update the compatibility
[ssd, startpiecelist] = removeplacedpieces(savessd,pattern);

% Check if segment prevent shifting
alreadyfullrow = 0;
alreadyfullcol = 0;
if alreadyfullrow || all(any(pattern))
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
if alreadyfullcol || all(any(pattern,2))
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
end

% Converged
% Calculate the accuracy
good(scramble)=1:length(scramble);
current = bestpattern.';
current = current(:);
accuracy = sum(current==good.')/numel(pattern)*100;