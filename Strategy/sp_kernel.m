function [weight] = sp_kernel(data, weight_o, gamma)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


weight = sp_expert(data, weight_o, gamma);

end