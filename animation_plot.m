function animation_plot( i, epoch, m, data, options)
%ANIMATION_PLOT   Plot the data and seed points with animation.
%   i: the ith data in the current epoch
%   epoch: current epoch
%   m: vectors of seed points
%   options: plot options


data_num = size(data, 1);        
d = pdist2(m, data);
[~,min_idx] = min(d);
pred = min_idx';

if mod(data_num * (epoch - 1) + i, options.mod_num) == 0
    
    if isempty(pred)
        d = pdist2(m, data);
        [~, min_idx] = min(d);
        pred = min_idx';
    end
    
    cla;
    for k = 1:size(m, 1)
        plot(data(pred == k, 1), data(pred == k, 2), '.', 'MarkerSize', 10);
        hold on;
        plot(m(k, 1), m(k, 2), 'pk', 'MarkerFaceColor', 'k', 'MarkerSize', 20);
    end
    xlabel(['epoch=' num2str(epoch)]);
    axis(options.fix_plot);
    drawnow
end

end

