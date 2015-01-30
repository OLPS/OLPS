function ddval = ra_dd(ret_data)
% This program analyzes the drawdown for a strategy.
%
% function ddval = ra_dd(ret_data)
%
% ddval: drawdown analysis for the return data, ret_data
%
% ret_data: cumulative return for each period
%
% Example: ddval = ra_dd(data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nDays = length(ret_data);
ddval = (max(ret_data)-ret_data(nDays))/max(ret_data);
end

%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%