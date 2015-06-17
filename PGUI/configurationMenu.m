%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ] = configurationMenu( )
    
    % This will be used to add and delete algorithms to the configuration
    
    menuId = 8; % Configuration Menu
    displayMenu(menuId);
    prompt = 'Please enter your choice (1-6):';
    choice = input(prompt);
    switch(choice),
        case 1,
            % Adding a Strategy
            cd ../GUI/config/;
            disp('Instructions:');
            disp('1. Create new strategy, and save it in folder /Strategy');
            disp('2. If file name is ''newStrategy.m'', create and appropritely populate ''newStrategy_config.m'' in the same folder');
            disp('3. An example of this type of files is shown in ''template.m'' and ''template_config.m''');
            newStrategyFileName = input('Enter name of file that you want to add (e.g. ''newStrategy''):');
            configFile          = input('Enter name of configuration you want to change (e.g. ''config_myconfig''):');
            addStrategy( newStrategyFileName, configFile );
            cd ../../PGUI/;
            configurationMenu;
        case 2,
            % Removing a Strategy
            prompt = ('Name of config file do you want to update (e.g. ''config_myconfig''):');
            configFile = input(prompt);
            cd ../GUI/config/;
            load(configFile);
            
            % Display all Strategies
            disp('Strategies in current config:');
            nAlgo = length(algorithmList);
            for i = 1:1:nAlgo
                msg = strcat(num2str(i), '.');
                msg = strcat(msg, algorithmList{i});
                fprintf(msg);
                fprintf('\n');
            end
            
            prompt = ('Enter ID of Strategy to be removed:');
            strategyId = input(prompt);
            removeStrategy( strategyId, configFile );
            
            cd ../../PGUI/;
            configurationMenu;
        case 3,
            % Adding a dataset
            cd ../GUI/config/;
            disp('First, save new dataset in folder /Data, in the correct format.');
            prompt              = 'Enter name of file (e.g. ''newData''):';
            dataFileName        = input(prompt);
            prompt              = 'Enter Data Description (e.g. '' New Data - 1st Jan, 2014 to 1st Jan, 2015):';
            dataDescriptionName = input(prompt);
            prompt              = 'Enter frequency (e.g. 1 for daily data):';
            newDataFrequency    = input(prompt);
            prompt              = 'Enter name of config file do you want to update (e.g. ''config_myconfig''):';
            configFile          = input(prompt);
            addData( dataFileName, dataDescriptionName, newDataFrequency, configFile );
            cd ../../PGUI/;
            configurationMenu;
        case 4,
            % Removing a dataset
            cd ../GUI/config/;
            prompt = ('Name of config file do you want to update (e.g. ''config_myconfig''):');
            configFile = input(prompt);
            load(configFile);
            
            % Display all data sets
            disp('Datasets in current config:');
            nData = length(dataList);
            for i = 1:1:nData
                msg = strcat(num2str(i), '.');
                msg = strcat(msg, dataList{i});
                fprintf(msg);
                fprintf('\n');
            end
            
            prompt = ('Enter ID of Data to be removed:');
            dataId = input(prompt);
            removeData( dataId, configFile );
            cd ../../PGUI/;
            configurationMenu;
        case 5,
            prompt = ('Name of config file do you want to make active (e.g. ''config_myconfig''):');
            configFile = input(prompt);
            cd ../GUI/config/;
            load(configFile);
            save('config', 'algorithmList', 'algorithmName', 'algorithmParameters', 'dataFrequency', 'dataList', 'dataName', 'defaultParameters', 'windowRisk');
            disp('Update Configuration. Restart toolbox to read the updated configuration');
            cd ../../PGUI/;
            configurationMenu;
        case 6, 
            disp('Exiting Configuration Manager --> to Home');
            homeMenu;
        otherwise,
            disp('ERROR: Please enter a valid input');
            configurationMenu;
    end
end