function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = up(fid, data, varargins, opts)
% This file is an entry for the up strategy.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%           = up_start(fid, data, varargins, opts)
% cum_ret: cumulative wealth achived at the end of a period.
% cumprod_ret: cumulative wealth achieved till the end each period.
% daily_ret: daily return achieved by a strategy.
% daily_portfolio: daily portfolios
%
% data: market sequence vectors
% fid: handle for write log file
% varargins: variable parameters
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%          = up_start(fid, data, {0}, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the parameters
tc = varargins{1};      % transaction cost fee rate

% Run the greedy algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = up_run(fid, data, tc, opts);

end