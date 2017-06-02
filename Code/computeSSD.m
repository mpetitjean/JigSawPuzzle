function ssd = computeSSD(puzzle)
% Compute the Sum of Squared Distance of the puzzle
% 3rd dimension index 1 is LeftRight
% 3rd dimension index 2 is RightLeft
% 3rd dimension index 3 is TopBottom
% 3rd dimension index 4 is BottomTop

Npc = size(puzzle,3);
ssd = zeros(Npc,Npc,4);
p = 3/10;
q = 1/16;
for ii = 1:Npc
    for jj = 1:Npc
        ssd(ii,jj,1) = sum(abs((puzzle(:,end,ii) - puzzle(:,1,jj))).^p)^(q/p);
        ssd(ii,jj,2) = sum(abs((puzzle(:,1,ii) - puzzle(:,end,jj))).^p)^(q/p);
        ssd(ii,jj,3) = sum(abs((puzzle(end,:,ii) - puzzle(1,:,jj))).^p)^(q/p);
        ssd(ii,jj,4) = sum(abs((puzzle(1,:,ii) - puzzle(end,:,jj))).^p)^(q/p);
    end
end