function smcl(dataset_name)
% Author: Yang Lu (lylylytc@gmail.com)

% Please cite the paper if the codes are helpful for you research:
% Yang Lu, Yiu-ming Cheung, and Yuan Yan Tang, "Self-Adaptive 
% Multi-Prototype-based Competitive Learning Approach: A k-means-type 
% Algorithm for Imbalanced Data Clustering", IEEE Transactions on 
% Cybernetics (TCYB), DOI:10.1109/TCYB.2019.2916196.


% set random seed
rng(123)

% dataset path and name
dataset_path = 'dataset/';
load([dataset_path dataset_name]);

% data normalization
data = bsxfun(@rdivide,bsxfun(@minus, data, min(data, [], 1)), max(data, [], 1) - min(data, [], 1));

% precompute
data_dist = pdist2(data, data);
data_num = size(data, 1);
data_min = min(data);
data_max = max(data);
for i=1:data_num
    sort_d = sort(data_dist(i, :), 'ascend');
    mean_d(i) = mean(sort_d(1:round(0.02 * data_num)));
end
ball_graph = zeros(data_num);
ball_graph(data_dist < mean(mean_d)) = 1;

% parameter setting
smcl_options.E = 1000;
smcl_options.K0 = 2;
smcl_options.alpha_c = 0.005;
smcl_options.gamma = 0.005;
smcl_options.xi = 0.001;

% plot setting
scrsz = get(groot, 'ScreenSize');
plot_options.mod_num = 100;
plot_options.fix_plot = [data_min(1) data_max(1) data_min(2) data_max(2)];

% main
fprintf('SMCL starts on dataset %s...\n', dataset_name);
tic;

% PNS
m = pns(data, ball_graph, data_dist, smcl_options, plot_options);

% SGMS
[pred_all, cluster_num, measure_sep, measure_com, sep_com] = sgms(data, m);

fprintf('Finish SMCL in %.4f second\n', toc)

% show results and plots
show_result(data, label, pred_all, cluster_num, measure_sep, measure_com, sep_com)

