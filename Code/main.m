% todo: project

clear, close all;

% Parameters
image = 'lenagray.tif';
q = 5;
blk_size = 128/2;
% Cut in subimages and scramble
[m, n, puzzle] = scrambleImageSquare(image, blk_size,1);

% Compute Sum of Squared Distance
ssd = computeSSD(puzzle);

% Compute Mahalanobis Gradient Compatibility
mgc = computeMGC(puzzle);

ccc = mgc .* ssd.^(1/q);

endpuzzle = zeros(size(puzzle));
for ii = 1:4
    ssd(ii,ii,:) = Inf;
end
startpiece = randi([1 size(puzzle,3)]);
endimage = zeros(m,n);
midposrow = round(m/blk_size/2-1)*blk_size;
midposcol = round(n/blk_size/2-1)*blk_size;
endimage(midposrow+1:midposrow+blk_size, midposcol+1:midposcol+blk_size) = puzzle(:,:,startpiece);
figure;
imshow(endimage);

startposrow = midposrow+1;
startposcol = midposcol+1;

for ii=1:size(puzzle,3)-1
   [mpiece, loc] = findbestmatch(startimage,ssd);
   % DO NOT FORGET TO INF SSD

   switch loc
       case 1
           if startposcol == 1
               endimage = circshift(endimage,blk_size,2);
               startposcol = startposcol + blk_size;
           end
           endimage(startposrow:startposrow+blk_size-1,startposcol-blk_size:startposcol-1)...
               = puzzle(:,:,mpiece);
           startposcol = startposcol-blk_size;
       case 2
           if startposcol == n-blk_size+1
               endimage = circshift(endimage,-blk_size,2);
               startposcol = startposcol - blk_size+1;
           end
           endimage(startposrow:startposrow+blk_size-1,startposcol+blk_size:startposcol+2*blk_size-1)...
               = puzzle(:,:,mpiece);
           startposcol = startposcol+2*blk_size;
       case 3

       case 4

   end
   startimage = mpiece;
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
