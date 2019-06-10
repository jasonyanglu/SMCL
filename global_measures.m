function [ pred_all, global_sep, global_com, cluster_num ] = global_measures( data, pairwise_sep, pred, K )
%GLOBAL_MEASURES   Calculate the global separability and global compactness.
%   data: input data
%   pairwise_sep: pairwise separation measure returned by one_dim_gm_pdf
%   pred: prediction result
%   K: number of seed points
%
%   pred_all: all prediction of intermediate clustering result
%   global_sep: global separability
%   global_com: global compactness
%   cluster_num: number of clusters

for i=1:K
    group_set{i} = i;
end

for k=K:-1:2
    s = inf * ones(k, k);
    for i=2:k
        for j=1:i-1
            ss = 0;
            ss_i = 1;
            for ii = group_set{i}
                for jj = group_set{j}
                    ss(ss_i) = pairwise_sep( ii, jj );
                    ss_i = ss_i + 1;
                end
            end
            s(i,j) = min(ss);
        end
    end
    [min_s,min_idx] = min(s(:));
    [i,j] = ind2sub([k, k], min_idx);
    
    group_set = [group_set [group_set{i}, group_set{j}]];
    group_set([i,j]) = [];
    global_com(k-1) = min_s;
    
    for i=1:k-1
        new_pred(ismember(pred, group_set{i})) = i;
    end
    pred_all(k-1, :) = new_pred;
end

cluster_num = [];
for i=1:size(pred_all, 1)
    cluster_num(i) = length(unique(pred_all(i, :)));
end
[~, ia] = unique(cluster_num);

k = 10;
nn_idx = my_knn( data, data, [], k);
global_sep = [];
for i=1:length(ia)
    [global_sep(i)] = calculate_global_sep(pred_all(ia(i), :), nn_idx);
    global_sep(i) = max(global_sep(1:i));
end

end


function [ sep ] = calculate_global_sep( pred, nn_idx )
%CALCULATE_MEASURE Summary of this function goes here
%   Detailed explanation goes here

u_label = unique(pred);
cluster_num = length(u_label);

for i=1:cluster_num
    sep(i) = sum(sum(ismember(...
        nn_idx(:,pred==u_label(i)),find(pred~=u_label(i))))) / ...
        size(nn_idx,1);
end
sep = max(sep);

end


function [ nn_idx ] = my_knn( sel_data, data, catidx, k )
%MY_KNN Summary of this function goes here
%   Detailed explanation goes here

[sel_num, fea_num] = size(sel_data);
k = min(k, sel_num-1);
data_num = size(data, 1);

cat_num = length(catidx);
num_idx = setdiff(1:fea_num, catidx);
med_std = median(std(data(:, num_idx)));

cat_mat = zeros(sel_num, data_num);
for i=1:sel_num
    for j=1:data_num
        for l=1:cat_num
            cat_mat(i,j) = cat_mat(i, j) + double(sel_data(i, catidx(l)) ~= data(j, catidx(l)));
        end
    end
end

num_pd = pdist2(sel_data(:, num_idx), data(:, num_idx));
sq_dist = sqrt(num_pd.^2 + med_std^2 * cat_mat);

[~,nn_idx] = sort(sq_dist, 2, 'ascend');
nn_idx = nn_idx(:, 2:k+1)';

end


