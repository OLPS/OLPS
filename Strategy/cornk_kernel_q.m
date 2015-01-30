function p = cornk_kernel_q(k, l, K, L, nc, exp_ret, ret_rho)
% Probability distribution for ps kernel file
% 
% p = cornk_kernel_q(k, l, K, L, nc, exp_ret, ret_rho)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (exp_ret(k, l) >= ret_rho)
    p = 1;
else
    p = 0;
end

end