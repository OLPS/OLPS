function mddval = ra_mdd(data)
% maximum drawdown function for ps
% 
% mddval = ra_mdd(data)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nDays = length(data);
mddvec = zeros(nDays, 1);

for i = 1:nDays,
    mddvec(i, 1) = ra_dd(data(1:i));
end

mddval = max(mddvec(:));

end
