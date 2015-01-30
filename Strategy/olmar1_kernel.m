function weight = olmar1_kernel(data, weight_o, epsilon, W)
% This program output the final portfolio the OLMAR-1 algorithm
% OLMAR-1 has only one experts, thus, we go expert directly.
% If we want buy and hold, combine the experts here.
%
% function [weight] = olmar1_expert(data, weight_o, epsilon, W);
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% weight_o: last portfolio
% epsilon: mean reversion threshold
% W: window size for calculating moving average
%
% Example: [weight] = olmar1_expert(data, weight_o, epsilon, W);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

weight = olmar1_expert(data, weight_o, epsilon, W);

end