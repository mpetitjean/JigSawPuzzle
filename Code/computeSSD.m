function ssd = computeSSD(puzzle)
% Compute the Sum of Squared Distance of the puzzle
% 3rd dimension index 1 is LeftRight
% 3rd dimension index 2 is RightLeft
% 3rd dimension index 3 is TopBottom
% 3rd dimension index 4 is BottomTop

Npc = numel(puzzle);
ssd = zeros(Npc,Npc,4);
p = 3/10;
q = 1/16;
for ii = 1:Npc
    for jj = 1:Npc
        ssd(ii,jj,1) = sum(sum(abs((puzzle{ii}(:,end,:) - puzzle{jj}(:,1,:))).^p))^(q/p);
        ssd(ii,jj,2) = sum(sum(abs((puzzle{ii}(:,1,:) - puzzle{jj}(:,end,:))).^p))^(q/p);
        ssd(ii,jj,3) = sum(sum(abs((puzzle{ii}(end,:,:) - puzzle{jj}(1,:,:))).^p))^(q/p);
        ssd(ii,jj,4) = sum(sum(abs((puzzle{ii}(1,:,:) - puzzle{jj}(end,:,:))).^p))^(q/p);
    end
end