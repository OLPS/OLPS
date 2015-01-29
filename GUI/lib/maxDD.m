function [ MDD ] = maxDD( NAV )
% Computes max draw down based on net asset values provided
% Wiki algo
%
% MDD = 0
% peak = -99999
% for i = 1 to N step 1
%   if (NAV[i] > peak) 
%     peak = NAV[i]
%   endif
%   DD[i] = 100.0 * (peak - NAV[i]) / peak
%   if (DD[i] > MDD)
%     MDD = DD[i]
%   endif
% endfor

    [r c] = size(NAV);
    DD = zeros(r, c);
    MDD = 0;
    peak = 0;
    for i = 1:1:r
        if NAV(i) > peak
            peak = NAV(i);
        end
        
        DD(i) = (peak - NAV(i)) / peak;
        if (DD(i) > MDD)
            MDD = DD(i);
        end
    end
end

