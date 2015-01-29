% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the ONS strategy on data
% Only one expert, thus, go through to the exper routine
% If multiple experts, combine them similar to BK algorithm (bk_kernel.m)
%
% function [weight] = ons_kernel(data, weight_o, eta, beta, delta)
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
% eta, beta, delta: ONS' parameters
%
% Example: [weight] = ons_kernel(data, weight_o, 0, 1, 1/8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = ons_kernel(data, weight_o, eta, beta, delta)

weight = ons_expert(data, weight_o, eta, beta, delta);

end