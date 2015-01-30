function [mu, sigma] = cwmr_var_expert(data, mu, sigma, phi, epsilon)
% This program generates portfolio for a specified parameter setting.
% CWMR-Var expert
%
% function [mu, sigma] = cwmr_var_expert(data, mu, sigma, phi, epsilon)
%
% weight: experts portfolio, used for next rebalance/combination
% mu: next portfolio mean
% sigma: next diagonal covariance matrix
%
% data: market sequence vectors
% mu: last portfolio mean
% sigma: last diagonal covariance matrix
% phi: confidence parameter
% epsilon: mean reversion threshold
%
% Example: [mu, sigma] = cwmr_var_expert(data, mu, sigma, phi, epsilon)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[T, N] = size(data);

% Step 4: Calculate the following parameters
x_bar = (ones(N, 1)'*sigma*data(T, :)')/(ones(N, 1)'*sigma*ones(N, 1));
M = data(T, :) * mu;
V = data(T, :) * sigma * data(T, :)';
W = data(T, :) * sigma * ones(N, 1);

% Step 5: Update the Portfolio distribution \lambda
a = 2*phi*V^2-2*phi*x_bar*V*W;
b = 2*phi*epsilon*V - 2*phi*V*M + V - x_bar*W;
c = epsilon-M-phi*V;

t1 = b; t2 = sqrt(b^2-4*a*c); t3 = 2*a;
if (a ~= 0) && (isreal(t2)) && (t2 > 0)
    gamma1 = (-t1+t2)/t3; gamma2 = (-t1-t2)/t3;
    lambda = max([gamma1 gamma2 0]);
elseif (a == 0) && (b ~= 0)
    gamma3 = -c/b;
    lambda = max([gamma3 0]);
else
    lambda = 0;
end  % end if

% Update mu and sigma
mu = mu - lambda*sigma*(data(T, :)'-x_bar*ones(N, 1));
sigma = (sigma^(-1)+2*lambda*phi*diag(data(T, :)).^(2))^(-1);

% Normalize mu and sigma
mu = simplex_projection(mu, 1);
sigma = sigma./sum(sigma(:))/N;

end