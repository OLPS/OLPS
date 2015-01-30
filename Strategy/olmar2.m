function [cum_ret, cumprod_ret, daily_ret, daily_portfolio]...
    = olmar2(fid, data, varargins, opts)
% This program starts the OLMAR-2 algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ....
%           = olmar2_start(fid, data, varargins, opts)
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
%          = olmar2_start(fid, data, {10, 0.5, 0}, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the parameters
epsilon = varargins{1}; % reversion parameter \epsilon
alpha = varargins{2};       % Alpha size
tc = varargins{3};      % transaction cost fee rate

% Run the OLMAR-2 algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio]...
    = olmar2_run(fid, data, epsilon, alpha, tc, opts);

end