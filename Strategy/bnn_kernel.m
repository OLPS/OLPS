% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the BNN strategy on data
% Bk has multiple experts, thus, we combine them in the kernel file.
%
% function [weight, exp_w] = bnn_kernel(data, K, L, exp_ret, exp_w)
%
% weight: final portfolio, used for next rebalance
% exp_w: today's individual expert's portfolio
%
% data: market sequence vectors
% K: maximum window size
% L: splits into L parts, in each K
% exp_ret: historical cumulative return used to weight the portfolios
% exp_w: experts' last portfolios
%
% Example: [weight, exp_w] = bnn_kernel(data, K, L, exp_ret, exp_w);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [weight, exp_w] = bnn_kernel(data, K, L, exp_ret, exp_w)

exp_w(K*L+1, :) = bnn_expert(data, 0, 0);
for k=1:1:K,
    for l=1:1:L,
        pl=0.02+0.5*(l-1)/(L-1);
        exp_w((k-1)*L+l, :) = bnn_expert(data, k, pl);
    end
end

% Combine portfolios according to q(k, l) and previous expert return
numerator = bnn_kernel_q(0, 0, K, L)*exp_ret(1, L+1)*exp_w(K*L+1, :);
denominator = bnn_kernel_q(0, 0, K, L)*exp_ret(1, L+1);
for k=1:K,
    for l=1:L,
        numerator = numerator + bnn_kernel_q(k, l, K, L)*exp_ret(k, l)*exp_w((k-1)*L+l, :);
        denominator = denominator + bnn_kernel_q(k, l, K, L)*exp_ret(k, l);
    end
end

weight=numerator'/denominator;

end