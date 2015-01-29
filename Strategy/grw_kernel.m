% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the GRW strategy
%
% function [weight] = grw_kernel(data, xi)
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% xi: randomly generated variable
%
% Example: [weight] = grw_kernel(data, 0.05)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = grw_kernel(data, xi)

weight = grw_expert(data, xi);

end