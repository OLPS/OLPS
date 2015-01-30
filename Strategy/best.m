function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = best(fid, data, varargins, opts)
% This file is an entry for the best stock strategy.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%           = best_start(fid, data, varargins, opts)
% cum_ret: cumulative wealth achived at the end of a period.
% cumprod_ret: cumulative wealth achieved till the end each period.
% daily_ret: daily return achieved by a strategy.
% daily_portfolio: daily portfolio
%
% data: market sequence vectors
% fid: handle for write log file
% varargins: variable parameters
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%           = best_start(fid, data, varargins, opts)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the parameters
tc = varargins{1};      % transaction cost fee rate

% Run the best stock algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = best_run(fid, data, tc, opts);

end