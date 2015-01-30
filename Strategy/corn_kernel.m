function [weight] = corn_kernel(data, w, c)
% This program output the final portfolio the CORN strategy on data
% This version has one expert, thus straightforwardly go expert.
%
% function [weight] = corn_kernel(data, w, c)
%
% weight: final portfolio, used for next rebalance
%
% data: market sequence vectors
% w: window size
% c: correlation coefficient threshold
%
% Example: [weight] = corn_kernel(data, w, c);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi 
% Contributors:
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

weight = corn_expert(data, w, c);

% if (size(weight, 1) == 1),
%     weight=weight';
% end

end