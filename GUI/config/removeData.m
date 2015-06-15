%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [  ] = removeData( dataId, configFile )
% Delete a dataset from a specified configuration file
    load(configFile);
    dataList(dataId)        = [];
    dataFrequency(dataId)   = [];
    dataName(dataId)        = [];
    save(configFile, 'algorithmList', 'algorithmName', 'algorithmParameters', 'dataFrequency', 'dataList', 'dataName', 'defaultParameters', 'windowRisk');
    disp('Dataset removed from config. Set it as the active configuration and restart the toolbox.');
end