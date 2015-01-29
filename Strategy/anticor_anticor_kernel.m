% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the BAH(Anticor(Anticor)) strategy
% BAH(Anticor()) has two folds of experts
%
% function [weight, exp_w, exp_w2]...
%    = anticor_anticor_kernel(data, W, exp_ret, exp_w, data_day, exp_ret2, exp_w2)
%
% weight: final portfolio, used for next rebalance
% exp_w: experts weights in the first fold
% exp_w2: experts weights in the second fold
%
% data: market sequence vectors
% W: maximum window size, the number of experts (W-1)
% exp_ret: experts' return in the first fold
% exp_w: experts' weights in the first fold
% data_day: sequence data used for the second Anticor
% exp_ret2: experts' return in the second fold
% exp_w2: experts' weights in the second fold
%
% Example: [day_weight, exp_w, exp_w2] ...
%            = anticor_anticor_kernel(data(1:t-1, :), W, ...
%            exp_ret, exp_w, data_day(1:t-1, :), exp_ret2, exp_w2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight, exp_w, exp_w2]...
    = anticor_anticor_kernel(data, W, ...
    exp_ret, exp_w, data_day, exp_ret2, exp_w2)

for i = 2:W,
    exp_w(i-1, :) = anticor_expert(data, exp_w(i-1, :)', i);
end
%data_day(nday+1, : , i-1) = data_t*exp_w(:, :, i-1)';

for i = 2:W,
    exp_w2(i-1, :) = anticor_expert(data_day(:, :), exp_w2(i-1, :)', i);
end

% Combine portfolios according to q(k, l) and previous expert return
numerator = 0;  
denominator = 0;
for i=2:W,
    numerator = numerator + exp_ret2(i-1, 1)*exp_w2(i-1, :);
    denominator = denominator + exp_ret2(i-1, 1);
end

weight1 = numerator'/denominator;
weight = exp_w' * weight1;

end