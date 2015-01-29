function mddval = ra_mdd(data)
% Copyright by Li Bin, 2009
% maximum drawdown function for ps
nDays = length(data);
mddvec = zeros(nDays, 1);

for i = 1:nDays,
    mddvec(i, 1) = ra_dd(data(1:i));
end

mddval = max(mddvec(:));

end
