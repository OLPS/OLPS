% Bin Li (libin@pmail.ntu.edu.sg)
% This program analyzes the drawdown for a strategy.
%
% function ddval = ra_dd(ret_data)
% ddval: drawdown analysis for the return data, ret_data
%
% ret_data: cumulative return for each period
%
% Example: ddval = ra_dd(data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ddval = ra_dd(ret_data)
nDays = length(ret_data);
ddval = (max(ret_data)-ret_data(nDays))/max(ret_data);
end

%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%