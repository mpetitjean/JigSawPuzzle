function [mpiece, loc, ssd] = findbestmatch(piece, ssd, pattern, ii, jj, patternCheck)

[~, mpiece] = min(min(ssd(piece,:,:),[],3));
[~, loc] = min(ssd(piece,mpiece,:));
%     
% while(notOK)
% 
%     if loc == 1
%         if (pattern(ii,jj+1) ~= 0)
%             notOK = 1;
%         else
%             notOK = 0;
%         end
%     elseif loc == 2
%         if (pattern(ii,jj-1) ~= 0)
%             notOK = 1;
%         else
%             notOK = 0;
%         end
%     elseif loc == 3
%         if (pattern(ii-1,jj) ~= 0)    
%             notOK = 1;
%         else
%             notOK = 0;
%         end
%     elseif loc == 4
%         if (pattern(ii+1,jj) ~= 0)
%             notOK = 1;
%         else
%             notOK = 0;
%         end
%     end
%     
%     if(notOK == 1)
%         if loc == 1
%             if (pattern(ii,jj+1) ~= 0)
%                 ssd(piece,pattern(ii,jj+1),loc) = Inf;
%                 ssd(pattern(ii,jj+1),piece,loc) = Inf; 
%             end
%         elseif loc == 2
%             if (pattern(ii,jj-1) ~= 0)
%                 ssd(piece,pattern(ii,jj-1),loc) = Inf;
%                 ssd(pattern(ii,jj-1),piece,loc) = Inf; 
%             end
%         elseif loc == 3
%             if (pattern(ii-1,jj) ~= 0)
%                 ssd(piece,pattern(ii-1,jj),loc) = Inf;
%                 ssd(pattern(ii-1,jj),piece,loc) = Inf; 
%             end
%         elseif loc == 4
%             if (pattern(ii+1,jj) ~= 0)
%                 ssd(piece,pattern(ii+1,jj),loc) = Inf;
%                 ssd(pattern(ii+1,jj),piece,loc) = Inf; 
%             end
%         end
%     
%         [~, mpiece] = min(min(ssd(piece,:,:),[],3));
%         [~, loc] = min(ssd(piece,mpiece,:));
%     end
% end