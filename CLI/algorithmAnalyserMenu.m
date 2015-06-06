function [ ] = algorithmAnalyserMenu( job )
    % Display Home Menu Screen
    
    % Read configuration
    load ../GUI/config/config.mat;   
    menuId = 2; % Algorithm Analyser Menu
    displayMenu(menuId); 
    
    prompt = 'Please enter your choice (1-7):';
    choice = input(prompt);
    switch(choice),
        case 1,
            %algorithmListMenu;
            algoId = algorithmSelectMenu( algorithmList ); 
            if algoId ~= -1
                % Update the job.algorithmId
                job.algorithmId     = algoId;
                job.algorithm       = algorithmList{algoId};
                job.parameters      = cell2mat(defaultParameters(job.algorithmId,:));
            end
            algorithmAnalyserMenu( job );
        case 2,
            % Set the parameters for the selected algorithm
            job.parameters  = selectParameters(job.algorithmId);
            algorithmAnalyserMenu( job );
        case 3,
            % data select menu
            [ dataId ] = dataSelectMenu(dataList );
            if dataId ~= -1
                job.datasetId   = dataId;
                DL              = char(dataList);
                job.dataset     = DL(job.datasetId,:);
            end
            algorithmAnalyserMenu( job );
        case 4,  
            % Preliminary visualization of the dataset
            % Essentially produce plots of the 3 graphs (like GUI)
            displayPreliminaryAnalysis(job.datasetId, 1); % Secodn parameter is plot check
            algorithmAnalyserMenu( job);
            
        case 5, 
            % Look at current job set by the user      
            fprintf('\n');
            fprintf('________________________________________');
            fprintf('\n\t\t\t CURRENT JOB \n');
            fprintf(strcat('Algorithm: \t', job.algorithm));
            fprintf('\n');
            fprintf(strcat('Dataset: \t', job.dataset));
            fprintf('\n');
            displayParameters(job);
            fprintf('________________________________________');
            fprintf('\n');
            disp('Returning back to Algorithm Analyser...');
            algorithmAnalyserMenu( job);
            
        case 6,
            % Get the inputs from "job" and the "parameters"
            % Using functions from other directories - the library
            load ../GUI/config/config.mat;
            addpath('../GUI/lib');
            addpath('../Strategy');
            
            % Confirm the algorithm
            strategy_name = char(algorithmName(job.algorithmId)); 
            
            % Confirm the dataset
            load(strcat('../Data/', char(dataName(job.datasetId))));
            
            % Confirm the parameters
            inputs = num2cell(job.parameters);
            
            % Define the options
            opts.quiet_mode = 1; opts.display_interval = 500;
            opts.log_mode = 1; opts.mat_mode = 1;
            opts.analyze_mode = 1;
            opts.his = 0;
            opts.progress = 1;
            
            % Final Execution
            strategy_fun = [strategy_name '(1, data, inputs, opts)'];
            [stats, cumprod_ret, daily_ret, daily_portfolio] = eval(strategy_fun);
            returns = daily_ret - 1;
            portfolio = daily_portfolio;
            chosenStrategy = algorithmList{job.algorithmId};
            
            % Construct a results data structure, and pass to results
            % manager - stored in variable called 'r'
            r.returns           = returns;
            r.portfolio         = portfolio;
            r.stats             = stats;
            plotCheck = 0;
            datasetId = job.datasetId;
            [benchmarks, benchmarks_daily] = displayPreliminaryAnalysis(datasetId, plotCheck);
            r.benchmarks        = benchmarks;
            r.benchmarks_daily  = benchmarks_daily;
            r.chosenStrategy    = chosenStrategy;
            r.dataFrequency     = dataFrequency(job.datasetId);
            resultManager(r);
        case 7,
            disp('Exiting Algorithm Analyser --> to Home');
            homeMenu;
        otherwise,
            disp('ERROR: Please enter a valid input');
            algorithmAnalyserMenu( job);
    end
end



%% Display parameters helper function
function [ ] = displayParameters( job )
    load ../GUI/config/config.mat;
    names           = algorithmParameters(job.algorithmId,:);
    numParameters   = length(job.parameters);
    
    disp('Parameters - ');    
    for i = 1:1:numParameters
        line = char(names(i));
        line = strcat(line, '\t=\t');
        line = strcat(line, num2str(job.parameters(i)));
        line = strcat(line, '\n');
        fprintf(line);
    end    
end


%% Menu for selecting Algorithm
function [ algoId ] = algorithmSelectMenu( algorithmList )
% Display algorithm lsit, and ask user to select the method

    menuId = 4; % AlgorithmList
    displayMenu(menuId);    
    numberOfAlgorithms = length(algorithmList);
    
    prompt  = strcat('Please enter your choice of algorithm (1-', num2str(numberOfAlgorithms));
    prompt  = strcat(prompt, '):');
    choice  = input(prompt);
    
    if choice >= 1 && choice <= numberOfAlgorithms
        algoId  = choice;
        msg     = strcat('You have selected: ', algorithmList(algoId));
        fprintf('\n');
        disp(char(msg));
        disp('Returning back to Algorithm Analyser...');
    else  
        disp('ERROR: Please enter a valid input');
        algoId = algorithmSelectMenu( algorithmList );
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
        dataId = algorithmSelectMenu( dataList );
    end
end


%% Preliminary Analysis
function [benchmarks, benchmarks_daily] = displayPreliminaryAnalysis(datasetId, plotCheck)
% Plot the 3 graphs
    addpath('../GUI/lib');
    addpath('../Strategy');
    
    load ../GUI/config/config.mat;
    
    dataName    = dataName(datasetId);
    dataName    = dataName{1};
    dataset     = load( fullfile('../Data', dataName) );
    
    opts.quiet_mode = 1; opts.display_interval = 500;
    opts.log_mode = 1; opts.mat_mode = 1;
    opts.analyze_mode = 1; opts.progress = 0;
    opts.his = 0;
    
    cumprodData = cumprod(dataset.data);
    
    
    % The 4 basic algorithms - market b&h, uniform, best stock, worst stock
    [r c] = size(dataset.data);
    
    % Market
    market = zeros(r,1);
    market_daily = zeros(r,1);
    initialValue = dataset.data(1,:);
    for i = 1:1:r
        finalValue = cumprodData(i,:);
        change = finalValue./initialValue;
        market(i) = mean(change);
    end
    
    market_daily(1) = 1;
    for i = 2:1:r
        market_daily(i) = market(i)/market(i-1);
    end
    
    % Uniform
    uniform_daily = ((mean(dataset.data,2 )));
    uniform = cumprod(uniform_daily);
    
    
    indexBest = 1; best = -1;
    for i = 1:1:c
        if cumprodData(r,i) > best
            indexBest = i;
            best = cumprodData(r,i);
        end
    end
    
    % Best
    best_daily = dataset.data(:,indexBest);
    best = cumprod(best_daily); 
    
    % Performing BCRP
    opts.quiet_mode = 1; opts.display_interval = 500;
    opts.log_mode = 1; opts.mat_mode = 1;
    opts.analyze_mode = 1;
    opts.his = 0;
    addpath('../Strategy');
    strategy_fun = ['bcrp' '(1, dataset.data, 0, opts)'];
    tc{1} = 0;
    [stats cumprod_ret daily_ret, daily_portfolio] = bcrp(1, dataset.data, tc, opts);
    rmpath('../Strategy');
    bcrp_ret = cumprod_ret;
    bcrp_daily = daily_ret;
    
    % Now computing the performance of every stock with mean and standard
    % deviation of returns
    expected = (mean(dataset.data) - 1)*252;
    deviation = std(dataset.data)*sqrt(252);
     
    % Plotting the 3 graphs
    benchmarks          = [market uniform best bcrp_ret];
    benchmarks_daily    = [market_daily uniform_daily best_daily bcrp_daily];
    expected            =  expected;
    deviation           = deviation;
    allStocks           = cumprodData;
    
    if (plotCheck)
        figure; plot(benchmarks); title('Basic Benchmarks');
        legend('Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP' ,'Location', 'Best');
        figure; errorbar(expected, deviation, 'xr'); title('Returns Distribution of Each Stock');
        figure; plot(allStocks); title('Individual Asset Return Curve'); 
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