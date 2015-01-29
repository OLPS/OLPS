% Bin Li (libin@pmail.ntu.edu.sg)
% This program simulates the CWMR-Var algorithm
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%    = cwmr_var_run(fid, data, phi, epsilon, tc, opts)
%
% cum_ret: a number representing the final cumulative wealth.
% cumprod_ret: cumulative return until each trading period
% daily_ret: individual returns for each trading period
% daily_portfolio: individual portfolio for each trading period
%
% data: market sequence vectors
% fid: handle for write log file
% phi: confidence parameter
% epsilon: mean reversion threshold
% tc: transaction cost rate parameter
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio, exp_ret] ...
%            = cwmr_var_run(fid, data, phi, epsilon, tc, opts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] = ...
    cwmr_var_run(fid, data, phi, epsilon, tc, opts)

[n, m]=size(data); 

% Variables for return, start with uniform weight
cum_ret = 1;
cumprod_ret = ones(n, 1);
daily_ret = ones(n, 1);
day_weight = ones(m, 1)/m;  %#ok<*NASGU>
day_weight_o = zeros(m, 1);
daily_portfolio = zeros(n, m);

% print file head
fprintf(fid, '-------------------------------------\n');
fprintf(fid, 'Parameters [phi:%f, epsilon:%f, tc:%f]\n', phi, epsilon, tc);
fprintf(fid, 'day\t Daily Return\t Total return\n');

fprintf(1, '-------------------------------------\n');
if(~opts.quiet_mode)
    fprintf(1, 'Parameters [tc:%f]\n', tc);
    fprintf(1, 'day\t Daily Return\t Total return\n');
end

%% Initialization
alpha = 1; lambda = 0;
mu = alpha*ones(m, 1)/m;
sigma = alpha* eye(m)/(m^2);

%% Online 
if (opts.progress)
	progress = waitbar(0,'Executing Algorithm...');
end
for t = 1:1:n,
    % Calculate t's portfolio at the beginning of t-th trading day
    if (t >= 2)
         [day_weight, mu, sigma] ...
             = cwmr_var_kernel(data(1:t-1, :), mu, sigma, phi, epsilon);
    end
    
    day_weight = day_weight./sum(day_weight);
    daily_portfolio(t, :) = day_weight';
    
    % Step 3: Cal t's return and total return
    daily_ret(t, 1) = (data(t, :)*day_weight)*(1-tc/2*sum(abs(day_weight-day_weight_o)));
    cum_ret = cum_ret * daily_ret(t, 1);
    cumprod_ret(t, 1) = cum_ret;
    
    % Adjust weight(t, :) for the transaction cost issue
    day_weight_o = day_weight.*data(t, :)'/daily_ret(t, 1);
    
    % Time consuming part, other way?
    fprintf(fid, '%d\t%f\t%f\n', t, daily_ret(t, 1), cumprod_ret(t, 1));
    if (~opts.quiet_mode)
        if (~mod(t, opts.display_interval)),
            fprintf(1, '%d\t%f\t%f\n', t, daily_ret(t, 1), cumprod_ret(t, 1));
        end
    end
    if (opts.progress)
		if mod(t, 50) == 0 
			waitbar((t/n));
		end
	end
end

% Debug Information
if(opts.log_mode)
    fprintf(fid, 'CWMR-Var(%.2f, %.2f, %.4f), Final return: %.2f\n', ...
        phi, epsilon, tc, cum_ret);
    fprintf(fid, '-------------------------------------\n');
end

fprintf(1, 'CWMR(%.2f, %.2f, %.4f), Final return: %.2f\n', ...
    phi, epsilon, tc, cum_ret);
fprintf(1, '-------------------------------------\n');

	if (opts.progress)	
		close(progress);
	end

end