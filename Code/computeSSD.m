function ssd = computeSSD(puzzle,p,q)
% Compute the Sum of Squared Distance of the puzzle
% 3rd dimension index 1 is LeftRight
% 3rd dimension index 2 is RightLeft
% 3rd dimension index 3 is TopBottom
% 3rd dimension index 4 is BottomTop

Npc = numel(puzzle);
ssd = zeros(Npc,Npc,4);
% p = 3/10;
% q = 1/16;
A = cat(4,puzzle{:});
B = cat(5,puzzle{:});
ssd(:,:,1) = sum(sum(abs(A(:,end,:,:) - B(:,1,:,:,:)).^p)).^(q/p);
ssd(:,:,2) = sum(sum(abs(A(:,1,:,:) - B(:,end,:,:,:)).^p)).^(q/p);
ssd(:,:,3) = sum(sum(abs(A(end,:,:,:) - B(1,:,:,:,:)).^p)).^(q/p);
ssd(:,:,4) = sum(sum(abs(A(1,:,:,:) - B(end,:,:,:,:)).^p)).^(q/p);