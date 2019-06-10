function [ new_label ] = label_correction( class, label, mode)
%LABEL_CORRECTON  Make class and label consistent for clustering.
%   Detailed explanation goes here


new_label = zeros(length(class),1);
uc = unique(class);
ul = unique(label);
num_uc = length(uc);
num_ul = length(ul);

if mode == 1
    % assign by ratio
    
    for i=1:num_ul
        for j=1:num_uc
            nij(j) = sum(label==ul(i) & class==uc(j)) / sum(class==uc(j));
        end
        [~,max_idx] = max(nij);
        new_label(label==ul(i)) = uc(max_idx);
    end
    
else
    % assign by order
    for i=1:num_ul
        label_num(i) = sum(label == label(i));
    end
    [~,sort_idx] = sort(label_num, 'descend');
    for i=1:num_ul
        new_label(label == ul(sort_idx(i))) = i;
    end
end


end