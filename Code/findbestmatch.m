function [bestmpiece, loc, startposrow, startposcol] = findbestmatch(pieces, ssd, pattern, blk_size, bestbuddy, mariage)
mini = Inf;
possibilities = bestbuddy(pieces,:);
candidate = setdiff(possibilities,pattern);
% candidate(candidate==0)=[];
if ~isempty(candidate)
    for ii = 1:size(possibilities,1)
        for jj = 1:size(possibilities,2)
            if possibilities(ii,jj) ~= 0
%                 ismini = ssd(pieces(ii),possibilities(ii,jj),jj);
                ismini = compatibility(pieces(ii),possibilities(ii,jj),jj,pattern,ssd);
                if ismini < mini
                    mini = ismini;
                    bestmpiece = possibilities(ii,jj);
                    loc = jj;
                    [m,n] = find(pattern == pieces(ii));
                    startposrow = 1+(m-1)*blk_size;
                    startposcol = 1+(n-1)*blk_size;
                end
            end
        end
    end
end
if mini == Inf
    possibilities = mariage(pieces,:);
    candidate = setdiff(possibilities,pattern);
    % candidate(candidate==0)=[];
    if ~isempty(candidate)
        for ii = 1:size(possibilities,1)
            for jj = 1:size(possibilities,2)
                if possibilities(ii,jj) ~= 0
%                     ismini = ssd(pieces(ii),possibilities(ii,jj),jj);
                    ismini = compatibility(pieces(ii),possibilities(ii,jj),jj,pattern,ssd);
                    if ismini < mini
                        mini = ismini;
                        bestmpiece = possibilities(ii,jj);
                        loc = jj;
                        [m,n] = find(pattern == pieces(ii));
                        startposrow = 1+(m-1)*blk_size;
                        startposcol = 1+(n-1)*blk_size;
                    end
                end
            end
        end
    end
    if mini == Inf
        possibilities = setdiff(1:numel(pattern),pattern);
        for ii = 1:numel(pieces)
            for jj = 1:numel(possibilities)
                for kk=1:4
                    ismini = compatibility(pieces(ii),possibilities(jj),kk,pattern,ssd);
                    if ismini < mini
                        mini = ismini;
                        bestmpiece = possibilities(jj);
                        loc = kk;
                        [m,n] = find(pattern == pieces(ii));
                        startposrow = 1+(m-1)*blk_size;
                        startposcol = 1+(n-1)*blk_size;
                    end
                end
            end
        end
    end
%         [mini, bestmpiece] = min(min(ssd(pieces(1),:,:),[],3));
%         [~, loc] = min(ssd(pieces(1),bestmpiece,:));
%         [m,n] = find(pattern == pieces(1));
%         startposrow = 1+(m-1)*blk_size;
%         startposcol = 1+(n-1)*blk_size;
%         for ii = 2:length(pieces)
%             [ismini, mpiece] = min(min(ssd(pieces(ii),:,:),[],3));
%             if ismini < mini
%                 mini = ismini;
%                 bestmpiece = mpiece;
%                 [~, loc] = min(ssd(pieces(ii),bestmpiece,:));
%                 [m,n] = find(pattern == pieces(ii));
%                 startposrow = 1+(m-1)*blk_size;
%                 startposcol = 1+(n-1)*blk_size;
%             end
%         end
        % disp(pattern(m,n))
        % disp(['min = ' num2str(mini)])
        if mini == Inf
            error('no solution')
        end
end
if pattern((startposrow-1)/blk_size+1,(startposcol-1)/blk_size+1) == 0
    keyboard
end
    
    
    