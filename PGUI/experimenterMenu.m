%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ] = experimenterMenu( job )
    
    % The job must contain:
    % 1. Array of algorithm IDs
    % 2. Default parameters for each algorithm
    % 3. The dataset choice

    % Read configuration
    load ../GUI/config/config.mat;   
    
    menuId = 3; % Experimenter Menu
    displayMenu(menuId); % 
    
    prompt = 'Please enter your choice (1-5):';
    choice = input(prompt);
    
    switch(choice),
        case 1,
            % Select Algorithms
            job     = selectAlgorithms (job);
            experimenterMenu( job ); 
            
        case 2,
            % Set Parameters
            disp('The current job is:');
            displayExperimenterJob(job);
            prompt = 'Which Algorithm Parameters do you want to change: ';
            choice = input(prompt);
            [ parameters ] = selectParameters(job.algorithmId(choice));
            
            p = length(parameters);
            for i = 1:1:p
                job.parameters(choice,i) = num2cell(parameters(i));
            end
            experimenterMenu(job);
        
        case 3
            % Select dataset
            [ dataId ] = dataSelectMenu(dataList );
            if dataId ~= -1
                job.datasetId   = dataId;
                DL              = char(dataList);
                job.dataset     = DL(job.datasetId,:);
            end
            experimenterMenu( job );   

        case 4,
            % Look at current job set by the user   
            displayExperimenterJob(job);
            experimenterMenu( job);
           
        case 5,  
            % START EXECUTION
            fprintf('Executing Algorithms...\n');
            nAlgos  = length(job.algorithmId);
            
            % Load the configuration
            load ../GUI/config/config.mat;
            % Add the strategy library
            addpath('../GUI/lib');
            addpath('../Strategy');
            % Confirm the dataset
            load(strcat('../Data/', char(dataName(job.datasetId))));
            
            % Setting options
            opts.quiet_mode = 1; opts.display_interval = 500;
            opts.log_mode = 1; opts.mat_mode = 1;
            opts.analyze_mode = 1;
            opts.his = 0;
            opts.progress = 1;
            
            for i = 1:1:nAlgos
                % Construct input for the i-th algo, and execute
                
                msg = 'Running the ';
                msg = strcat(msg, num2str(i));
                msg = strcat(msg, '-th Algorithm ...');
                disp(msg);
                
                % Confirm the algorithm
                strategy_name = char(algorithmName(job.algorithmId(i))); 
                % Confirm the parameters
                inputs = (job.parameters(i,:));
                
                strategy_fun = [strategy_name '(1, data, inputs, opts)'];
                [stats(:, i), cumprod_ret(:,i), daily_ret(:,i), daily_portfolio{i}] = eval(strategy_fun);
                returns = daily_ret - 1;
                portfolio = daily_portfolio;
                chosenStrategy = algorithmList{job.algorithmId};
            end
            
            % Construct the results data structure
            r.daily_ret             = daily_ret-1;
            r.cum_ret               = cumprod(daily_ret);
            r.daily_portfolio       = daily_portfolio; 
            r.selectedAlgorithms    = job.algorithmId;
            r.dataFrequency         = dataFrequency(job.datasetId);
            displayTable2(r);
            resultManager2(r);
            
        case 6,
            disp('Exiting Experimenter --> to Home');
            homeMenu;
            
        otherwise,
            disp('ERROR: Please enter a valid input');
            experimenterMenu;
    end
end

%% Menu for Selecting Dataset
function [ dataId ] = dataSelectMenu(dataList )
% Display algorithm lsit, and ask user to select the method

    menuId = 5; % DataList
    displayMenu(menuId);    
    numberOfDatasets = length(dataList);
    
    prompt  = strcat('Please enter your choice of Dataset (1-', num2str(numberOfDatasets));
    prompt  = strcat(prompt, '):');
    choice  = input(prompt);
    
    if choice >= 1 && choice <= numberOfDatasets
        dataId  = choice;
        msg     = strcat('You have selected: ', dataList(dataId));
        fprintf('\n');
        disp(char(msg));
        disp('Returning back to Algorithm Analyser...');
    else  
        disp('ERROR: Please enter a valid input');
        dataId = dataSelectMenu( dataList );
    end
end

function [ job ] = selectAlgorithms( job )

    load ../GUI/config/config.mat;
    menuId = 4; % AlgorithmList
    displayMenu(menuId);    
    numberOfAlgorithms  = length(algorithmList);
    numberSelected      = length(job.algorithmId);
    disp('Currently Selected Algorithms:');
    disp(job.algorithmId);
    
    msg         = 'Please Enter the Strategy IDs that you want to compare (1:';
    msg         = strcat(msg, num2str(numberOfAlgorithms));
    msg         = strcat(msg, ')');
    msg         = strcat(msg,'\nEg. To compare Strategies 1, 3, 4, 5, type: [1, 3, 4, 5]\n');
    selected    = input(msg);
    
    job.algorithmId = sort(selected);
    job.algorithmId = unique(selected);
    job.parameters  = {};
    % Add parameters
    numberSelected = length(job.algorithmId);
    for i = 1:1:numberSelected
        job.parameters(i,:) = defaultParameters(job.algorithmId(i),:);
    end
end

function [ ] = displayExperimenterJob( job )

    load ../GUI/config/config.mat;
    fprintf('\n');
    fprintf('________________________________________');
    fprintf('\n\t\t\t CURRENT JOB \n');
    
    nAlgos = length(job.algorithmId);
    fprintf('Algorithms: \n');
    fprintf('______________\n');
    for i = 1:1:nAlgos
        id = job.algorithmId(i);
        msg = strcat(num2str(i), '.');
        msg = strcat(msg,algorithmList{id});
        fprintf(msg);
        fprintf('\n');
        displayParameters(job, i);
        fprintf('______________\n');
    end
    
    fprintf('\n');
    fprintf(strcat('Dataset: \t', char(dataList(job.datasetId))));
    fprintf('\n');
    
    fprintf('________________________________________');
    fprintf('\n');
end

function [ ] = displayParameters( job, index )
    load ../GUI/config/config.mat;
    
    names           = algorithmParameters(job.algorithmId(index),:);
    numParameters   = length(cell2mat((job.parameters(index,:))));
    
    for i = 1:1:numParameters
        line = char(names(i));
        line = strcat(line, '\t=\t');
        line = strcat(line, num2str(cell2mat(job.parameters(index,i))));
        line = strcat(line, '\n');
        fprintf(line);
    end 
end

function [ parameters ] = selectParameters(algoId)
% The interface for the user to input parameters for the algorithm
% currently selected.

    load ../GUI/config/config.mat;
    disp('________________________________________________________');
    disp('Please Enter the new values of parameters for Algorithm:');
    algo    = char(algorithmList(algoId));
    fprintf(strcat(strcat('Algorithm:\t',algo), '\n'));
    
    defaultParameters   = cell2mat(defaultParameters(algoId,:));
    numberOfParmeters   = length(defaultParameters);
    
    for i = 1:1:numberOfParmeters
        
        parameterName   = algorithmParameters(algoId, i);
        parameterName   = parameterName{1};
        
        msg = strcat(num2str(i), ')');
        msg = strcat(msg, parameterName);
        msg = strcat(msg, '(current value = ');
        msg = strcat(msg, num2str(defaultParameters(i)));
        msg = strcat(msg, '): ');
        
        parameters(i) = input(msg);
        
    end
    disp('________________________________________________________');
end