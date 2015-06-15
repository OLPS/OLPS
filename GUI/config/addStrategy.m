%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ] = addStrategy( newStrategyFileName, configFile )
% Adding a strategy to the configuration so that it can be read by the OLPS
% toolbox
   
    load(configFile);
    
    % In this config file - update 4 things
    % 1. algorithmList
    % 2. algorithmName
    % 3. algorithmParameters
    % 4. defaultParameters
    
    cd ../../Strategy
    config_filename = strcat(newStrategyFileName, '_config.m');
    fid = fopen(config_filename);
    
    tline = fgets(fid);
    while(ischar(tline))
        if tline(1) ~= '%'
            algoName   = strtrim(tline);
            tline = fgets(fid);
            nParameters     = str2num(tline);
            for i = 1:1:nParameters
                tline = fgets(fid);
                paraName{i} = strtrim(tline);
                tline = fgets(fid);
                paraValue{i} = str2double(tline);
            end
        end
        tline = fgets(fid);
    end
    
    % Implement all updates
    index                 = length(algorithmList)+1;
    algorithmName{index,1}  = newStrategyFileName;
    algorithmList{index,1}  = algoName;
    for i = 1:1:nParameters
        algorithmParameters{index,i}   = paraName{i};
        defaultParameters{index,i}     = paraValue{i}; 
    end
    
    % Save the config.
    
    cd ../GUI/config/
    save(configFile, 'algorithmList', 'algorithmName', 'algorithmParameters', 'dataFrequency', 'dataList', 'dataName', 'defaultParameters', 'windowRisk');
    
    disp('Strategy Added to config. It can now be read by the toolbox. Set it as the active configuration and restart the toolbox.');

end

