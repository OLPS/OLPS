function [weight] = ubah_expert(data, weight_o)
% This file is the expert for the market strategy, which generate a
% portfolio for a specified parameter.
%
% function [weight] = market_expert(data, weight_o)
%
% weight: generate portfolio for day t+1
% data: market sequence until day t
% weight_o: last (t^th) portfolio 
%
% Example: [weight] = market_run(data(1:t), weight_o);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% simply output last portfolio, for buy and hold market.
weight = weight_o;

end
