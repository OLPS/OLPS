% Bin Li (libin@pmail.ntu.edu.sg)
% This program starts the OLMAR-1 algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ....
%           = olmar1_start(fid, data, varargins, opts)
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
%          = olmar1_start(fid, data, {10, 5, 0}, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = olmar1(fid, data, varargins, opts)

% Extract the parameters
epsilon = varargins{1}; % reversion parameter \epsilon
W = varargins{2};       % Window size
tc = varargins{3};      % transaction cost fee rate

% Run the OLMAR-1 algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio]...
    = olmar1_run(fid, data, epsilon, W, tc, opts);

end