% Bin Li (libin@pmail.ntu.edu.sg)
% This program starts the CORN algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ....
%           = corn_start(fid, data, varargins, opts)
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
%          = corn_start(fid, data, {0}, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = corn(fid, data, varargins, opts)

% Extract the parameters
w  = varargins{1};      % Window size 
c  = varargins{2};      % Correlation coefficient threshold
tc = varargins{3};      % transaction cost fee rate

% Run the CORN simulation
[cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = corn_run(fid, data, w, c, tc, opts); 

end