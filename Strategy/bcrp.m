% Li Bin (libin@pmail.ntu.edu.sg)
% This file is an entry for the bcrp strategy.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%           = bcrp_start(fid, data, varargins, opts)
% cum_ret: cumulative wealth achived at the end of a period.
% cumprod_ret: cumulative wealth achieved till the end each period.
% daily_ret: daily return achieved by a strategy.
%
% data: market sequence vectors
% fid: handle for write log file
% varargins: variable parameters
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%          = bcrp_start(fid, data, {0}, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = bcrp(fid, data, varargins, opts)

% Extract the parameters
tc = varargins{1};      % transaction cost fee rate

% Run the bcrp simulation
[cum_ret, cumprod_ret, daily_ret, daily_portfolio]...
    = bcrp_run(fid, data, tc, opts);

end