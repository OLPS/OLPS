function [weight] = pamr_expert(data, weight_o, eta)
% This program generates portfolio for a specified parameter setting.
% PAMR expert
%
% function [weight] = pamr_expert(data, weight_o, eta)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% weight_o: last portfolio
% eta: Lagarange Multiplier
%
% Example: [weight] = pamr_expert(data, weight_o, eta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[T, N]=size(data);

weight = weight_o - eta*(data(T, :)'-sum(data(T, :))/N);

% The routine simplex_projection() belongs to John Duchi
% We include his implementation, while the codes below provide a matlab
% implementation, which requires the matlab optimization toolbox.

weight = simplex_projection(weight, 1);

if or((weight < -0.00001+zeros(size(weight))), (weight'*ones(N, 1)>1.00001))
    fprintf(1, 'pamr_expert: t=%d, sum(weight)=%d, pause', t, weight'*ones(N, 1));
    pause;
end

%% projection % Matlab version
% Replaced using a projection algorithm 2011 June 17
%         C=eye(N, N); d=weight;
%         A=[]; b=[];
%         Aeq=ones(N, 1)'; beq = 1;
%         lb=zeros(N, 1); ub = ones(N, 1);
%         weight = lsqlin(C, d, A, b, Aeq, beq, lb, ub, weight, options);
%

end