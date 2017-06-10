% test function

clear; close all;
Im = {'imData/1.png' 'imData/2.png' 'imData/3.png' 'imData/4.png' ...
    'imData/5.png' 'imData/6.png' 'imData/7.png' 'imData/8.png' ...
    'imData/9.png' 'imData/10.png' 'imData/11.png' 'imData/12.png' ...
    'imData/13.png' 'imData/14.png' 'imData/15.png' 'imData/16.png' ...
    'imData/17.png' 'imData/18.png' 'imData/19.png' 'imData/20.png' };
blk_size = 28;
method = 'lpq';
p = 0.05:0.05:3;
q = p;
accuracy = zeros(length(p),length(q));
Nexp = 10;
for kk = 1:length(q)
    parfor ii = 1:length(p)
        for jj = 1:length(Im)
            for aa = 1:Nexp
                accuracy(ii,kk) = accuracy(ii,kk) + main(Im{jj},blk_size,method,p(ii),q(kk));
            end
        end
    end
end
accuracy = accuracy / length(Im) / Nexp;
