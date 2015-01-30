function p = bk_kernel_q(k, l, K, L)
% This program generates probability for each experts
% The defaulty value in BK is uniform, thus, p is straightforward.
% In reality, this can be much more complex
%
% function p = bk_kernel_q(k, l, K, L)
%
% p: vector of weights for individual expert.
%
% k, l: specific parameters to tune the probability distribution.
% K, L: maximum values of k, l, respectively.
%
% Example: p = bk_kernel_q(k, l, K, L);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = 1/(K*L+1);

end