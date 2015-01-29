% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the BAH(Anticor) strategy
% BAH(Anticor) has one folds of experts
%
% function [weight, exp_w] = anticor_kernel(data, W, exp_ret, exp_w)
%
% weight: final portfolio, used for next rebalance
% exp_w: experts weights in the first fold
%
% data: market sequence vectors
% W: maximum window size, the number of experts (W-1)
% exp_ret: experts' return in the first fold
% exp_w: experts' weights in the first fold
%
% Example: [weight, exp_w] = anticor_kernel(data, W, exp_ret, exp_w)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight, exp_w] = anticor_kernel(data, W, exp_ret, exp_w)

for k=2:W,
    exp_w(k-1, :) = anticor_expert(data, exp_w(k-1, :)', k);
end

% Combine portfolios according to q(k, l) and previous expert return
numerator = 0;  
denominator = 0;
for k=2:W,
    numerator = numerator + exp_ret(k-1, 1)*exp_w(k-1, :);
    denominator = denominator + exp_ret(k-1, 1);
end

weight = numerator'/denominator;

end