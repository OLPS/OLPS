function [ vars ] = var5( returns )
% Compute 5% value at risk

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Doyen Sahoo
% Contributors: Steven Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [r c] = size(returns);
    sortedReturns = sort(returns);
    index = round(0.05*r);
    if index <= 0
        index = 1;
    end
    vars = -sortedReturns(index,:);
end

