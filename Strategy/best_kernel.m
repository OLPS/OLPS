function [weight] = best_kernel(data, weight_o)
% Copyright by Li Bin, 2009
% Market strategy for PS
% Input
%     data    -- market historical prices
%     weight_o -- portfolio weight for last trading day
%
% Output
%     weight  -- weight column vector
%

weight = best_expert(data, weight_o);

end