function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
    = bnn(fid, data, varargins, opts)
% This program starts the BNN algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ....
%           = bnn_start(fid, data, varargins, opts)
%
% cum_ret: a number representing the final cumulative wealth.
% cumprod_ret: cumulative return until each trading period
% daily_ret: individual returns for each trading period
% daily_portfolio: individual portfolio for each trading period
% exp_ret: individual experts return
%
% data: market sequence vectors
% fid: handle for write log file
% varargins: variable parameters
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%          = bnn_start(fid, data, {0}, opts);

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
tc = varargins{3};      % transaction cost fee rate
% quiet_mode = varargins{4};

% Run the BNN algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
    = bnn_run(fid, data, K, L, tc, opts);

end