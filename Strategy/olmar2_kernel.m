% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the OLMAR-2 algorithm
% OLMAR has only one experts, thus, we go expert directly.
% If we want buy and hold, combine the experts here.
%
% function [weight, data_phi] ...
%    = olmar2_kernel(data, data_phi, weight_o, epsilon, alpha)
%
% weight: final portfolio, used for next rebalance
% data_phi: moving average used for next iteration
%
% data: market sequence vectors
% data_phi: last moving average
% weight_o: last portfolio
% epsilon: mean reversion threshold
% alpha: trade off parameter for calculating moving average
%
% Example: [weight, data_phi] ...
%           = olmar2_kernel(data, data_phi, weight_o, epsilon, alpha);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight, data_phi] ...
    = olmar2_kernel(data, data_phi, weight_o, epsilon, alpha)

[weight, data_phi] ...
    = olmar2_expert(data, data_phi, weight_o, epsilon, alpha);

end