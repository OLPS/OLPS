function [ mdds ] = maxDD_general( navs )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Doyen Sahoo
% Contributors: Steven Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    [r c] = size(navs);
    mdds = zeros(1,c);
    for i = 1:1:c
        mdds(i) = maxDD(navs(:,i));
    end

end

