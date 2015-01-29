% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the CORNU algorithm
% Rather than CORN, CORNU has multiple experts
% And we combine them in this kernel file.
%
% function [weight, exp_w] = cornu_kernel(data, K, L, c, exp_ret, exp_w)
%
% weight: final portfolio, used for next rebalance
% exp_w: today's individual expert's portfolio
%
% data: market sequence vectors
% K: maximum window size
% L: splits into L parts, in each K
% c: similarity threshold
% exp_ret: historical cumulative return used to weight the portfolios
% exp_w: experts' last portfolios
%
% Example: [weight, exp_w] = cornu_kernel(data, K, L, c, exp_ret, exp_w);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight, exp_w] = cornu_kernel(data, K, L, c, exp_ret, exp_w)

for k=1:1:K,
    for l=1:1:L,
        exp_w((k-1)*L+l, :) = corn_expert(data, k, c);
    end
end

% Combine portfolios according to q(k, l) and previous expert return
numerator = 0;
denominator = 0;
for k=1:K,
    for l=1:L,
        numerator = numerator + corn_kernel_q(k, l, K, L)*exp_ret(k, l)*exp_w((k-1)*L+l, :);
        denominator = denominator + corn_kernel_q(k, l, K, L)*exp_ret(k, l);
    end
end

weight=numerator'/denominator;

end