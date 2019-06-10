function [ m ] = pns( data, ball_graph, data_dist, smcl_options, plot_options )
%PNS Prototype Number Selection
%   data: input data
%   ball_graph: precomputed epsilon ball graph
%   data_dist: data pairwise distance matrix
%   smcl_options: parameters of smcl
%   plot_options: plot options

%   m: final vectors of seed points

K = smcl_options.K0;
data_num = size(data, 1);
rand_idx = randperm(size(data, 1));
m = data(rand_idx(1:K), :);
rho = sum(ball_graph);

m_old = m;

for epoch = 1:smcl_options.E
    fprintf('epoch %d', epoch);
    rand_idx = randperm(data_num);
    rand_data = data(rand_idx, :);
    n = ones(1, K);
    
    for data_i=1:data_num
        
        xt = rand_data(data_i, :);
        new_m = m;
        new_nc = n;

        dist = sqrt(sum(bsxfun(@minus, xt, m).^2, 2)');
        [~,sort_idx] = sort(dist, 'ascend');
        winner_idx = sort_idx(1);
        competitor_idx = sort_idx(2:end);

        % update winner
        new_m(winner_idx,:) = m(winner_idx, :) + K * smcl_options.alpha_c * (xt - m(winner_idx, :));
        new_nc(winner_idx) = n(winner_idx) + 1;
        
        % update competitors
        for k=1:K-1
            beta = exp(-(norm(xt - m(competitor_idx(k), :))^2 - norm(xt - m(winner_idx, :))^2) / ...
                norm(m(winner_idx, :)-m(competitor_idx(k), :))^2);
            new_m(competitor_idx(k),:) = m(competitor_idx(k), :) - ...
                K * smcl_options.alpha_c * smcl_options.gamma * beta * (xt - m(competitor_idx(k), :));
        end
        
        m = new_m;
        n = new_nc;

        animation_plot(data_i, epoch, m, data, plot_options);
        
    end
    
    max_norm = max(sum((m(n > 1, :) - m_old(n > 1, :)).^2, 2));
    if max_norm < smcl_options.xi && epoch < smcl_options.E
        
        d = pdist2(m, data);
        [~, min_idx] = min(d);
        pred = min_idx';
        count = [];
        for k=1:K
            count(k) = sum(pred == k);
        end
        theta = data_num * 0.02;
        delete_idx = find(count <= theta);
        if ~isempty(delete_idx)
            m(delete_idx,:) = [];
            n(delete_idx) = [];
            K = K - length(delete_idx);
            delete_idx_str = sprintf('%d, ', delete_idx);
            fprintf(': drive seed point %s out\n', delete_idx_str(1:end-2));
            break;
        end
        
        max_density_gap_idx = density_gap(data, m, n, rho, data_dist);
        m = [m; m(max_density_gap_idx, :)+ones(1, size(m, 2)) * 1e-4];
        fprintf(': duplicate seed point %d', max_density_gap_idx);
        K = K + 1;
    end
    fprintf('\n');
    m_old = m;
end

end

