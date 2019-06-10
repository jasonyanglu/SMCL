function show_result( data, label, pred_all, cluster_num, measure_sep, measure_com, sep_com )
%SHOW_RESULT Show the numerical results and plot figures
%   data: input data
%   label: ground truth
%   pred_all: all prediction of intermediate clustering result
%   cluster_num: number of clusters
%   measure_sep: global separability
%   measure_com: global compactness
%   sep_com: global separability + global compactness

[~,ia] = unique(cluster_num);

figure;hold on;
plot(cluster_num(ia), sep_com, '-s', 'MarkerSize', 10);
plot(cluster_num(ia), measure_sep, '-s', 'MarkerSize', 10);
plot(cluster_num(ia), measure_com, '-s', 'MarkerSize', 10);
legend('sep+com', 'sep', 'com');
xlabel('Global measures')

% label = label_correction(label, label, 2);
u_pred = unique(label);
figure;hold on;
for i=1:length(u_pred)
    plot(data(label==u_pred(i),1),data(label==u_pred(i),2), '.', 'MarkerSize', 10);
end
xlabel('Ground truth')

sep_com(1) = inf;
[~,median_pos] = min(sep_com);
pred = pred_all(median_pos, :);
pred = label_correction(label, pred', 1);
u_pred = unique(pred);
figure;hold on;
for i=1:length(u_pred)
    plot(data(pred==u_pred(i),1), data(pred==u_pred(i),2), '.', 'MarkerSize',10);
end
xlabel('SMCL clustering result')

smcl_result = clustering_evaluate(label, pred)

end

