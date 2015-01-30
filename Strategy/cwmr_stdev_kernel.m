function [weight, mu, sigma] ...
    = cwmr_stdev_kernel(data, mu, sigma, phi, epsilon)
% This program output the final portfolio the CWMR-Stdev algorithm
% CWMR has only one experts, thus, we go expert directly.
% If we want buy and hold, combine the experts here.
% This version is the deterministic version, while stochastic version can
% change one line of the code, as indicated below.
%
% function [weight, mu, sigma] = cwmr_stdev_kernel(data, mu, sigma, phi, epsilon)
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
%          = cwmr_stdev_kernel(data, mu, sigma, phi, epsilon)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[T, N] = size(data);

[mu, sigma] = cwmr_stdev_expert(data,  mu, sigma, phi, epsilon);

% This following line can be changed, to generate random varialbe
weight = mu./sum(mu);    

% Bound checker
if or((weight < -0.00001+zeros(size(weight))), (weight'*ones(N, 1)>1.00001))
    fprintf(1, 'Bound Check: t=%d, sum(weight)=%d, pause', T, weight'*ones(N, 1));
    pause;
end

end