function max_density_gap_idx = density_gap( data, m, n, rho, data_dist )
%MAX_DENSITY_GAP_IDX   Find the index of seed point with max density gap.
%   data: input data
%   m: vectors of seed points
%   n: cumulative number of winning times
%   rho: sample local density
%   data_dist: data pairwise distance matrix
%
%   max_density_gap_idx: the index of seed point with max density gap

    K = size(m, 1);
    [~,min_idx] = min(pdist2(m, data));
    pred = min_idx';
    mean_dist = mean(mean(data_dist(data_dist ~= 0)));

    for i=1:K
       
        min_dist = [];
        idx = find(pred == i);
        rho_i = rho(idx);
        for j=1:numel(idx)
            if rho_i(j) > mean(rho_i);
                larger_idx = find(rho_i(j) < rho_i);
                if isempty(larger_idx)
                    min_dist(j) = 0;
                else
                    min_dist(j) = min(pdist2(data(idx(j), :), data(idx(larger_idx), :)));
                end
            else
                min_dist(j) = 0;
            end
        end
        delta(i) = max(min_dist);
        delta(i) = delta(i) / mean_dist;
    end
    
    [~, max_density_gap_idx] = max(n .* delta);
end

