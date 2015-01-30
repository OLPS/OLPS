function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
    = anticor_run(fid, data, W, tc, opts)
% This file is the run core for the BAH(Anticor) strategy.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%           = anticor_run(fid, data, W, tc, opts)

% cum_ret: cumulative wealth achived at the end of a period.
% cumprod_ret: cumulative wealth achieved till the end each period.
% daily_ret: daily return achieved by a strategy.
% daily_portfolio: daily portfolio, achieved by the strategy
% exp_ret: experts' returns in the first fold
%
% data: market sequence vectors
% fid: handle for write log file
% W: maximum window size
% tc: transaction fee rate
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%          = anticor_run(fid, data, 30, 0, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% [T, N]=size(data);
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

% Variables for expert
exp_ret = ones(W-1, 1);
exp_w = ones(W-1, m)/m;

% print file head
fprintf(fid, '-------------------------------------\n');
if (~opts.quiet_mode)
    fprintf(fid, 'Parameters [W=%d, tc=%f\n]', W, tc);
    fprintf(fid, 'day\t Daily Return\t Total return\n');
end
if (opts.progress)
	progress = waitbar(0,'Executing Algorithm...');
end
for t = 1:1:n,
    % Calculate t's portfolio
    if (t >= 2)
        [day_weight, exp_w] ...
            = anticor_kernel(data(1:t-1, :), W, exp_ret, exp_w);
    end
    
    % Normalize the constraint
    day_weight = day_weight./sum(day_weight);
    daily_portfolio(t, :) = day_weight';
    
    % Cal t's return and total return
    daily_ret(t, 1) = (data(t, :)*day_weight)*(1-tc/2*sum(abs(day_weight-day_weight_o)));
    cum_ret = cum_ret * daily_ret(t, 1);
    cumprod_ret(t, 1) = cum_ret;
    
    % Normalize the portfolio
    day_weight_o = day_weight.*data(t, :)'/daily_ret(t, 1);
    
    % Cal t's experts return
    for k=2:W,
        exp_ret(k-1, 1) = exp_ret(k-1, 1)*data(t, :)*exp_w(k-1, :)';
    end;
    exp_ret(:, 1) = exp_ret(:, 1)/sum(exp_ret(:, 1));
    
    % Debug information
    fprintf(fid, '%d\t%f\t%f\n', t, daily_ret(t, 1), cum_ret);
    if (~opts.quiet_mode)
        if (~mod(t, opts.display_interval)),
            fprintf(1, '%d\t%f\t%f\n', t, daily_ret(t, 1), cum_ret);
        end
    end
    if (opts.progress)
		if mod(t, 50) == 0 
			waitbar((t/n));
		end
	end
end

% Debug Information
fprintf(fid, 'Anticor(W:%d, tc:%.4f), Final return: %.2f\n', ...
    W, tc, cum_ret);
fprintf(fid, '-------------------------------------\n');

fprintf(1, 'Anticor(W:%d, tc:%.4f), Final return: %.2f\n', ...
    W, tc, cum_ret);
fprintf(fid, '-------------------------------------\n');
if (opts.progress)	
    close(progress);
end
end