%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [  ] = removeStrategy( strategyId, configFile )
% Delete a dataset from a specified configuration file
    load(configFile);
    algorithmList(strategyId)           = [];
    algorithmName(strategyId)           = [];
    algorithmParameters(strategyId,:)   = [];
    defaultParameters(strategyId,:)     = [];
    save(configFile, 'algorithmList', 'algorithmName', 'algorithmParameters', 'dataFrequency', 'dataList', 'dataName', 'defaultParameters', 'windowRisk');
    disp('Strategy removed from config. Set it as the active configuration and restart the toolbox.');
end