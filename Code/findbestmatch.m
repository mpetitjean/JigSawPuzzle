function [bestmpiece, loc, startposrow, startposcol] = findbestmatch(...
    pieces, ssd, pattern, blk_size, bestbuddy, mariage, unplacedpieces,...
    freeloc, alreadyfullrow, alreadyfullcol)

mini = Inf;
possibilities = bestbuddy(pieces,:);
[~,ia] = setdiff(possibilities,pattern);
[pindex, ploc] = ind2sub(size(possibilities),ia);
for ii = 1:length(pindex)
    [x, y] = find(pattern==pieces(pindex(ii)));
    ismini = compatibility(x,y,possibilities(pindex(ii),ploc(ii)),ploc(ii),pattern,ssd);
    if ismini < mini
        mini = ismini;
        bestmpiece = possibilities(pindex(ii),ploc(ii));
        loc = ploc(ii);
        startposrow = 1+(x-1)*blk_size;
        startposcol = 1+(y-1)*blk_size;
    end
end

if mini == Inf
    possibilities = mariage(pieces,:);
    [~, ia] = setdiff(possibilities,pattern);
    [pindex, ploc] = ind2sub(size(possibilities),ia);
    for ii = 1:length(pindex)
        [x, y] = find(pattern==pieces(pindex(ii)));
        ismini = compatibility(x,y,possibilities(pindex(ii),ploc(ii)),ploc(ii),pattern,ssd);
        if ismini < mini
            mini = ismini;
            bestmpiece = possibilities(pindex(ii),ploc(ii));
            loc = ploc(ii);
            startposrow = 1+(x-1)*blk_size;
            startposcol = 1+(y-1)*blk_size;
        end
    end
    if mini == Inf
        [m,n] = size(pattern);
        [x,y] = find(freeloc==1);
        for ii = 1:length(x)
            isminis = zeros(1,length(unplacedpieces));
            count = 0;
            if x(ii) > 1 && pattern(x(ii)-1,y(ii)) ~= 0
                posloc = 3;
                xn = x(ii)-1;
                yn = y(ii);
                isminis = isminis + ssd(pattern(xn,yn),unplacedpieces,posloc);
                count = count + 1;
            end
            if y(ii) > 1 && pattern(x(ii),y(ii)-1) ~= 0
                xn = x(ii);
                yn = y(ii)-1;
                posloc = 1;
                isminis = isminis + ssd(pattern(xn,yn),unplacedpieces,posloc);
                count = count + 1;
            end
            if x(ii) < m && pattern(x(ii)+1,y(ii)) ~= 0
                xn = x(ii)+1;
                yn = y(ii);
                posloc = 4;
                isminis = isminis + ssd(pattern(xn,yn),unplacedpieces,posloc);
                count = count + 1;
            end
            if y(ii) < n && pattern(x(ii),y(ii)+1) ~= 0
                xn = x(ii);
                yn = y(ii)+1;
                posloc = 2;
                isminis = isminis + ssd(pattern(xn,yn),unplacedpieces,posloc);
                count = count + 1;
            end
            [ismini,minpiece] = min(isminis);
            if ismini/count < mini
                mini = ismini;
                bestmpiece = unplacedpieces(minpiece);
                loc = posloc;
                startposrow = 1+(xn-1)*blk_size;
                startposcol = 1+(yn-1)*blk_size;
                if ~isempty(find(pattern == bestmpiece, 1))
                    keyboard
                end
            end
        end
        if mini == Inf
            keyboard            
        end
        if ~alreadyfullrow
            ind = pattern(:,1);
            ind(ind == 0) = [];
            [minx, x] = min(ssd(ind,unplacedpieces,2));
            [ismini, xn] = min(minx);
            if ismini < mini
                mini = ismini;
                bestmpiece = unplacedpieces(x);
                loc = 2;
                startposrow = 1+(find(pattern(:,1)==ind(xn))-1)*blk_size;
                startposcol = 1;
                if ~isempty(find(pattern == bestmpiece, 1))
                    keyboard
                end
            end
            ind = pattern(:,end);
            ind(ind == 0) = [];
            [minx, x] = min(ssd(ind,unplacedpieces,1));
            [ismini, xn] = min(minx);
            if ismini < mini
                mini = ismini;
                bestmpiece = unplacedpieces(x);
                loc = 1;
                startposrow = 1+(find(pattern(:,end) == ind(xn))-1)*blk_size;
                startposcol = 1+(n-1)*blk_size;
                
                if ~isempty(find(pattern == bestmpiece, 1))
                    keyboard
                end
            end
            
        end
            
        if ~alreadyfullcol
            ind = pattern(1,:);
            ind(ind == 0) = [];
            [minx, x] = min(ssd(ind,unplacedpieces,4));
            [ismini, xn] = min(minx);
            if ismini < mini
                mini = ismini;
                bestmpiece = unplacedpieces(x);
                loc = 4;
                startposrow = 1;
                startposcol = 1+(find(pattern(1,:) == ind(xn))-1)*blk_size;
                if ~isempty(find(pattern == bestmpiece, 1))
                    keyboard
                end
            end
            ind = pattern(end,:);
            ind(ind == 0) = [];
            [minx, x] = min(ssd(ind,unplacedpieces,3));
            [ismini, xn] = min(minx);
            if ismini < mini
                mini = ismini;
                bestmpiece = unplacedpieces(x);
                loc = 3;
                startposrow = 1+(m-1)*blk_size;
                startposcol = 1+(find(pattern(end,:) == ind(xn))-1)*blk_size;
                if ~isempty(find(pattern == bestmpiece, 1))
                    keyboard
                end
            end
        end
            
            
%             [x, y] = find(pattern==pieces(ii));
%             for jj = 1:numel(possibilities)
%                 for kk=1:4
%                     ismini = compatibility(x,y,possibilities(jj),kk,pattern,ssd);
%                     if ismini < mini
%                         mini = ismini;
%                         bestmpiece = possibilities(jj);
%                         loc = kk;
%                         [m,n] = find(pattern == pieces(ii));
%                         startposrow = 1+(m-1)*blk_size;
%                         startposcol = 1+(n-1)*blk_size;
%                     end
%                 end
%             end
%         end
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
            keyboard
            error('no solution')
        end
end
if pattern((startposrow-1)/blk_size+1,(startposcol-1)/blk_size+1) == 0
    keyboard
end
    
    
    