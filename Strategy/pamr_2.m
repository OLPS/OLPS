function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = pamr_2(fid, data, varargins, opts)
% This program simulates the PAMR algorithm.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%    = pamr_run(fid, data, K, L, c, tc, opts)
%
% cum_ret: a number representing the final cumulative wealth.
% cumprod_ret: cumulative return until each trading period
% daily_ret: individual returns for each trading period
% daily_portfolio: individual portfolio for each trading period
%
% data: market sequence vectors
% fid: handle for write log file
% epsilon: mean reversion threshold
% C: aggressive parameter
% tc: transaction cost rate parameter
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%            = pamr_run(fid, data, K, L, c, tc, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the parameters
epsilon =varargins{1};
C = varargins{2};
tc = varargins{3};      % transaction cost fee rate

% Run the greedy algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = pamr_2_run(fid, data, epsilon,C,tc, opts);

end
