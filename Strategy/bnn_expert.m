function [weight] = bnn_expert(data, k, pl)
% This program generates portfolio for a specified parameter setting.
% BNN strategy
%
% function [weight] = bnn_expert(data, k, pl)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% pl: parameter to control the no. of nearest neighbors
% c: correlation coefficient threshold
%
% Example: [weight] = bnn_expert(data, k, pl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[T, N] = size(data);

m = 0;
histdata = zeros(T, N); 
normid = zeros(T-k, 1);

if (T <= k+1),
    weight = ones(1, N)/N;
    return;
end

if (k == 0) && (pl == 0),
    histdata = data(1:T, :);
    m=T;
else
    histdata = data(1:T, :);
    normid(1:k) = inf;
    for i = k+1:T,
        data2 = data(i-k:i-1, :) - data(T-k+1:T, :);
        normid(i) = sqrt(trace(data2*data2'));
    end;
    
    [~, sortpos] = sort(normid);
    m = floor(pl*T);
    histdata = histdata(sortpos(1:m), :);
end

if (m == 0),
    weight = ones(1, N)/N;
    return;
end

A=[]; b=[];
Aeq = ones(1, N); beq = 1;
lb = zeros(1, N); ub = ones(1, N);
x0=ones(1, N)/N;

if (exist('OCTAVE_VERSION', 'builtin'))
    [weight] = sqp(x0, @(x)(-prod(histdata(1:m, :)*x)), @(x)(1-sum(x)), [], 0, 1);
else
    options = optimset('LargeScale', 'off', 'Algorithm', 'active-set', 'Display', 'off');

    weight = fmincon(@(w)(-prod(histdata(1:m, :)*w')), ...
        x0, A, b, Aeq, beq, lb, ub, [], options);
end
weight = weight';

end