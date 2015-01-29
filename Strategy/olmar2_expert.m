% Bin Li (libin@pmail.ntu.edu.sg)
% This program generates portfolio for a specified parameter setting.
% OLMAR-2 expert
%
% function [weight, data_phi] ...
%           = olmar2_expert(data, data_phi, weight_o, epsilon, alpha)
%
% weight: experts portfolio, used for next rebalance/combination,if
% necessary
% data_phi: moving average for next iteration% 
%
% data: market sequence vectors
% data_phi: last moving average
% weight_o: last portfolio
% epsilon: mean reversion threshold
% alpha: trade off parameter for moving average
%
% Example: weight = olmar1_expert(data, weight_o, epsilon, alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight, data_phi] = olmar2_expert(data, data_phi, weight_o, epsilon, alpha)

[T, N] = size(data);

data_phi = alpha+(1-alpha)*data_phi./data(T, :);

% Step 3: Suffer loss
ell = max([0 epsilon - data_phi*weight_o]);

% Step 4: Set parameter
x_bar = mean(data_phi);
denominator = (data_phi - x_bar)*(data_phi - x_bar)';
if (~eq(denominator, 0.0)),
    lambda = ell / denominator;
else  % Zero volatility
    lambda = 0;
end

% Step 5: Update portfolio
weight = weight_o + lambda*(data_phi' - x_bar);

% Step 6: Normalize portfolio
weight = simplex_projection(weight, 1);

end