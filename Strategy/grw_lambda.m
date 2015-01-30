function [xi_norm] = grw_lambda(xi)
% This program normalizes a random xi
%
% function [xi_norm] = grw_lambda(xi)
%
% xi_norm: normalized xi
%
% xi; randomly generated xi
%
% Example: [xi_norm] = grw_lambda(xi)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xi_norm] = grw_lambda(xi)

[~, N] = size(xi);
alpha = 0.001*N;

xi_sum = exp(xi)*ones(N, N);
xi_norm = xi./xi_sum;
xi_norm = (1-alpha)*xi_norm + alpha;

end