function [weight] = eg_kernel(data, weight_o, eta)
% This program output the final portfolio the EG strategy on data
%
% function [weight] = eg_kernel(data, weight_o, eta)
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
% eta: learning rate
%
% Example: [weight] = eg_kernel(data, weight_o, 0.05)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

weight = eg_expert(data, weight_o, eta);

end