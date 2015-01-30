function [ simpleSharpe annualisedSharpe  ] = oldSharpe(varargin)
% This function accepts a vector of returns and computes the simple sharpe
% ratio for the given time period, and assumes that the returns are given
% in a daily format. 
% It computes 2 results 1) simple sharpe ratio 2) annualised sharpe ratio
% If the returns are already in an annual format

% Sharpe ratio: This code computes the sharpe ratio based on simple average
% multiplied by sqrt(number of days in a time period)
% simpleSharpe = mean(returns)/std(returns)
% annualised sharpe = simpleSharpe*sqrt(252); - for type 0
% Inputs:   returns - is a vector of returns (eg. 0.1 = 10%)
%           type = 0 for daily, 1 for monthly, 2 for annual; default = 0;
%           riskFreeReturn - is annualised risk free return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Doyen Sahoo
% Contributors: Steven Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Initialize the outputs
    simpleSharpe = NaN;
    annualisedSharpe = NaN;
    
    % Perform computations based on number of parameters passed
    if nargin == 0
        disp('Error in computing sharpe ratio: No parameters passed');
        return;
    end
    
    % Assign default values
    rfr = 0;
    type = 0;
    
    % Error handling for returns vector
    returns = varargin{1};
    [r c] = size(returns);
    if r == 1 && c == 1
        disp('Error in computing sharpe ratio: Returns vector has only one value');
        return;
    end
    
    if nargin > 1
        type = varargin{2};
    end
    if nargin > 2
        rfr = varargin{3};
    end
    
    
    % Now do the actual computation of the sharpe ratio   
    if type == 0 % daily return
        dailyRfr = rfr/252;
        averageReturns = mean(returns) - dailyRfr;
        risk = std(returns);
        simpleSharpe = averageReturns/risk;
        annualisedSharpe = simpleSharpe*sqrt(252);
    end
    
    if type == 1 % monthly returns
        monthlyRfr = rfr/12;
        averageReturns = mean(returns) - monthlyRfr;
        risk = std(returns);
        simpleSharpe = averageReturns/risk;
        annualisedSharpe = simpleSharpe*sqrt(12);
    end
    
    if type == 2 % annual returns
        averageReturns = mean(returns) - rfr;
        risk = std(returns);
        simpleSharpe = averageReturns/risk;
        annualisedSharpe = simpleSharpe;
    end

end