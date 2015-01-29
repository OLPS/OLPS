function [ cum_ret, cumprod_ret, daily_ret, daily_portfolio] = template( fid, data, varargins, opts )
% This is a template for writing a portfolio selection algorithm

%% Please put the description of your algorithm here
% Name of Strategy:
% Author:
% Description:
% The sections labelled as "Static" of the file need not be changed
 
    %% Make changes to this section to construct your algorithm
    
    %% Read Parameters
    p1 = varargins{1};

    %% Initialize variables
    [r c] = size(data);
    b = ones(c,1)/c;
    returns = zeros(r,1);
    portfolio = ones(r,c)/c;
    
    %% Static
    progress = waitbar(0,'Executing Algorithm...');
    
    
    %% The looping over the entire dataset for backtesting
    % The algorithm looping over r time periods
    for t = 1:1:r
        
        %% Static
        % compute x ofthe optimization problem i.e. todaysRelative
        todaysRelative = data(t,:)';
        % Compute the returns of algorithm
        portfolio(t, :) = b;
        returns(t) = b'*(todaysRelative-1);
        
        %% Change this section to describe your strategy portfolio selection method
        
        % Use solver/algorithm to find new portfolio vector at end of time
        % period t
        
        
        %%  Static
        % Update Progress
        if mod(t, 50) == 0 
            waitbar((t/r));
        end
        
    end
    
    
    
    %% Static
    
    % Compute additional statistics (for quick individual run without GUI)
    % Can be deleted
    stats.finalValue = prod(returns+1);
    Y =r/252;
    stats.sharpe = ((stats.finalValue)^(1/Y) - 1.04)  / (std(returns)*sqrt(252));
    stats.averageInTopStock = mean(max(portfolio') );
    stats.averageInTop2Stocks = flipud(sort(portfolio'));
    stats.averageInTop2Stocks = mean(sum(stats.averageInTop2Stocks(1:2, :)));
    stats.variance = (std(returns)*sqrt(252));
    
    
    % Conversion of results to algorithm format
    % cum_ret, cumprod_ret, daily_ret, daily_portfolio
    daily_portfolio = portfolio;
    daily_ret = returns+ 1;
    cumprod_ret = cumprod(daily_ret);
    cum_ret = cumprod_ret(end);
    
    close(progress);
end
