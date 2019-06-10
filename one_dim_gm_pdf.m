function [ pairwise_sep ] = one_dim_gm_pdf( data, m, pred )
%ONE_DIM_GM_PDF 1-d Gaussian Mixture Probability Density Function
%   data: input data
%   m: vectors of seed points
%   pred: prediction result
%
%   pairwise_sep: pairwise separation measure between subclusters

K = size(m, 1);
pairwise_sep = zeros(K, K);


for i=1:K
    for j=i+1:K
        
        c_i = mean(data(pred==i, :));
        c_j = mean(data(pred==j, :));
        c_0 = (c_i + c_j) / 2;
        
        data_i = data(pred==i,:);
        data_j = data(pred==j,:);
        data_i_proj = bsxfun(@minus,data_i, c_0) * (c_i - c_j)' / norm(c_i - c_j)^2;
        data_j_proj = bsxfun(@minus,data_j, c_0) * (c_i - c_j)' / norm(c_i - c_j)^2;
        sigma_mat(:,:,1) = std(data_j_proj)^2;
        sigma_mat(:,:,2) = std(data_i_proj)^2;
        
        GMModel = [];
        GMModel.mu = [0.5;-0.5];
        y = pdf(gmdistribution(GMModel.mu, sigma_mat,...
            [sum(pred == i) sum(pred == j)] / (sum(pred == i) + sum(pred == j))),...
            [-0.5:.01:0.5]');
        
        pairwise_sep(i,j) = 1 / min(y);
        
    end
end

pairwise_sep = max(pairwise_sep, pairwise_sep');

end

