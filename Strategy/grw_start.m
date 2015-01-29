% Li Bin (libin@pmail.ntu.edu.sg)
% This file is an entry for the EG strategy.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%            = grw_start(fid, data, varargins, opts)
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
%          = grw_start(fid, data, {0.00005, 0}, opts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = grw_start(fid, data, varargins, opts)

% Extract the parameters
sigma =varargins{1};    % Switching parameter
tc = varargins{2};      % transaction cost fee rate

% Run the grw algorithm multiple runs
N=[10 100 200];

fw = ones(3, 1);

for i = 1:3,
    [fw(i, 1)] = grw_run(fid, data, N(i), sigma, tc, opts);
end

A=[ones(1, 3); 1./N; 1./(N.^2)]';
beta = A\fw;

cum_ret = beta(1);

fprintf(1, 'cum_ret:%f\n', cum_ret);

% multiple times, ignore
cumprod_ret = 0;
daily_ret = 0;
daily_portfolio = 0; 

end