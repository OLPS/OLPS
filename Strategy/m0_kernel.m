function [weight] = m0_kernel(data)
% Copyright by Li Bin, 2009
% Exponential Gradient for ps, kernel file
% Input
%     data    -- market historical prices
%     weight_o -- portfolio weight for last trading day
%
% Output
%     weight  -- weight column vector
%

weight = m0_expert(data);

end