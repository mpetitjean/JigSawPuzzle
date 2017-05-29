% todo: project

clear, close all;

% Parameters
image = 'lenagray.tif';
q = 5;
blk_size = 128;
% Cut in subimages and scramble
[m, n, puzzle] = scrambleImageSquare(image, blk_size,1);

% Compute Sum of Squared Distance
ssd = computeSSD(puzzle);

% Compute Mahalanobis Gradient Compatibility
mgc = computeMGC(puzzle);

ccc = mgc .* ssd.^(1/q);

endpuzzle = zeros(size(puzzle));
pattern = zeros(m/blk_size,n/blk_size);
for ii = 1:4
    ssd(ii,ii,:) = Inf;
end
startpiece = randi([1 size(puzzle,3)]);
startpiece0 = startpiece;
endimage = zeros(m,n);
midposrow = round(m/blk_size/2-1)*blk_size;
midposcol = round(n/blk_size/2-1)*blk_size;
endimage(midposrow+1:midposrow+blk_size, midposcol+1:midposcol+blk_size) = ...
    puzzle(:,:,startpiece);
pattern(round(m/blk_size/2),round(n/blk_size/2)) = 1;

figure;
imshow(endimage)
pause;
startposrow = midposrow+1;
startposcol = midposcol+1;

for ii=1:size(puzzle,3)-1
   % Check if the snake is biting its tail
   [startposrow, startposcol, ssd, startpiece, patternCheck] = ...
   checkPattern(pattern, startposrow, startposcol, blk_size, ssd); 
   if ii == 1
       startpiece = startpiece0;
   end
   pause;
   
   i= round((startposrow-1)/blk_size)+1;
   j = round((startposcol-1)/blk_size)+1;
   % Find best match for current piece
   [mpiece, loc, ssd] = findbestmatch(startpiece,ssd,pattern, i, j, patternCheck);
   disp(mpiece)
   
   % TODO
   % Check pattern, redéfinir un point de départ si entouré de 1   
   
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
   end
   % Update pattern
   
   pattern(round((startposrow-1)/blk_size)+1,round((startposcol-1)/blk_size+1)) = mpiece;
 
   % Put processed image SSD value to Inf
   ssd(startpiece,:,:) = Inf;
   ssd(:,startpiece,:) = Inf;
   
   % Should systematically put to Inf blocs next to each other
   
   imshow(endimage)
   startpiece = mpiece;
end


%     for ii = 1:4
%         for jj = ii+1:4
%             if it == 1
%                 if ssd(ii,jj,1) == min(ssd(ii,:,1)) && ssd(jj,ii,2) == min(ssd(jj,:,2))
%                     maxidx(:,it) = [ii, jj, 1];
%                 end
%                 if ssd(ii,jj,3) == min(ssd(ii,:,3)) && ssd(jj,ii,4) == min(ssd(jj,:,4)) && min(ssd(ii,jj,3),ssd(jj,ii,4))<= min(ssd(ii,jj,1),ssd(jj,ii,2))
%                     maxidx(:,it) = [ii, jj, 3];
%                 end
%             else
%                 ii = lastp;
%                 if ssd(ii,jj,1) == min(ssd(ii,:,1)) && ssd(jj,ii,2) == min(ssd(jj,:,2))
%                     maxidx(:,it) = [ii, jj, 1];
%                 end
%                 if ssd(ii,jj,3) == min(ssd(ii,:,3)) && ssd(jj,ii,4) == min(ssd(jj,:,4)) && min(ssd(ii,jj,3),ssd(jj,ii,4))<= min(ssd(ii,jj,1),ssd(jj,ii,2))
%                     maxidx(:,it) = [ii, jj, 3];
%                 end
%             end
%         end
%     end
%
%     if maxidx(3,it) == 3
%     res1 = find(endn==maxidx(1,it));
%     res2 = find(endn==maxidx(2,it));
%         if ~isempty(res1)
%             if res1 == 2 || res1 == 4
%                 endn = circshift(endn,-1);
%             end
%             endn(res1+1) = maxidx(2,it);
%             lastp = maxidx(2,it);
%         elseif ~isempty(res2)
%             if res2 == 1 || res2 == 3
%                 endn = circshift(endn,1);
%             end
%             endn(res2-1) = maxidx(1,it);
%             lastp = maxidx(1,it);
%         else
%             endn(1) = maxidx(1,it);
%             endn(2) = maxidx(2,it);
%             lastp = maxidx(2,it);
%         end
%     elseif maxidx(3,it) == 1
%         res1 = find(endn==maxidx(1,it));
%         res2 = find(endn==maxidx(2,it));
%         if ~isempty(res1)
%             if res1 == 3 || res1 == 4
%                 endn = circshift(endn,-1,2);
%             end
%             endn(res1+2) = maxidx(2,it);
%             lastp = maxidx(2,it);
%         elseif ~isempty(res2)
%              if res2 == 1 || res2 == 2
%                 endn = circshift(endn,1,2);
%             end
%             endn(res2-2) = maxidx(1,it);
%             lastp = maxidx(1,it);
%         else
%             endn(1) = maxidx(1,it);
%             endn(3) = maxidx(2,it);
%             lastp = maxidx(2,it);
%         end
%     end
%     if maxidx(3,it) == 3
%     ssd(maxidx(1,it),maxidx(2,it),maxidx(3,it)) = Inf;
%     ssd(maxidx(1,it),maxidx(2,it),maxidx(3,it)+1) = Inf;
%     ssd(maxidx(2,it),maxidx(1,it),maxidx(3,it)+1) = Inf;
%     ssd(maxidx(2,it),maxidx(1,it),maxidx(3,it)) = Inf;
% end
%
%
%
% if 0
%
% it = it + 1;
%
% for ii = 1:4
%     for jj = 1:4
%         if ssd(ii,jj,1) == min(ssd(ii,:,1)) && ssd(jj,ii,2) == min(ssd(jj,:,2))
%             maxidx1(it) = ii; maxidx2(it) = jj;
%         end
%     end
% end
% end
