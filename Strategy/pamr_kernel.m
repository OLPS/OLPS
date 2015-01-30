function [weight] = pamr_kernel(data, weight_o, eta)
% This program output the final portfolio the PAMR algorithm
% PAMR has only one experts, thus, we go expert directly.
% If we want buy and hold, combine the experts here.
%
% function [weight] = pamr_kernel(data, weight_o, eta)
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% weight_o: last portfolio
% eta: Lagarange Multiplier
%
% Example: [weight] = pamr_kernel(data, weight_o, eta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


weight = pamr_expert(data, weight_o, eta);

end
