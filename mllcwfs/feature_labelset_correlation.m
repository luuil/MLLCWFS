function fLC = feature_labelset_correlation(Data, f, L, type)
%Correlation between the feature f and the label set L
% Inputs:
% 
%  Data: the dataset.
%  f:    the index of a feature in dataset 'Data'.
%  L:    the index vector of the labelset in dataset 'Data'.
%  type: weighting strategy.
%         - 'NCA': No Correlation Asignment
%         - 'LCA': Large Correlation Asignment
%         - 'SCA': Small Correlation Asignment
% Outputs:
% 
%  fLC:  the correlation

ln  = size(L);
fLC = zeros(1, ln);

for i = 1 : ln
    l_i = Data( L(i) ); % label L_i
    fLC(i) = mutualinfo(f, l_i);
end

w = weighting(Data, L, type);
fLC = 0;
if ~isempty(w)
    fLC = fLC * w';
end

end