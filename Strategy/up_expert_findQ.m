function Q = up_expert_findQ(b, data, del0, delta)
% This program finds Q for KV02
%
% function Q = up_expert_findQ(b, data, del0, delta, N)
%
% Q: A modification of the random walk wealth distribution P
%
% b: portfolio
% data: market sequence
% del0, delta: parameters
%
% Example: Q = up_expert_findQ(b, data, del0, delta, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[~, N] = size(data);  % Number of stocks,Time period.

P = prod(data(:, :)*b);

Q = P*min(1, exp((b(N)-(2*del0))/(N*delta)));

end
