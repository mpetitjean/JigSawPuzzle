% test function

clear; close all;
Im = {'imData/1.png' 'imData/2.png' 'imData/3.png' 'imData/4.png' ...
    'imData/5.png' 'imData/6.png' 'imData/7.png' 'imData/8.png' ...
    'imData/9.png' 'imData/10.png' 'imData/11.png' 'imData/12.png' ...
    'imData/13.png' 'imData/14.png' 'imData/15.png' 'imData/16.png' ...
    'imData/17.png' 'imData/18.png' 'imData/19.png' 'imData/20.png' };
blk_size = 56;
method = {'ssd' 'lpq' 'mgc' 'm+s' 'm+lpq'};
accuracy = zeros(length(method),1);
Nexp = 10;
parfor ii = 1:length(method)
    for jj = 1:length(Im)
        for aa = 1:Nexp
            accuracy(ii) = accuracy(ii) + main(Im {jj},blk_size,method{ii});
        end
    end
end
accuracy = accuracy / length(Im) / Nexp;