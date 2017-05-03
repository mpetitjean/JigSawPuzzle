function ssd = computeSSD(puzzle)
% Compute the Sum of Squared Distance of the puzzle
% 3rd dimension index 1 is LeftRight
% 3rd dimension index 2 is RightLeft
% 3rd dimension index 3 is TopBottom
% 3rd dimension index 4 is BottomTop

Npc = size(puzzle,3);
ssd = zeros(Npc,Npc,4);

for ii = 1:Npc
    for jj = ii:Npc
        ssd(ii,jj,1) = sum((puzzle(:,end,ii) - puzzle(:,1,jj)).^2);
        ssd(ii,jj,2) = sum((puzzle(:,1,ii) - puzzle(:,end,jj)).^2);
        ssd(ii,jj,3) = sum((puzzle(end,:,ii) - puzzle(1,:,jj)).^2);
        ssd(ii,jj,4) = sum((puzzle(1,:,ii) - puzzle(end,:,jj)).^2);
    end
end