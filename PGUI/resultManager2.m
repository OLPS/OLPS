%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = resultManager2( results )
% Results analysis for experimenter

    % r.daily_ret             = daily_ret-1;
    % r.cum_ret               = cumprod(daily_ret);
    % r.daily_portfolio       = daily_portfolio; 
    % r.selectedAlgorithms    = job.algorithmId;
    % r.dataFrequency         = dataFrequency(job.datasetId);
    
    [results.r, results.c]  = size(results.daily_portfolio{1});
    load ../GUI/config/config.mat;
    algos   = algorithmList(results.selectedAlgorithms);
    
    menuId = 7; % Result Manager for Experimenter
    displayMenu(menuId); 
    prompt = 'Please enter your choice (1-5):';
    choice = input(prompt);
    
    switch(choice),
        case 1,
            % Print table of results
            displayTable2(results);
            resultManager2(results);
            
        case 2,
            % Plot the graphs of returns (both cumulative return and
            % log(cumulative return) of all algorithms
            cumReturns      = results.cum_ret;
            
            % Cumulative Returns
            figure;
            plot(cumReturns);
            xlim([0 results.r+1]);
            legend(algos, 'Location', 'Best');
            grid on;
            title('Cumulative Returns of the Algorithms');
            xlabel('Time');
            ylabel('Portfolio Value');
            
            % Log cumulative Returns
            figure;
            semilogy(cumReturns);
            xlim([0 results.r+1]);
            legend(algos, 'Location', 'Best');
            grid on;
            title('LOG Cumulative Returns of the Algorithms');
            xlabel('Time');
            ylabel('Portfolio Value');
            
            resultManager2(results);
        
        case 3,
            % Display bar plot of daily returns
            prompt  = 'Enter start of time period: ';
            start   = input(prompt);
            prompt  = 'Enter end of time period: ';
            finish   = input(prompt);
            
            [r, c] = size(results.daily_ret);
            if isnan(start) || isnan(finish) || finish < start || start < 1
                disp('Detected error in values of START and END. Returning to Result Manager.');
            else
                finish = min(finish,r);
                figure;
                bar(results.daily_ret(start:finish,:));
                xlim([0 finish-start+2]);
                legend(algos, 'Location', 'Best');
            end
            
            resultManager2(results);
            
        case 4,
            % Produce all the risk plots. Tell user to change the window
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
                
                [r, c] = size(results.daily_ret);
                sharpeRatios = zeros(r,c);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    sharpeRatios(i,:) = sharpe(results.daily_ret(start:finish,:), results.cum_ret(finish,:)./results.cum_ret(start,:), results.dataFrequency);
                end
                figure;
                plot(sharpeRatios);
                xlim([0 r+1]);
                legend(algos, 'Location', 'Best');
                title('Sharpe Ratio of the Algorithm');
                xlabel('Time');
                ylabel('Sharpe Ratio');
                
                % 2. Calmar Ratio
                calmarRatios = zeros(r,c);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    mdd = maxDD_general(results.cum_ret(start:finish,:));
                    calmarRatios(i,:) = calmar(results.cum_ret(start:finish,:), mdd, results.dataFrequency);
                end
                figure;
                plot(calmarRatios);
                xlim([0 r+1]);
                legend(algos, 'Location', 'Best');
                title('Calmar Ratio of the Algorithm');
                xlabel('Time');
                ylabel('Calmar Ratio');
                
                % 3. Sortino Ratio
                sortinos = zeros(r,c);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    sortinos(i,:) = sortino(results.daily_ret(start:finish,:),0);
                end
                
                figure;
                plot(sortinos);
                xlim([0 r+1]);
                legend(algos, 'Location', 'Best');
                title('Sortino Ratio of the Algorithm');
                xlabel('Time');
                ylabel('Sortino Ratio');
                
                % 4. Value at Risk
                vars = zeros(r,c);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    vars(i,:) = var5(results.daily_ret(start:finish,:));
                end
                
                figure;
                plot(vars);
                xlim([0 r+1]);
                legend(algos, 'Location', 'Best');
                title('Value at Risk of the Algorithm');
                xlabel('Time');
                ylabel('Value at Risk');
                
                % 5. Maximum Draw Down
                mdds = zeros(r,c);
                for i = 50:1:r
                    start = max(i-window+1, 1);
                    finish = i;
                    mdds(i,:) = maxDD_general(results.cum_ret(start:finish,:));
                end
                
                figure;
                plot(mdds);
                xlim([0 r+1]);
                legend(algos, 'Location', 'Best');
                title('Maximum Draw Down of the Algorithm');
                xlabel('Time');
                ylabel('Maximum Draw Down (%)');
                
                rmpath('../GUI/lib');
            end
            
            resultManager2(results);
            
        case 5,    
            % Portfolio allocation plots
            
             % Number of algorithms 
            [tmp, n] = size(results.daily_portfolio);
            for i = 1:1:n
                portfolio = results.daily_portfolio{i};
                expected(:,i) = mean(portfolio)';
                deviation(:,i) = std(portfolio)';
            end
            
            [r, c] = size(portfolio);
            
            errorbar(expected, deviation,'x');
            xlim([0 c+1]);
            title('Average Portfolio Allocation');
            xlabel('Assets');
            ylabel('Fraction of Portfolio');
            legend(algos, 'Location', 'Best');
            grid on;
            
            resultManager2(results);
            
        case 6,
            disp('Exiting Result Manager --> to Experimenter');
            [ job ] = jobInit();
            experimenterMenu( job );
            
        otherwise,
            disp('ERROR: Please enter a valid input');
            resultManager2(results);
    end

end

function [] = displayTable( results )
    disp('stub in place - TODO');
end

function [ experimenterJob ] = jobInit()
% Construct an instance of an algorithm analyser job

    % Read configuration
    load ../GUI/config/config.mat;   
    experimenterJob.algorithmId    = 1;
    experimenterJob.datasetId      = 1;
    experimenterJob.parameters     = defaultParameters(experimenterJob.algorithmId,:);
end