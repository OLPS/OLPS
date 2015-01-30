function [weight] = m0_kernel(data)
% Exponential Gradient for ps, kernel file
%
% [weight] = m0_kernel(data)
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

weight = m0_expert(data);

end