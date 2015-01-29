function [ vars ] = var5( returns )
% Compute 5% value at risk
    [r c] = size(returns);
    sortedReturns = sort(returns);
    index = round(0.05*r);
    if index <= 0
        index = 1;
    end
    vars = -sortedReturns(index,:);
end

