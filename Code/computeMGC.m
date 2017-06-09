function finalmgc = computeMGC(puzzle,Nside)
% Compute the Mahalanobis Gradient Compatibility of the puzzle
% 3rd dimension index 1 is LeftRight
% 3rd dimension index 2 is RightLeft
% 3rd dimension index 3 is TopBottom
% 3rd dimension index 4 is BottomTop
dummyDiffs = [ 0 0 0 ; 1 1 1; -1 -1 -1; 0 0 1; 0 1 0; 1 0 0 ; -1 0 0 ; 0 -1 0; 0 0 -1]; 
Npc = numel(puzzle);
mgc = zeros(Npc,Npc,4);
finalmgc = mgc;
S = zeros(3,3,4);
mu = zeros(4,3);
PDiff = zeros(Nside,3,4);
P2Diff = zeros(Nside,3,4);
for ii = 1:Npc
    PDiff(:,:,1) = squeeze(puzzle{ii}(:,end,:) - puzzle{ii}(:,end-1,:));
    PDiff(:,:,2) = squeeze(puzzle{ii}(:,1,:) - puzzle{ii}(:,2,:));
    PDiff(:,:,3) = squeeze(puzzle{ii}(end,:,:) - puzzle{ii}(end-1,:,:));
    PDiff(:,:,4) = squeeze(puzzle{ii}(1,:,:) - puzzle{ii}(2,:,:));
    
    mu(1,:) = mean(PDiff(:,:,1));
    mu(2,:) = mean(PDiff(:,:,2));
    mu(3,:) = mean(PDiff(:,:,3));
    mu(4,:) = mean(PDiff(:,:,4));
    S(:,:,1) = inv(cov(double([PDiff(:,:,1);dummyDiffs])));
    S(:,:,2) = inv(cov(double([PDiff(:,:,2);dummyDiffs])));
    S(:,:,3) = inv(cov(double([PDiff(:,:,3);dummyDiffs])));
    S(:,:,4) = inv(cov(double([PDiff(:,:,4);dummyDiffs])));
    if ~isempty(find(S==Inf,1))
        disp('not inversible')
        keyboard;
    end
    for jj = 1:Npc
        P2Diff(:,:,1) = squeeze(puzzle{jj}(:,1,:) - puzzle{ii}(:,end,:))-mu(1,:);
        P2Diff(:,:,2) = squeeze(puzzle{jj}(:,end,:) - puzzle{ii}(:,1,:))-mu(2,:);
        P2Diff(:,:,3) = squeeze(puzzle{jj}(1,:,:) - puzzle{ii}(end,:,:))-mu(3,:);
        P2Diff(:,:,4) = squeeze(puzzle{jj}(end,:,:) - puzzle{ii}(1,:,:))-mu(4,:);
        mgc(ii,jj,1) = sum(diag(P2Diff(:,:,1)*S(:,:,1)*P2Diff(:,:,1).'));
        mgc(ii,jj,2) = sum(diag(P2Diff(:,:,2)*S(:,:,2)*P2Diff(:,:,2).'));
        mgc(ii,jj,3) = sum(diag(P2Diff(:,:,3)*S(:,:,3)*P2Diff(:,:,3).'));
        mgc(ii,jj,4) = sum(diag(P2Diff(:,:,4)*S(:,:,4)*P2Diff(:,:,4).'));
    end
end

finalmgc(:,:,1) = mgc(:,:,1) + mgc(:,:,2).';
finalmgc(:,:,2) = mgc(:,:,2) + mgc(:,:,1).';
finalmgc(:,:,3) = mgc(:,:,3) + mgc(:,:,4).';
finalmgc(:,:,4) = mgc(:,:,4) + mgc(:,:,3).';
