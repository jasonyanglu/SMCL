function output = clustering_evaluate( target, result )
%CLUSTERING_EVALUATE   Evaluate the clustering result
%   target: ground truth
%   result: clustering result


result = label_correction( target, result, 2);
target = label_correction( target, target, 2);

data_num = length(target);
target_length = length(unique(target));
result_length = length(unique(result));

b = zeros(target_length,1);
cb = 0;
cd = 0;
for i=1:target_length
    b(i) = sum(target==i);
    if b(i) >= 2
        cb = cb + nchoosek(b(i),2);
    else
        cd = cd + 0;
    end
end

d = zeros(result_length,1);
for i=1:result_length
    d(i) = sum(result==i);
    if d(i) >= 2
        cd = cd + nchoosek(d(i),2);
    else
        cd = cd + 0;
    end
end

n = zeros(target_length,result_length);
fval = zeros(target_length,result_length);
cn = 0;
for i=1:target_length
    for j=1:result_length
        n(i,j) = sum(target==i & result==j);
        if n(i,j) >= 2
            cn = cn + nchoosek(n(i,j),2);
        else
            cn = cn + 0;
        end
        rec = n(i,j) / b(i);
        pre = n(i,j) / d(j);
        fval(i,j) = 2 * rec * pre / (rec + pre);
    end
end


[n_max,max_idx] = max(n,[],2);
output.acc = 1 / data_num * sum(n_max);
output.pre = 1 / target_length * sum(n_max./b);
output.rec = 1 / target_length * sum(n_max./d(max_idx));
output.fval = sum(b / data_num .* max(fval,[],2));

temp = (cb * cd) / nchoosek(data_num,2);
output.ari = (cn - temp) / (0.5 * (cb + cd) - temp);

temp = 0;
for l=1:target_length
    for h=1:result_length
        temp = temp + 2 * n(l,h) / data_num * log(n(l,h) * data_num / (b(l) * d(h)) + eps);
    end
end
output.nmi = nmi(target, result);

if result_length == 1
    output.dcv = abs(sqrt(sum((b-mean(b)).^2)/(target_length-1))/mean(b));
else
    output.dcv = abs(sqrt(sum((b-mean(b)).^2)/(target_length-1))/mean(b) - sqrt(sum((d-mean(d)).^2)/(result_length-1))/mean(d));
end

output.cluster_num = length(unique(result));

end


function z = nmi(x, y)
% Compute normalized mutual information I(x,y)/sqrt(H(x)*H(y)) of two discrete variables x and y.
% Input:
%   x, y: two integer vector of the same length 
% Ouput:
%   z: normalized mutual information z=I(x,y)/sqrt(H(x)*H(y))
% Written by Mo Chen (sth4nth@gmail.com).
assert(numel(x) == numel(y));
n = numel(x);
x = reshape(x,1,n);
y = reshape(y,1,n);

l = min(min(x),min(y));
x = x-l+1;
y = y-l+1;
k = max(max(x),max(y));

idx = 1:n;
Mx = sparse(idx,x,1,n,k,n);
My = sparse(idx,y,1,n,k,n);
Pxy = nonzeros(Mx'*My/n); %joint distribution of x and y
Hxy = -dot(Pxy,log2(Pxy));


% hacking, to elimative the 0log0 issue
Px = nonzeros(mean(Mx,1));
Py = nonzeros(mean(My,1));

% entropy of Py and Px
Hx = -dot(Px,log2(Px));
Hy = -dot(Py,log2(Py));

% mutual information
MI = Hx + Hy - Hxy;

% normalized mutual information
z = sqrt((MI/Hx)*(MI/Hy));
z = max(0,z);

end