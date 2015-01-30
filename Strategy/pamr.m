function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = pamr(fid, data, varargins, opts)
% This program starts the PAMR algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ....
%           = pamr(fid, data, varargins, opts)
%
% cum_ret: a number representing the final cumulative wealth.
% cumprod_ret: cumulative return until each trading period
% daily_ret: individual returns for each trading period
% daily_portfolio: individual portfolio for each trading period
%
% data: market sequence vectors
% fid: handle for write log file
% varargins: variable parameters
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%          = pamr(fid, data, {0.5, 0}, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the parameters
epsilon = varargins{1};     % mean reversion threshold
tc = varargins{2};      % transaction cost fee rate

% Run the PAMR simulation
[cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = pamr_run(fid, data, epsilon, tc, opts);

end