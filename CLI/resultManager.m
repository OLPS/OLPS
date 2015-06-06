function [] = resultManager(results)
%% The results analysis of the Algorithm Analyser can be seen here

    % r.returns           = returns;
    % r.portfolio         = portfolio;
    % r.stats             = stats;
    % r.benchmarks        = benchmakrs;
    % r.benchmarks_daily  = benchmarks_daily;
    % r.chosenStrategy    = chosenStrategy;
    % r.dataFrequency     = dataFrequency;
    
    [results.r, results.c] = size(results.portfolio);
 
    menuId = 6; % Result Manager for Algorithm Analyser
    displayMenu(menuId); 
    prompt = 'Please enter your choice (1-5):';
    choice = input(prompt);

    switch(choice),
        case 1,
            % Print table of results
            % TODO
            disp('Under Construction :) ');
            resultManager(results);
            
        case 2,
            % Plot the graphs of returns (both cumulative return and
            % log(cumulative return) of all algorithms
            returns_daily   = results.returns;
            results.returns = cumprod(returns_daily+1);
            cumReturns      = [results.benchmarks results.returns];
            dailyReturns    = [(results.benchmarks_daily-1) results.returns];
            
            figure;
            plot(cumReturns);
            xlim([0 results.r+1]);
            legend('Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', results.chosenStrategy, 'Location', 'Best');
            grid on;
            title('Cumulative Returns of the Algorithms');
            
            
            figure;
            semilogy(cumReturns);
            xlim([0 results.r+1]);
            legend('Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', results.chosenStrategy, 'Location', 'Best');
            grid on;
            title('LOG Cumulative Returns of the Algorithms');
            
            resultManager(results);
            
        case 3,
            % Produce all the risk plots. Tell user to chaneg the window
            % size in the config if needed
            
            resultManager(results);
            
        case 4,    
            % Portfolio allocation plots
            
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