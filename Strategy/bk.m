% Bin Li (libin@pmail.ntu.edu.sg)
% This program starts the BK algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ....
%           = bk_start(fid, data, varargins, opts)
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
%          = bk_start(fid, data, {0}, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ....
    = bk(fid, data, varargins, opts)

% Extract the parameters
K  = varargins{1};
L  = varargins{2};
c  = varargins{3};
tc = varargins{4};      % transaction cost fee rate

% Call BK's run algorithm
[cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
    = bk_run(fid, data, K, L, c, tc, opts);

end