function error = computeError(init, final)

Npiece = numel(final);
[m, n] = size(final);
error = 0;

init = init.';
init = init(:);

for ii = 1:Npiece
    [i,j] = ind2sub([m n],ii);
    
    if init(final(j,i)) ~= ii
        error = error + 1;
    end
end

error = error/Npiece*100;