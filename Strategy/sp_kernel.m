% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the SP strategy on data
%
% function [weight] = sp_kernel(data, weight_o, gamma)
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
% gamma: switching parameter
%
% Example: [weight] = sp_kernel(data, weight_o, 0.25)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = sp_kernel(data, weight_o, gamma)

weight = sp_expert(data, weight_o, gamma);

end