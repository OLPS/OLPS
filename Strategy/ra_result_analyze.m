function [ra_ret] = ra_result_analyze(fid, data, cum_ret, cumsum_ret, daily_ret, opts)
% This program analyzes the backtest's results
%
% function [ra_ret] = ra_result_analyze(fid, data, cum_ret, cumsum_ret, daily_ret, opts)
%
% ra_ret: a number vector contains the analysis results.
%
% fid: a log file id.
% data: market sequence vectors.
% cum_ret: cumulative return at the end of the trading period.
% cumsum_ret: cumulative return until each period.
% daily_ret: portfolio period return for each period.
% opts: option parameter to control the program behavior.
%
% Example: ra_ret = ra_result_analyze(fid, data, cum_ret, cumsum_ret, daily_ret, opts)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors: Doyen Sahoo
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RET_RF = 1.000156;
NUM_TRADE = 252;

[n, m] = size(data); %#ok<NASGU>

%% Compute Market daily return
% opts_tmp.quiet_mode = 1; 
% opts_tmp.display_interval = 500;
% opts_tmp.log_mode = 0; 
% opts_tmp.mat_mode = 0;
% opts_tmp.analyze_mode = 0;

% [~, ~, market_daily_ret] = ubah_run(fid, data, 0, opts_tmp);
market_daily_ret = ones(n, 1);
day_weight = ones(m, 1)/m; 
for t = 1:1:n,
	day_weight = day_weight./sum(day_weight);
    market_daily_ret(t, 1) = (data(t, :)*day_weight);
	day_weight = day_weight.*data(t, :)'/daily_ret(t, 1);
end

win_ratio = sum(daily_ret(:, 1)>=market_daily_ret(:, 1))/n;

% Statistical t-Tests
market_mu = mean(market_daily_ret(:, 1))-1;
strategy_mu =  mean(daily_ret(:, 1))-1;

x = [ones(n, 1) market_daily_ret(:, 1)-RET_RF];
y = daily_ret(:, 1)-RET_RF;
a = x\y;
alpha = a(1);
beta = a(2);

strategy_se = std(y-x*a)/sqrt(n);
t_stat = alpha / strategy_se;
p_value = 1-tcdf(t_stat, n-1);

% Risk adjusted return: APY, standard deviation, and annualized Sharpe Ratio
apy = (cum_ret)^(1/round(n/NUM_TRADE))-1;
stdev = std(daily_ret(:, 1))*sqrt(NUM_TRADE);
sr = (apy - 0.04)/stdev;

% Risk adjusted return: DD, MDD and CR
ddval = ra_dd(cumsum_ret);
mddval = ra_mdd(cumsum_ret);
cr = apy/mddval;

%% Store all analyzed value.
ra_ret = [];
% Results for statistical t-test.
ra_ret(1, 1) = n;
ra_ret(2, 1) = strategy_mu;
ra_ret(3, 1) = market_mu;
ra_ret(4, 1) = win_ratio;
ra_ret(5, 1) = alpha;
ra_ret(6, 1) = beta;
ra_ret(7, 1) = t_stat;
ra_ret(8, 1) = p_value;

% Results for standard deviation of return and sharpe ratio.
ra_ret(9, 1) = apy;
ra_ret(10, 1) = stdev;
ra_ret(11, 1) = sr;

% Results for maximum drawdown analysis and calmar ratio.
ra_ret(12, 1) = ddval;
ra_ret(13, 1) = mddval;
ra_ret(14, 1) = cr;

%% Log the results
if (opts.log_mode)   
    fprintf(fid, 'Result Analysis.\n');
    fprintf(fid, '-------------------------------------\n');
    fprintf(fid, 'Statistical t-Test\n');
    fprintf(fid, 'Size: %d\nMER(Strategy): %.4f\nMER(Market):%.4f\nWinRatio:%.4f\nAlpha:%.4f\nBeta:%.4f\nt-statistics:%.4f\np-Value:%.4f\n', ...
        n, strategy_mu, market_mu, win_ratio, alpha, beta, t_stat, p_value);
    fprintf(fid, '-------------------------------------\n');
    
    fprintf(fid, 'Risk Adjusted Return\n');
    fprintf(fid, 'Volatility Risk analysis\n');
    fprintf(fid, 'APY: %.4f\nVolatility Risk: %.4f\nSharpe Ratio: %.4f\n',...
        apy, stdev, sr);
    
    fprintf(fid, 'Drawdown analysis\n');
    fprintf(fid, 'APY: %.4f\nDD: %.4f\nMDD: %.4f\nCR: %.4f\n', ...
        apy, ddval, mddval, cr);
    fprintf(fid, '-------------------------------------\n');
end

% Display the results
if (~opts.quiet_mode)
    fprintf(1, 'Result Analysis\n');
    fprintf(1, '-------------------------------------\n');
    fprintf(1, 'Statistical Test\n');
    fprintf(1, 'Size: %d\nMER(Strategy): %.4f\nMER(Market):%.4f\nWinRatio:%.4f\nAlpha:%.4f\nBeta:%.4f\nt-statistics:%.4f\np-Value:%.4f\n', ...
        n, strategy_mu, market_mu, win_ratio, alpha, beta, t_stat, p_value);
    fprintf(1, '-------------------------------------\n');
    
    fprintf(1, 'Risk Adjusted Return\n');
    fprintf(1, 'Volatility Risk analysis\n');
    fprintf(1, 'APY: %.4f\nVolatility Risk: %.4f\nSharpe Ratio: %.4f\n',...
        apy, stdev, sr);
    
    fprintf(1, 'Drawdown analysis\n');
    fprintf(1, 'APY: %.4f\nDD: %.4f\nMDD: %.4f\nCR: %.4f\n', ...
        apy, ddval, mddval, cr);
    fprintf(1, '-------------------------------------\n');
end
% Output ends

end

%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%
