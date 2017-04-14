function W = weighting(Data, L, type)
%Weight for each label in the label set L
%
% inputs:
%  Data: the dataset
%  L:    a set of index of the label set in dataset Data
%  type: weighting strategies
%         - 'NCA': No Correlation Asignment
%         - 'LCA': Large Correlation Asignment
%         - 'SCA': Small Correlation Asignment (default)
% outputs:
%  W:    the weight vector

if nargin < 3
    type = 'NCA';
end

ln = size(L);
lc = [];

switch type
    case 'NCA'
        lc = ones(1, ln);
    case 'LCA'
        lc = label_correlation(Data, L);
    case 'SCA'
        lc = label_correlation(Data, L);
        lc = 1 - lc; %invert, i.e. small asignment
    otherwise
        fprintf('%s', 'No such weighting strategy.');
end

W = [];
if ~isempty(lc)
    W  = zeros(1, ln); %weight vector
    for i = 1 : ln
        W(i) = lc(i) / sum(lc);
    end
end
end

%%%%%

function LC = label_correlation(Data, L)
%Label Correlation
% inputs:
%  Data: the dataset
%  L:    the index vector of the labelset in dataset 'Data'
% outputs:
%  LC:   the correlation vector

ln = size(L);
LC = zeros(1, ln);

for i = 1 : ln
    for j = 1 : ln
        if j ~= i
            l_i   = Data( L(i) ); %label L(i)
            l_j   = Data( L(j) ); %label L(j)
            LC(i) = LC(i) + mutualinfo(l_i, l_j);
        end
    end
    LC(i) = LC(i) / (ln - 1);
end
end