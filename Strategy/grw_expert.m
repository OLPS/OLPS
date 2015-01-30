function [weight] = grw_expert(data,  xi)
% This program generates portfolio for a specified parameter setting.
% GRW expert
%
% function [weight] = eg_expert(data, weight_o, eta)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% xi: randomly generated variable
%
% Example: [weight] = grw_expert(data, 0.05);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = grw_expert(data,  xi)

[T, ~]=size(xi);

xi_norm = grw_lambda(xi);

weight = xi_norm'*ones(T, 1);

end