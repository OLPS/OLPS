function [cum_ret, cumprod_ret, daily_ret, daily_portfolio]...
    = cwmr_stdev(fid, data, varargins, opts)
% This program starts the CWMR-Stdev algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ....
%           = cwmr_stdev(fid, data, varargins, opts)
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
%          = cwmr_stdev(fid, data, {2, 0.5, 0}, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the parameters
phi = varargins{1};
epsilon = varargins{2};
tc = varargins{3};      % transaction cost fee rate

% Run the CWMR-Stdev Simulation
[cum_ret, cumprod_ret, daily_ret, daily_portfolio]...
    = cwmr_stdev_run(fid, data, phi, epsilon, tc, opts);

end