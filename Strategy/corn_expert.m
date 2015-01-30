function [weight] = corn_expert(data, w, c)
% This program generates portfolio for a specified parameter setting.
% CORN expert
%
% function [weight] = corn_expert(data, w, c)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% w: parameter of window size
% c: correlation coefficient threshold
%
% Example: [weight] = corn_expert(data, w, c);

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

if (T <= w+1),
    weight = ones(N, 1)/N;
    return;
end

if (w == 0),
    histdata = data(1:T, :);
    m = T;
else
    for i=w+1:T,
        d1 = data(i-w:i-1, :);
        d2 = data(T-w+1:T, :);
        
        datacorr = corr(d1(:), d2(:));
        %
        if (datacorr >= c),
            m=m+1;
            histdata(m, :) = data(i, :);
        end
    end
end

if (m == 0),
    weight = ones(N, 1)/N;
    return;
end

A=[]; b=[];
Aeq = ones(1, N); beq = 1;
lb = zeros(1, N); ub = ones(1, N);
x0=ones(1, N)/N;

if (exist('OCTAVE_VERSION', 'builtin'))
    [weight] = sqp(x0, @(x)(-prod(histdata(1:m, :)*x)), @(x)(1-sum(x)), [], lb, ub);
else
    options = optimset('LargeScale', 'off', 'Algorithm', 'active-set', 'Display', 'off');

    weight = fmincon(@(w)(-prod(histdata(1:m, :)*w')), x0, A, b, Aeq, beq, lb, ub, [], options);
    weight = weight';
end


end