% Bin Li (libin@pmail.ntu.edu.sg)
% This program generates portfolio for a specified parameter setting.
% CWMR-Stdev expert
%
% function [mu, sigma] = cwmr_stdev_expert(data, mu, sigma, phi, epsilon)
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
% Example: [mu, sigma] = cwmr_stdev_expert(data, mu, sigma, phi, epsilon)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mu, sigma] = cwmr_stdev_expert(data, mu, sigma, phi, epsilon)

[T, N] = size(data);

%% Step 4: Calculate the following variables
x_bar = (ones(N, 1)'*sigma*data(T, :)')/(ones(N, 1)'*sigma*ones(N, 1));
M = data(T, :) * mu;
V = data(T, :) * sigma * data(T, :)';
W = data(T, :) * sigma * ones(N, 1);

%% Step 5: Update the portfolio distribution
% Calculate the quadratic variables (a, b, c)
a = (V - x_bar*W + (phi^2)*V/2)^2 - (phi^4)*(V^2)/4;
b = 2*(epsilon - M)*(V-x_bar*W+(phi^2)*V/2);
c = (epsilon-M)^2-(phi^2)*V;

% Calculate two roots and get the Lagrangian Multiplier
t1 = b; t2 = sqrt(b^2-4*a*c); t3 = 2*a;
if (a ~= 0) && (isreal(t2)) && (t2 > 0)
    gamma1 = (-t1+t2)/(t3);  gamma2 = (-t1-t2)/(t3);
    lambda = max([gamma1 gamma2 0]);
elseif (a == 0) && (b ~= 0)
    gamma3 = -c/b;
    lambda = max([gamma3 0]);
else
    lambda = 0;
end  % end if

% Update the distribution element \mu and \Sigma
mu = mu - lambda*sigma*(data(T, :)'-x_bar*ones(N, 1));   % update of mu

sqrtu = (-lambda*phi*V+sqrt((lambda^2)*(V^2)*(phi^2)+4*V))/2;
if (sqrtu ~= 0)
    sigma = (sigma^(-1) + lambda * phi / sqrtu * diag(data(T, :)).^2)^(-1);
end

if (det(sigma) <= eps) % In case of singular, add each element an minimum eps.
    sigma = sigma+eps*diag(ones(N, 1));
end

%% Step 6: Normalize \mu and \Sigma
mu = simplex_projection(mu, 1);
sigma = sigma./sum(sigma(:))/N;

end