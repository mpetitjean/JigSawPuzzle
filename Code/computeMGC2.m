function [finalmgc,mgc,P2Diff, PDiff, mu, S] = computeMGC2(puzzle,Nside)
% Compute the Mahalanobis Gradient Compatibility of the puzzle
% 3rd dimension index 1 is LeftRight
% 3rd dimension index 2 is RightLeft
% 3rd dimension index 3 is TopBottom
% 3rd dimension index 4 is BottomTop
dummyDiffs = [ 0 0 0 ; 1 1 1; -1 -1 -1; 0 0 1; 0 1 0; 1 0 0 ; -1 0 0 ; 0 -1 0; 0 0 -1]; 
Npc = numel(puzzle);
mgc = zeros(Npc,Npc,4);
finalmgc = mgc;
S = zeros(3,3,Npc,1,4);
mu = zeros(4,3,Npc);
PDiff = zeros(Nside,3,4,Npc);
P2Diff = zeros(Nside,3,Npc,Npc,4);
A = cat(4,puzzle{:});
B = cat(5,puzzle{:});
PDiff(:,:,1,:) = squeeze(A(:,end,:,:) - A(:,end-1,:,:));
PDiff(:,:,2,:) = squeeze(A(:,1,:,:) - A(:,2,:,:));
PDiff(:,:,3,:) = squeeze(A(end,:,:,:) - A(end-1,:,:,:));
PDiff(:,:,4,:) = squeeze(A(1,:,:,:) - A(2,:,:,:));

mu(1,:,:) = mean(PDiff(:,:,1,:));
mu(2,:,:) = mean(PDiff(:,:,2,:));
mu(3,:,:) = mean(PDiff(:,:,3,:));
mu(4,:,:) = mean(PDiff(:,:,4,:));
newPDiff = [PDiff;repmat(dummyDiffs,1,1,4,Npc)];
for ii= 1:Npc
    S(:,:,ii,1,1) = inv(cov((newPDiff(:,:,1,ii))));
    S(:,:,ii,1,2) = inv(cov((newPDiff(:,:,2,ii))));
    S(:,:,ii,1,3) = inv(cov((newPDiff(:,:,3,ii))));
    S(:,:,ii,1,4) = inv(cov((newPDiff(:,:,4,ii))));
end
if ~isempty(find(S==Inf,1))
    disp('not inversible')
    keyboard;
end

P2Diff(:,:,:,:,1) = squeeze(B(:,1,:,:,:) - A(:,end,:,:))-mu(1,:,:);
P2Diff(:,:,:,:,2) = squeeze(B(:,end,:,:,:) - A(:,1,:,:))-mu(2,:,:);
P2Diff(:,:,:,:,3) = squeeze(B(1,:,:,:,:) - A(end,:,:,:))-mu(3,:,:);
P2Diff(:,:,:,:,4) = squeeze(B(end,:,:,:,:) - A(1,:,:,:))-mu(4,:,:);

mgc(:) = permute(sum(sum(mtimesx(P2Diff,S).*P2Diff)),[3 4 5 1 2]);


finalmgc(:,:,1) = mgc(:,:,1) + mgc(:,:,2).';
finalmgc(:,:,2) = mgc(:,:,2) + mgc(:,:,1).';
finalmgc(:,:,3) = mgc(:,:,3) + mgc(:,:,4).';
finalmgc(:,:,4) = mgc(:,:,4) + mgc(:,:,3).';
