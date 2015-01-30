function [weight, exp_w] = cornk_kernel(data, K, L, pc, exp_ret, exp_w)
% This program output the final portfolio the CORN topK algorithm
% Rather than CORN expert, CORNK has multiple experts
% And we combine them in this kernel file.
%
% function [weight, exp_w] = cornk_kernel(data, K, L, pc, exp_ret, exp_w)
%
% weight: final portfolio, used for next rebalance
% exp_w: today's individual expert's portfolio
%
% data: market sequence vectors
% K: maximum window size
% L: splits into L parts, in each K
% pc: percentage of topK experts
% exp_ret: historical cumulative return used to weight the portfolios
% exp_w: experts' last portfolios
%
% Example: [weight, exp_w] = cornk_kernel(data, K, L, pc, exp_ret, exp_w);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:1:K,
    for l=1:1:L,
        rho = (l-1)/L;
        exp_w((k-1)*L+l, :) = corn_expert(data, k, rho);
    end
end

% TOP-K method
nc = ceil(pc*K*L);  % number of experts to be combined
exp_ret_vec = exp_ret(:);
[exp_ret_sort]=sort(exp_ret_vec);
ret_rho = exp_ret_sort(K*L-nc+1);

% Combine portfolios according to q(k, l) and previous expert return
numerator = 0;
denominator = 0;
for k=1:K,
    for l=1:L,
        numerator = numerator + cornk_kernel_q(k, l, K, L, nc, exp_ret, ret_rho)*exp_ret(k, l)*exp_w((k-1)*L+l, :);
        denominator = denominator + cornk_kernel_q(k, l, K, L, nc, exp_ret, ret_rho)*exp_ret(k, l);
    end
end

weight=numerator'/denominator;

end