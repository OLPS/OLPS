% Bin Li (libin@pmail.ntu.edu.sg)
% This program generates portfolio for a specified parameter setting.
% OLMAR-1 expert
%
% function weight = olmar1_expert(data, weight_o, epsilon, W)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% weight_o: last portfolio
% epsilon: mean reversion threshold
% W: window size for calculating moving average
%
% Example: weight = olmar1_expert(data, weight_o, epsilon, W)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function weight = olmar1_expert(data, weight_o, epsilon, W)

[T, N] = size(data);

if (T < W+1)
    data_phi = data(T, :);
else
    data_phi = zeros(1, N);
    tmp_x = ones(1, N);
    for i = 1:W,
        data_phi = data_phi + 1./tmp_x;
        tmp_x = tmp_x.*data(T-i+1, :);
    end
    
    data_phi = data_phi*(1/W);
end

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