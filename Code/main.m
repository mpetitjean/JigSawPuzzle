% todo: project
function accuracy = main(image,blk_size,method,p,q,r)
% 
% if strcmp(type,'ssd')
%     r = 1;
%     p = 2;
%     q = 2;
% elseif strcmp(type,'lpq')
%     r = 1;
% elseif strcmp(type,'mgc')
%     r = 1;
% end
% Parameters
% image = 'imData/12.png';
% q = 10;
% blk_size = 28;
% threshold = [0.05 0.15];
% sigma = 3;
% Cut in subimages and scramble
[m, n, z, puzzle, scramble] = scrambleImageSquare(image, blk_size,0);
% puzzlegray=puzzle;
% if z ~= 1
%     puzzlegray = cellfun(@rgb2gray, puzzlegray,'un',0);
% end
% puzzleE = cellfun(@(x) edge(x,'Canny',threshold,sigma), puzzlegray,'un',0);

% Compute Sum of Squared Distance
switch method
    case 'ssd'
        ssd = computeSSD(puzzle,2,2);
%        ssd = ssd./(min(repmat(min(ssd),[numel(puzzle) 1 1]),...
%           repmat(min(ssd,[],2),[1 numel(puzzle) 1]))+1);
    case 'lpq'
        if ~exist('p','var')
            p = 3/10;
        end
        if ~exist('q','var')
            q = 1/16;
        end
        ssd = computeSSD(puzzle,p,q);
%        ssd = ssd./(min(repmat(min(ssd),[numel(puzzle) 1 1]),...
%           repmat(min(ssd,[],2),[1 numel(puzzle) 1]))+1);
    case 'mgc'
        ssd = computeMGC(puzzle, blk_size);
%        ssd = ssd./(min(repmat(min(ssd),[numel(puzzle) 1 1]),...
%           repmat(min(ssd,[],2),[1 numel(puzzle) 1]))+1);
    case 'm+s'
        if ~exist('r','var')
            r = 10;
        end
        ssd = computeSSD(puzzle,2,2);
        mgc = computeMGC(puzzle, blk_size);
        ssd = mgc .* ssd.^(1/r);
%        ssd = ssd./(min(repmat(min(ssd),[numel(puzzle) 1 1]),...
%            repmat(min(ssd,[],2),[1 numel(puzzle) 1]))+1);
    case 'm+lpq'
        if ~exist('p','var')
            p = 3/10;
        end
        if ~exist('q','var')
            q = 1/16;
        end
        if ~exist('r','var')
            r = 10;
        end
        ssd = computeSSD(puzzle,p,q);
        mgc = computeMGC(puzzle, blk_size);
        ssd = mgc .* ssd.^(1/r);
%        ssd = ssd./(min(repmat(min(ssd),[numel(puzzle) 1 1]),...
%            repmat(min(ssd,[],2),[1 numel(puzzle) 1]))+1);
    case 'wmgc'
        if ~exist('r','var')
            r = 10;
        end
        ssd = computeSSD(puzzle,2,2);
        mgc = computeMGC(puzzle, blk_size);
        ssd = mgc .* ssd.^(1/r);
        ssd = ssd./(min(repmat(min(ssd),[numel(puzzle) 1 1]),...
            repmat(min(ssd,[],2),[1 numel(puzzle) 1]))+1);
        mgc = mgc./(min(repmat(min(mgc),[numel(puzzle) 1 1]),...
            repmat(min(mgc,[],2),[1 numel(puzzle) 1]))+1);
        W = zeros(size(ssd));
        for ii=1:4
            bestHungarian = munkres(mgc(:,:,ii));
            [a,phimatch] = find(bestHungarian==1);
            [~,I] = sort(a);
            phimatch = phimatch(I);
            [~, nmatch] = min(mgc(:,:,ii),[],2);
            W(phimatch==nmatch,:,ii) = mgc(phimatch==nmatch,:,ii);
            W(phimatch~=nmatch,:,ii) = ssd(phimatch~=nmatch,:,ii);
        end
        ssd = W;
    case 'wmgclpq'
        if ~exist('p','var')
            p = 3/10;
        end
        if ~exist('q','var')
            q = 1/16;
        end
        if ~exist('r','var')
            r = 10;
        end
        ssd = computeSSD(puzzle,p,q);
        mgc = computeMGC(puzzle, blk_size);
        ssd = mgc .* ssd.^(1/r);
        ssd = ssd./(min(repmat(min(ssd),[numel(puzzle) 1 1]),...
            repmat(min(ssd,[],2),[1 numel(puzzle) 1]))+1);
        mgc = mgc./(min(repmat(min(mgc),[numel(puzzle) 1 1]),...
            repmat(min(mgc,[],2),[1 numel(puzzle) 1]))+1);
        W = zeros(size(ssd));
        for ii=1:4
            bestHungarian = munkres(mgc(:,:,ii));
            [a,phimatch] = find(bestHungarian==1);
            [~,I] = sort(a);
            phimatch = phimatch(I);
            [~, nmatch] = min(mgc(:,:,ii),[],2);
            W(phimatch==nmatch,:,ii) = mgc(phimatch==nmatch,:,ii);
            W(phimatch~=nmatch,:,ii) = ssd(phimatch~=nmatch,:,ii);
        end
        ssd = W;
    otherwise
        error('wrong method')
end


% ssd = 1;
% if ~strcmp(type,'mgc')
%     ssd = computeSSD(puzzle,p,q);
%     if any(any(any(isnan(ssd))))
%         keyboard
%     end
% end
% % Compute Mahalanobis Gradient Compatibility
% mgc = 1;
% if strcmp(type,'mgc') || strcmp(type,'m+s') || strcmp(type,'wmgc')
%     mgc = computeMGC(puzzle, blk_size);
%     if any(any(any(isnan(mgc))))
%         keyboard
%     end
% end
% ccc = mgc .* ssd.^(1/r);
% if any(any(any(isnan(ccc))))
%     keyboard
% end
% if strcmp(type,'mgc') || strcmp(type,'m+s') || strcmp(type,'wmgc')
%     ssd = ccc./(min(repmat(min(ccc),[numel(puzzle) 1 1]),repmat(min(ccc,[],2),[1 numel(puzzle) 1]))+1);
% else
%     ssd = ccc;
% end
% if strcmp(type,'wmgc')
%     munkres(mgc(:,:,2));
% end
% % Mcomp = Mcomp./squeeze(min(min(ccc),min(permute(ccc,[2 1 3]))));
if any(any(any(isnan(ssd))))
    keyboard
end
ssd = ssd/max(max(max(ssd)));
ssd(ssd==0) = realmin;

pattern = zeros(m/blk_size,n/blk_size);
bestpattern = pattern;
bestestimation = 0;
for ii = 1:numel(puzzle)
    ssd(ii,ii,:) = Inf;
end
savessd = ssd;
bestbuddy = computebestbuddy(savessd);
mariage = computemariage(savessd,numel(puzzle));
[~, startpiece] = min(min(min(ssd,[],3),[],2));
endimage = zeros(m,n,z);
midposrow = round(m/blk_size/2-1)*blk_size;
midposcol = round(n/blk_size/2-1)*blk_size;
endimage(midposrow+1:midposrow+blk_size, midposcol+1:midposcol+blk_size,:)...
    = puzzle{startpiece}(:,:,:);

pattern(round(m/blk_size/2),round(n/blk_size/2)) = startpiece;
ssd(:,startpiece,:)= Inf;

% p = figure;
% imshow(endimage)
alreadyfullrow = 0;
alreadyfullcol = 0;
%pause;
startpiecelist = startpiece;
while 1
    while ~isempty(find(pattern==0,1))
       % Check if the snake is biting its tail
%        pause(0.01);

       % Find best match for current piece
       [mpiece, loc, startposrow, startposcol] = findbestmatch(...
           startpiecelist, ssd, pattern, blk_size, bestbuddy, mariage);
       if ~isempty(find(pattern == mpiece, 1))
           keyboard
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
                end

               endimage(startposrow+blk_size:startposrow+2*blk_size-1,...
                   startposcol:startposcol+blk_size-1,:)...
                   = puzzle{mpiece}(:,:,:);

               startposrow = startposrow + blk_size;
               ssd(mpiece,:,4)=Inf;
               ssd(:,mpiece,:)=Inf;
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
        if alreadyfullrow || any(ismember(sign(pattern),...
                ones(1, size(pattern,2)),'rows'))
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
        if alreadyfullcol || any(ismember(sign(pattern).',...
                ones(1,size(pattern,1)),'rows'))
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

%        figure(p);
%        imshow(endimage)
       if ~(all(all(ssd(mpiece,:,:)== Inf)) && all(all(ssd(:,mpiece,:)== Inf)))
            startpiecelist = [startpiecelist mpiece]; %#ok<AGROW>
       end
    %    disp(pattern)
    %    disp(startpiecelist)
       %startpiece = checkPattern(pattern, startposrow, startposcol, blk_size, ssd);

    end

patterncol = pattern(:);
if ~all(diff(sort(patterncol)))
    error('more than one occurence')
end
[mysegment, maxseg] = createsegment(pattern, bestbuddy);
frame = histcounts(mysegment(:),maxseg);
[~, biggestseg] = max(frame);
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
% figure(p)
% imshow(endimage);
% figure
estimation = myestimate(pattern, bestbuddy);
if estimation <= bestestimation
%     figure(p)
%     imshow(bestimage)
    break
end
% imshow(newimage);
bestimage = endimage;
endimage = newimage;
bestestimation = estimation;
bestpattern = pattern;
pattern = zeros(size(bestpattern));
pattern(sub2ind(size(pattern),piecesegrowshifted, piecesegcolshifted))...
    = bestpattern(sub2ind(size(pattern),piecesegrow,piecesegcol));

[ssd, startpiecelist] = removeplacedpieces(savessd,pattern);
alreadyfullrow = 0;
alreadyfullcol = 0;
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
end
% segmentsPermutation = mysegment;
% permutation = randperm(maxseg);
% 
% for i = 1:maxseg
%     segmentsPermutation(mysegment == permutation(i)) = i;
% end
% figure(p)
% imshow(endimage);
% figure;
% % Showing and saving the segmentation map.
% h = imagesc(segmentsPermutation);
% axis image
% axis off
good(scramble)=1:length(scramble);
current = bestpattern.';
current = current(:);
accuracy = sum(current==good.')/numel(pattern)*100;


%errors = computeError(puzzlePatternInit, pattern);
%disp(['Finished with ' num2str(errors) '% of errors']);



