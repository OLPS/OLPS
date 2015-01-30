function [weight] = best_kernel(data, weight_o)
% Market strategy for PS
%
% [weight] = best_kernel(data, weight_o)
%
% Input
%     data    -- market historical prices
%     weight_o -- portfolio weight for last trading day
%
% Output
%     weight  -- weight column vector
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


weight = best_expert(data, weight_o);

end