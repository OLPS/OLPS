% Li Bin (libin@pmail.ntu.edu.sg)
% This file is an entry for the M0 strategy.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%           = m0_start(fid, data, varargins, opts)
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
%          = m0_start(fid, data, {0.5, 0}, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = m0_start(fid, data, varargins, opts)

% Extract the parameters
beta = varargins{1};    % 
tc = varargins{2};      % transaction cost fee rate

% Run the M0 algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = m0_run(fid, data, beta, tc, opts);

end