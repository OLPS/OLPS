% Bin Li (libin@pmail.ntu.edu.sg)
% This program output the final portfolio the CWMR-Var algorithm
% CWMR has only one experts, thus, we go expert directly.
% If we want buy and hold, combine the experts here.
% This version is the deterministic version, while stochastic version can
% change one line of the code, as indicated below.
%
% function [weight, mu, sigma] = cwmr_var_kernel(data, mu, sigma, phi, epsilon)
%
% weight: final portfolio, used for next rebalance
% mu: next portfolio mean
% sigma: next diagonal covariance matrix
%
% data: market sequence vectors
% mu: last portfolio mean
% sigma: last diagonal covariance matrix
% phi: confidence parameter
% epsilon: mean reversion threshold
%
% Example: [weight, mu, sigma] ...
%          = cwmr_var_kernel(data, mu, sigma, phi, epsilon)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight, mu, sigma] ...
    = cwmr_var_kernel(data, mu, sigma, phi, epsilon)

[T, N] = size(data);

[mu, sigma] = cwmr_var_expert(data,  mu, sigma, phi, epsilon);

% This following line can be changed, to generate the deterministic version
weight=mu./sum(mu);

if or((weight < -0.00001+zeros(size(weight))), (weight'*ones(N, 1)>1.00001))
    fprintf(1, 't=%d, sum(day_weight)=%d, pause', T, weight'*ones(N, 1));
    pause;
end

end