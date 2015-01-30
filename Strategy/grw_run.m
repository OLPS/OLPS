function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
    = grw_run(fid, data, N, sigma, tc, opts)
% This file is the run core for the EG strategy.
%
% function [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%           = eg_run(fid, data, tc, opts)
%
% cum_ret: cumulative wealth achived at the end of a period.
% cumprod_ret: cumulative wealth achieved till the end each period.
% daily_ret: daily return achieved by a strategy.
% daily_portfolio: daily portfolio, achieved by the strategy
%
% data: market sequence vectors
% fid: handle for write log file
% gamma: swtiching parameter
% tc: transaction fee rate
% opts: option parameter for behvaioral control
%
% Example: [cum_ret, cumprod_ret, daily_ret, daily_portfolio] ...
%          = grw_run(fid, data, 10, 0.00005, 0, opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[n, m] = size(data);

% Variables for return, start with uniform weight
cum_ret = 1;
cumprod_ret = ones(n, 1);
daily_ret = ones(n, 1);
day_weight = ones(m, 1)/m;  %#ok<*NASGU>
day_weight_o = zeros(m, 1);
daily_portfolio = zeros(n, m);

% print file head
fprintf(fid, '-------------------------------------\n');
fprintf(fid, 'Parameters [N:%f, sigma:%f, tc:%f]\n', N, sigma, tc);
fprintf(fid, 'day\t Daily Return\t Total return\n');

fprintf(1, '-------------------------------------\n');
if(~opts.quiet_mode)
    fprintf(1, 'Parameters [N:%f, sigma:%f, tc:%f]\n', N, sigma, tc);
    fprintf(1, 'day\t Daily Return\t Total return\n');
end

% choose normal vectors
xi = normrnd(1/m, sigma^2, N, m);
gamma  = zeros(size(xi));

options = optimset('largescale','off', 'display', 'off');

for t = 1:1:n,
    % Calculate t's portfolio at the beginning of t-th trading day
    [day_weight] = grw_kernel(data(1, :), xi);
    
    % projection
    C = eye(m, m); d = day_weight;
    A = []; b=[];
    Aeq = ones(m, 1)'; beq = 1;
    lb = zeros(m, 1); ub = ones(m, 1);
    day_weight = lsqlin(C, d, A, b, Aeq, beq, lb, ub, day_weight, options);
    if or((day_weight < 0.0001), (day_weight'*ones(m, 1)>1.00001))
        fprintf(1, 't=%d, sum(day_weight)=%d, pause', t, day_weight'*ones(m, 1));
        pause;
    end
    
    % Normalize the constraint, always useless
    day_weight = day_weight./sum(day_weight);
    
    % Cal t's return and total return
    daily_ret(t, 1) = (data(t, :)*day_weight)*(1-tc/2*sum(abs(day_weight-day_weight_o)));
    cum_ret = cum_ret * daily_ret(t, 1);
    cumprod_ret(t, 1) = cum_ret;
    
    % Adjust weight(t, :) for the transaction cost issue
    day_weight_o = day_weight.*data(t, :)'/daily_ret(t, 1);
    
    % Monte Carlo update
    k = 1;
    while k <= N,   % Checks the size of our new sample
        u = rand(1); % Choose u from \mu[0, 1]
        j = randi([1, N]);  % Choose j randomly from {1, ... , N}
        
        if (u <= exp(xi(j, :))./sum(exp(xi(j, :)))*data(t, :)'/(max(data(t, :))) )  % accept-reject condition
            gamma(k, :) = xi(j, :);  k = k+1;   % Accepts xi if the above condition holds
        end
    end
    
    % Portfolio Update step
    h = normrnd(0, sigma^2, N, m);   
    xi = gamma + h;
    
    % Debug information
    % Time consuming part, other way?
    fprintf(fid, '%d\t%f\t%f\n', t, daily_ret(t, 1), cumprod_ret(t, 1));
    if (~opts.quiet_mode)
        if (~mod(t, opts.display_interval)),
            fprintf(1, '%d\t%f\t%f\n', t, daily_ret(t, 1), cumprod_ret(t, 1));
        end
    end
end

% Debug Information
fprintf(fid, 'GRW(N:%d, sigma:%f, tc:%f), Final return: %f\n',...
    N, sigma, tc, cum_ret);
fprintf(fid, '-------------------------------------\n');
fprintf(1, 'GRW(N:%d, sigma:%f, tc:%f), Final return: %f\n',...
    N, sigma, tc, cum_ret);
fprintf(1, '-------------------------------------\n');

end