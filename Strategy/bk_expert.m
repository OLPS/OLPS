% Bin Li (libin@pmail.ntu.edu.sg)
% This program generates portfolio for a specified parameter setting.
% BK expert
%
% function [weight] = bk_expert(data, k, l, c)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% k, l: a specified parameter setting
% c: correlation coefficient threshold
%
% Example: [weight] = bk_expert(data, k, l, c);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = bk_expert(data, k, l, c)

[T, N] = size(data);

m = 0;
histdata = zeros(T, N); 

if (T <= k+1),
    weight = ones(1, N)/N;
    return;
end

if (k == 0) && (l == 0),
    histdata = data(1:T, :);
    m = T;
else
    for i = k+1:T,
        data2 = (data(i-k:i-1, :) - data(T-k+1:T, :));
        %
        if (sqrt(trace(data2*data2')) <= c/l),
            m = m + 1;
            histdata(m, :) = data(i, :);
        end
    end
end

if (m == 0),
    weight = ones(1, N)/N;
    return;
end

% The optimization is extremely time comsuming, if can improve, then
% contribution.
A=[]; b=[];
Aeq = ones(1, N); beq = 1;
lb = zeros(1, N); ub = ones(1, N);
x0 = ones(1, N)/N;

if (exist('OCTAVE_VERSION', 'builtin'))
    [weight] = sqp(x0, @(x)(-prod(histdata(1:m, :)*x)), @(x)(1-sum(x)), [], 0, 1);
else
    options = optimset('LargeScale', 'off', 'Algorithm', 'active-set', 'Display', 'off');
    weight = fmincon(@(w)(-prod(histdata(1:m, :)*w')), ...
        x0, A, b, Aeq, beq, lb, ub, [], options);
end
weight = weight';  % 1*m -> m*1

end