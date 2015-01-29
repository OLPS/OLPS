% Bin Li (libin@pmail.ntu.edu.sg)
% This program simulates the BK strategy on data
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%    = corn_run(fid, data, w, c, tc, opts)
%
% cum_ret: a number representing the final cumulative wealth.
% cumprod_ret: cumulative return until each trading period
% daily_ret: individual returns for each trading period
% daily_portfolio: individual portfolio for each trading period
% exp_ret: experts' return
%
% data: market sequence vectors
% fid: handle for write log file
% w: window size
% c: correlation coefficient threshold
% tc: transaction cost rate parameter
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%            = corn_run(fid, data, w, c, tc, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = corn_run(fid, data, w, c, tc, opts)

%[T, N]=size(data);
[n, m] = size(data);

% Variables for return, start with uniform weight
% cumprod_ret = 1;
% daily_ret = 1;
% weight = ones(nStocks, 1)/nStocks;

cum_ret = 1;
cumprod_ret = ones(n, 1);
daily_ret = ones(n, 1);
day_weight = ones(m, 1)/m;  %#ok<*NASGU>
day_weight_o = zeros(m, 1);
daily_portfolio = zeros(n, m);

% print file head
fprintf(fid, '-------------------------------------\n');
if (~opts.quiet_mode)
    fprintf(fid, 'Parameters [w=%d, c=%f, tc=%f\n]', w, c, tc);
    fprintf(fid, 'day\t Daily Return\t Total return\n');
end

for t = 1:1:n,
    % Calculate t's portfolio
    if (t >=2)
        [day_weight] = corn_kernel(data(1:t-1, :), w, c);
    end
    
    % Normalize the constraint
    day_weight = day_weight./sum(day_weight);
    daily_portfolio(t, :) = day_weight';
    
    % Cal t's return and total return
    daily_ret(t, 1) = (data(t, :)*day_weight)*(1-tc/2*sum(abs(day_weight-day_weight_o)));
    cum_ret = cum_ret * daily_ret(t, 1);
    cumprod_ret(t, 1) = cum_ret;
    
    day_weight_o = day_weight.*data(t, :)'/daily_ret(t, 1);
    
    % Debug information
    fprintf(fid, '%d\t%f\t%f\n', t, daily_ret(t, 1), cum_ret);
    if (~opts.quiet_mode)
        if (~mod(t, opts.display_interval)),
            fprintf(1, '%d\t%f\t%f\n', t, daily_ret(t, 1), cum_ret);
        end
    end
end

% Debug Information
fprintf(fid, 'CORN(w:%d, c:%.2f, tc:%.4f), Final return: %.2f\n', ...
    w, c, tc, cum_ret);
fprintf(fid, '-------------------------------------\n');

fprintf(1, 'CORN(w:%d, c:%.2f, tc:%.4f), Final return: %.2f\n', ...
    w, c, tc, cum_ret);
fprintf(fid, '-------------------------------------\n');
end