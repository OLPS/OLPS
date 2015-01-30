function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
    = cornu(fid, data, varargins, opts)
% This program starts the CORN-U algorithm
% CORN-U is a uniform combination (or buy and hold) of CORN experts
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ....
%           = cornu_start(fid, data, varargins, opts)
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
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%          = cornu_start(fid, data, {5, 1, 0.1, 0}, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the parameters
K  = varargins{1};
L  = varargins{2};
c  = varargins{3};
tc = varargins{4};      % transaction cost fee rate

% Run the CORNU simulation
[cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
    = cornu_run(fid, data, K, L, c, tc, opts); 

end