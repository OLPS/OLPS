% Li Bin (libin@pmail.ntu.edu.sg)
% This file is an entry for the BAH(Anticor) strategy, the second best
% variants of anticor
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%           = anticor(fid, data, varargins, opts)
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
%          = anticor(fid, data, {30, 0}, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = anticor(fid, data, varargins, opts)

% Extract the parameters
W  = varargins{1};      % Maximum window size, or the number of experts
tc = varargins{2};      % transaction cost fee rate

% Run the anticor_run algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio]...
    = anticor_run(fid, data, W, tc, opts);

end