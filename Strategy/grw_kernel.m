function [weight] = grw_kernel(data, xi)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

weight = grw_expert(data, xi);

end