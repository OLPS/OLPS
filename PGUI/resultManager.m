%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = resultManager(results)
%% The results analysis of the Algorithm Analyser can be seen here

    % r.returns_daily     = returns;
    % r.returns           = cumprod(returns_daily+1);
    % r.portfolio         = portfolio;
    % r.stats             = stats;
    % r.benchmarks        = benchmakrs;
    % r.benchmarks_daily  = benchmarks_daily;
    % r.chosenStrategy    = chosenStrategy;
    % r.dataFrequency     = dataFrequency;
    
    [results.r, results.c]  = size(results.portfolio);
 
    menuId = 6; % Result Manager for Algorithm Analyser
    displayMenu(menuId); 
    prompt = 'Please enter your choice (1-5):';
    choice = input(prompt);

    switch(choice),
        case 1,
            % Print table of results
            displayTable(results);
            resultManager(results);
            
        case 2,
            % Plot the graphs of returns (both cumulative return and
            % log(cumulative return) of all algorithms
            cumReturns      = [results.benchmarks results.returns];
            dailyReturns    = [(results.benchmarks_daily-1) results.returns];
            
            figure;
            plot(cumReturns);
            xlim([0 results.r+1]);
            legend('Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', results.chosenStrategy, 'Location', 'Best');
            grid on;
            title('Cumulative Returns of the Algorithms');
            xlabel('Time');
            ylabel('Portfolio Value');
            
            
            figure;
            semilogy(cumReturns);
            xlim([0 results.r+1]);
            legend('Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', results.chosenStrategy, 'Location', 'Best');
            grid on;
            title('LOG Cumulative Returns of the Algorithms');
            xlabel('Time');
            ylabel('Portfolio Value');
            
            resultManager(results);
            
        case 3,
            % Produce all the risk plots. Tell user to chaneg the window
            % size in the config if needed
            load ../GUI/config/config.mat
            disp('Generating all the Risk Plots');
            msg = 'windowSize = ';
            msg = strcat(msg, num2str(windowRisk));
            disp(msg);
            disp('(You can modify the window size by changing windowRisk variable in the config)');
            
            % Produce all risk plots based on windowRisk
            window = windowRisk;
            if isnan(window) || window < 2 
                errorMessage('Window size must be a number greater than or equal to 2');
            else
                window = round(window);
                
                % 1. Annualized Sharpe Ratio
                addpath('../GUI/lib');
                
                [r, c] = size(results.returns_daily);
                sharpeRatios = zeros(r,1);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    sharpeRatios(i) = sharpe(results.returns_daily(start:finish), results.returns(finish)/results.returns(start), results.dataFrequency);
                end
                figure;
                plot(sharpeRatios);
                xlim([0 r+1]);
                legend('Sharpe Ratio', 'Location', 'Best');
                title('Sharpe Ratio of the Algorithm');
                xlabel('Time');
                ylabel('Sharpe Ratio');
                
                % 2. Calmar Ratio
                calmarRatios = zeros(r,1);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    mdd = maxDD(results.returns(start:finish));
                    calmarRatios(i) = calmar(results.returns(start:finish), mdd, results.dataFrequency);
                end
                figure;
                plot(calmarRatios);
                xlim([0 r+1]);
                legend('Calmar Ratio', 'Location', 'Best');
                title('Calmar Ratio of the Algorithm');
                xlabel('Time');
                ylabel('Calmar Ratio');
                
                % 3. Sortino Ratio
                sortinos = zeros(r,1);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    sortinos(i) = sortino(results.returns_daily(start:finish),0);
                end
                
                figure;
                plot(sortinos);
                xlim([0 r+1]);
                legend('Sortino Ratio', 'Location', 'Best');
                title('Sortino Ratio of the Algorithm');
                xlabel('Time');
                ylabel('Sortino Ratio');
                
                % 4. Value at Risk
                vars = zeros(r,1);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    vars(i) = var5(results.returns_daily(start:finish));
                end
                
                figure;
                plot(vars);
                xlim([0 r+1]);
                legend('Value at Risk', 'Location', 'Best');
                title('Value at Risk of the Algorithm');
                xlabel('Time');
                ylabel('Value at Risk');
                
                % 5. Maximum Draw Down
                mdds = zeros(r,1);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    mdds(i) = maxDD(results.returns(start:finish));
                end
                
                figure;
                plot(mdds);
                xlim([0 r+1]);
                legend('Maximum Draw Down', 'Location', 'Best');
                title('Maximum Draw Down of the Algorithm');
                xlabel('Time');
                ylabel('Maximum Draw Down (%)');
                
                rmpath('../GUI/lib');
            end            
            resultManager(results);
            
        case 4,    
            % Portfolio allocation plots
            portfolio   = results.portfolio;
            expected    = mean(portfolio);
            deviation   = std(portfolio);

            errorbar(expected, deviation, 'xr');
            xlim([0 results.c+1]);
            
            title('Average Portfolio Allocation');
            xlabel('Assets');
            ylabel('Fraction of Portfolio');
            
            resultManager(results);
            
        case 5,
            disp('Exiting Result Manager --> to Algorithm Analyser');
            [ job ] = jobInit();
            algorithmAnalyserMenu( job );
            
        otherwise,
            disp('ERROR: Please enter a valid input');
            resultManager(results);
    end

end

function [ algorithmJob ] = jobInit()
% Construct an instance of an algorithm analyser job

    % Read configuration
    load ../GUI/config/config.mat;   
    algorithmJob.algorithmId    = 1;
    algorithmJob.datasetId      = 1;
    AL                          = char(algorithmList);
    algorithmJob.algorithm      = AL(algorithmJob.algorithmId,:);
    DL                          = char(dataList);
    algorithmJob.dataset        = DL(algorithmJob.datasetId,:);
    algorithmJob.parameters     = cell2mat(defaultParameters(algorithmJob.algorithmId,:));
end