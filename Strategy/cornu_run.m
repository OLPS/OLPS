% Bin Li (libin@pmail.ntu.edu.sg)
% This program simulates the CORN-U algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%    = cornu_run(fid, data, K, L, c, tc, opts)
%
% cum_ret: a number representing the final cumulative wealth.
% cumprod_ret: cumulative return until each trading period
% daily_ret: individual returns for each trading period
% daily_portfolio: individual portfolio for each trading period
% exp_ret: experts' return
%
% data: market sequence vectors
% fid: handle for write log file
% K: maximum window size
% L: splits into L parts, in each K, useless in CORN-U, L=1
% c: correlation coefficient threshold
% tc: transaction cost rate parameter
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%            = cornk_run(fid, data, K, L, c, tc, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
    = cornu_run(fid, data, K, L, c, tc, opts)

[n, m] = size(data);

% Variables for return, start with uniform weight
% cumprod_ret = 1;
% daily_ret = 1;
% weight = ones(nStocks, 1)/nStocks;

cum_ret = 1;
cumprod_ret = ones(n, 1);
daily_ret = ones(n, 1);
day_weight = ones(m, 1)/m;  
day_weight_o = zeros(m, 1);
daily_portfolio = zeros(n, m);

% Variables for expert
exp_ret = ones(K, L);
exp_w = ones(K*L, m)/m;

% print file head
fprintf(fid, '-------------------------------------\n');
if (~opts.quiet_mode)
    fprintf(fid, 'Parameters [K=%d, L=%d, c=%f, tc=%f\n]', K, L, c, tc);
    fprintf(fid, 'day\t Daily Return\t Total return\n');
end
if (opts.progress)
	progress = waitbar(0,'Executing Algorithm...');
end
for t = 1:1:n,
    % Calculate t's portfolio
    if (t >=2)
        [day_weight, exp_w] ...
            = cornu_kernel(data(1:t-1, :), K, L, c, exp_ret, exp_w);
    end
    
    % Normalize the constraint
    day_weight = day_weight./sum(day_weight);
    daily_portfolio(t, :) = day_weight';
    
    % Cal t's return and total return
    daily_ret(t, 1) = (data(t, :)*day_weight)*(1-tc/2*sum(abs(day_weight-day_weight_o)));
    cum_ret = cum_ret * daily_ret(t, 1);
    cumprod_ret(t, 1) = cum_ret;
    
    day_weight_o = day_weight.*data(t, :)'/daily_ret(t, 1);
    
    % Cal t's experts return
    exp_ret(:, 1) = exp_ret(:, 1).*(data(t, :)*exp_w(:, :)')';

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
fprintf(fid, 'CORN Uniform(K:%d, L:%d, c:%.2f, tc:%.4f), Final return: %.2f\n', ...
    K, L, c, tc, cum_ret);

fprintf(fid, 'CORN Uniform, Experts return:\n');
fprintf(fid, '%f\t', exp_ret);
fprintf(fid, '\n');
fprintf(fid, '-------------------------------------\n');

fprintf(1, 'CORN Uniform(K:%d, L:%d, c:%.2f, tc:%.4f), Final return: %.2f\n', ...
    K, L, c, tc, cum_ret);
if (~opts.quiet_mode)
    fprintf(1, 'CORN Uniform, Experts return:\n');
    fprintf(1, '%f\t', exp_ret);
    fprintf(1, '\n');
end
fprintf(fid, '-------------------------------------\n');
    if (opts.progress)	
		close(progress);
	end
end