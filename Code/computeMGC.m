function mgc = computeMGC(puzzle)
% Compute the Mahalanobis Gradient Compatibility of the puzzle
% 3rd dimension index 1 is LeftRight
% 3rd dimension index 2 is RightLeft
% 3rd dimension index 3 is TopBottom
% 3rd dimension index 4 is BottomTop

Npc = size(puzzle,3);
mgc = zeros(Npc,Npc,4);

for ii = 1:Npc
    % Compute the average color differences
    mu(1) = sum(puzzle(:,end,ii) - puzzle(:,end-1,ii));
    mu(2) = sum(puzzle(:,2,ii) - puzzle(:,1,ii));
    mu(3) = sum(puzzle(end,:,ii) - puzzle(end-1,:,ii));
    mu(4) = sum(puzzle(2,:,ii) - puzzle(1,:,ii));
    
    for jj = ii:Npc
        mgc(ii,jj,1) = sum((puzzle(:,1,jj) - puzzle(:,end,ii) - mu(1)).^2);
        mgc(ii,jj,2) = sum((puzzle(:,end,jj) - puzzle(:,1,ii) - mu(2)).^2);
        mgc(ii,jj,3) = sum((puzzle(1,:,jj) - puzzle(end,:,ii) - mu(3)).^2);
        mgc(ii,jj,4) = sum((puzzle(end,:,jj) - puzzle(1,:,ii) - mu(4)).^2);
    end
end

mgc(:,:,1) = mgc(:,:,1) + mgc(:,:,2).'; 
mgc(:,:,2) = mgc(:,:,2) + mgc(:,:,1).'; 
mgc(:,:,3) = mgc(:,:,3) + mgc(:,:,4).'; 
mgc(:,:,4) = mgc(:,:,4) + mgc(:,:,3).'; 