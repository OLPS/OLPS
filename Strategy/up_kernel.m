% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the UP strategy on data
%
% function [weight] = up_kernel(data, weight_o)
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
%
% Example: [weight] = up_kernel(data, weight_o)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = up_kernel(data, weight_o)

weight = up_expert(data, weight_o);

end