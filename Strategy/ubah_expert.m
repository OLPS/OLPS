% Li Bin (libin@pmail.ntu.edu.sg)
% This file is the expert for the market strategy, which generate a
% portfolio for a specified parameter.
%
% function [weight] = market_expert(data, weight_o)
% weight: generate portfolio for day t+1
% data: market sequence until day t
% weight_o: last (t^th) portfolio 
%
% Example: [weight] ...
%          = market_run(data(1:t), weight_o);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [weight] = ubah_expert(data, weight_o)

% simply output last portfolio, for buy and hold market.
weight = weight_o;

end
%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%