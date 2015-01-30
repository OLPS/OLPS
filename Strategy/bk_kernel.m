function [weight, exp_w] = bk_kernel(data, K, L, c, exp_ret, exp_w)
% This program output the final portfolio the BK strategy on data
% Bk has multiple experts, thus, we combine them in the kernel file.
%
% function [weight, exp_w] = bk_kernel(data, K, L, c, exp_ret, exp_w)
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
% Example: [weight, exp_w] = bk_kernel(data, K, L, c, exp_ret, exp_w);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exp_w(K*L+1, :) = bk_expert(data, 0, 0, c); 
for k=1:1:K,
    for l=1:1:L,
        exp_w((k-1)*L+l, :) = bk_expert(data, k, l, c);
    end
end

% Combine portfolios according to q(k, l) and previous expert return
numerator = bk_kernel_q(0, 0, K, L)*exp_ret(1, L+1)*exp_w(K*L+1, :);
denominator = bk_kernel_q(0, 0, K, L)*exp_ret(1, L+1);
for k=1:K,
    for l=1:L,
        numerator = numerator + bk_kernel_q(k, l, K, L)*exp_ret(k, l)*exp_w((k-1)*L+l, :);
        denominator = denominator + bk_kernel_q(k, l, K, L)*exp_ret(k, l);
    end
end

weight=numerator'/denominator;

end