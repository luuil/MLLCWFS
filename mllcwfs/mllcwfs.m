function fea = mllcwfs(Data, F, L, weighting, K)
%Multi label feature selection based on mRMR
% The parameters:
%  D:         a N*M matrix, indicating N samples, each having M dimensions. Must be integers.
%  F:         a 1*X index matrix, indicating each sample have X features. Must be categorical. (X + Y = M)
%  L:         a 1*Y index matrix, indicating each sample have Y labels. Must be categorical. (X + Y = M)
%  weighting: weighting strategy.
%              - 'NCA': No Correlation Asignment
%              - 'LCA': Large Correlation Asignment
%              - 'SCA': Small Correlation Asignment
%  K:         the number of features need to be selected

bdisp = 1;
fn    = size(F);

if nargin < 4
    K = fn;
end

time = cputime;
t  = zeros(1, fn);

for i = 1 : fn
    % t(i) = mutualinfo(D(:,i), f);
    f_i = F(i); % the feature index
    t(i) = feature_labelset_correlation(Data, f_i, L, weighting);
end
fprintf('calculate the marginal dmi costs %5.1fs.\n', cputime - time);

[~, idxs] = sort(-t);
% fea_base = idxs(1:K);

fea(1)  = idxs(1);
KMAX    = min(2000, fn);
idxleft = idxs(2 : KMAX);

k = 1;
if bdisp==1
    fprintf('k=1 cost_time=(N/A) cur_fea=%d #left_cand=%d\n', ...
        fea(k), length(idxleft));
end;

for k = 2 : K
    time       = cputime;
    ncand      = length(idxleft);
    curlastfea = length(fea);
    for i = 1 : ncand
        % t_mi(i) = mutualinfo(D(:,idxleft(i)), f);
        
        f_i                             = idxleft(i); % the feature index
        t_mi(i)                         = feature_labelset_correlation(Data, f_i, L, weighting);
        mi_array(idxleft(i),curlastfea) = getmultimi( Data(:, fea(curlastfea) ), Data(:, idxleft(i)) );
        c_mi(i)                         = mean( mi_array(idxleft(i), :) );
        
    end
    
    [~, fea(k)] = max(t_mi(1 : ncand) - c_mi(1 : ncand));
    
    tmpidx          = fea(k);
    fea(k)          = idxleft(tmpidx);
    idxleft(tmpidx) = [];
    
    if bdisp==1
        fprintf('k=%d cost_time=%5.4f cur_fea=%d #left_cand=%d\n', ...
            k, cputime - time, fea(k), length(idxleft));
    end
end
end

%%%%%%%

function c = getmultimi(da, dt)
c = zeros(1,size(da,2));
for i=1:size(da, 2),
    c(i) = mutualinfo(da(:, i), dt);
end
end
