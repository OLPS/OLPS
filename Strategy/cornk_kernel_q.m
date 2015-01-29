function p=cornk_kernel_q(k, l, K, L, nc, exp_ret, ret_rho)
% Copyright by Li Bin, 2009
% probability distribution for ps kernel file

if (exp_ret(k, l) >= ret_rho)
    p = 1;
else
    p = 0;
end

end