function [ pred_all, cluster_num, global_sep, global_com, sep_com ] = sgms( data, m )
%SGMS Subcluster Grouping with Model Selection
%   data: input data
%   m: vectors of seed points
%   
%   pred_all: all prediction of intermediate clustering result
%   cluster_num: number of clusters
%   measure_sep: global separability
%   measure_com: global compactness
%   sep_com: global separability + global compactness


K = size(m,1);
d = pdist2(m, data);
[~,min_idx] = min(d);
pred = min_idx';

pairwise_sep = one_dim_gm_pdf(data, m, pred);
[pred_all, global_sep, global_com, cluster_num] = global_measures(data, pairwise_sep, pred, K);

global_sep = global_sep / max(global_sep);
global_com = global_com / max(global_com);
sep_com=global_sep + global_com;

end

