function [ sharpe  ] = sharpe(returns, finalValues, frequency)
% Accepts a set of numbers, computes annualised sharpe ratio for each
% column, assuming risk free interest rate to be 4% pa, and 252 trading
% days in a year

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Doyen Sahoo
% Contributors: Steven Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    den = 252/frequency;
    [r c] = size(returns);
    Y = r/den;
    annualised_return = finalValues .^ (1/Y) - 1.04;
    
    stdev = std(returns);
    annualised_stdev = stdev * sqrt(den);
    
    sharpe = annualised_return./annualised_stdev;

end