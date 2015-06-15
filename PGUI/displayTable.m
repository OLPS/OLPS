%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = displayTable( results )
 % Initial display
    cumReturns      = [results.benchmarks results.returns];
    dailyReturns    = [results.benchmarks_daily-1 results.returns_daily];    

    % Compute the statsand display the important numbers in table using the
    % library functions
    addpath('../GUI/lib');
    
    % Get final Values
    [r c] = size(cumReturns);
    results.finalValues = cumReturns(r,:);
    
    % Get the mean returnfor every day - This is a simple average
    results.meanReturns = mean(dailyReturns);
    
    % Get annualised returns
    denominator = 252/results.dataFrequency;
    Y = r/denominator;
    results.annualisedReturns = results.finalValues.^(1/Y)-1;
    
    % Get standard deviation- a measureof risk
    results.standardDeviation = std(dailyReturns);
    
    % Get annualised standard deviation
    results.annualisedStandardDeviation = results.standardDeviation * sqrt(denominator);
    
    % Get sharpe ratios
    results.sharpeRatios = sharpe(dailyReturns, results.finalValues,results.dataFrequency);
    
    % Get Sortino ratios
    results.sortinoRatios = sortino(dailyReturns, 0);
    
    % Get Value risks at level 5%
    results.valueAtRisks = var5(dailyReturns);
    
    % Get Maximum draw down
    results.mdds = maxDD_general(cumReturns);
    
    % Get Calmar ratios
    results.calmars = calmar(cumReturns, results.mdds, results.dataFrequency);
    
    
    % Fill up the tables
    
    
    tableData   = [results.finalValues; results.meanReturns; results.annualisedReturns; results.standardDeviation; results.annualisedStandardDeviation; results.sharpeRatios; results.calmars; results.sortinoRatios; results.valueAtRisks; results.mdds];
    
    if ~exist ('OCTAVE_VERSION', 'builtin');
        Market      = tableData(:,1);
        Uniform     = tableData(:,2);
        BestStock   = tableData(:,3);
        BCRP        = tableData(:,4);
        Algorithm   = tableData(:,5);
        report      = {'Final Value','Mean Return for every period','Annualised Return','Standard Deviation','Annualised Standard Deviation','Sharpe Ratio','Calmar Ratio','Sortino Ratio','Value at Risk','Maximum Draw Down'};
        % tableData   = table(Market,Uniform,BestStock,BCRP, Algorithm,
        % 'RowNames', report); % - works only in Matlab 2014a onwards
        
        finalDisplay = report';
        finalDisplay(2:end+1) = finalDisplay;
        finalDisplay{1} = '';

        finalDisplay{1,2} = 'Market';
        finalDisplay{1,3} = 'Uniform';
        finalDisplay{1,4} = 'BestStock';
        finalDisplay{1,5} = 'BCRP';
        finalDisplay{1,6} = 'Algorithm';
        
        
        for i = 1:1:10
            for j = 1:1:5
                finalDisplay{i+1,j+1} = tableData(i,j);
            end
        end
        
        disp('Performance of the Algorithm compared to baselines based on several metrics');    
        disp(finalDisplay);
    
    else
        tabFinal    = {'Sl. No.', 'Market', 'Uniform', 'BestStock', 'BCRP', 'Algorithm'};
        report      = {'Final Value','Mean Return for every period','Annualised Return','Standard Deviation','Annualised Standard Deviation','Sharpe Ratio','Calmar Ratio','Sortino Ratio','Value at Risk','Maximum Draw Down'};
%         for i = 2:1:11
%             tabFinal{i,1} = report{i-1};
%             for j = 2:1:6
%                 tabFinal{i,j} = tableData(i-1, j-1);
%             end
%         end
        disp('Performance of the Algorithm compared to baselines based on several metrics');    
        
        % Do the display of column titles
        fprintf('\t');
        for j = 1:1:5
            fprintf(char(tabFinal{j}));
            fprintf('\t\t');
        end
        fprintf('\n');
        id = (1:10)';
        tableData = [id tableData];
        disp(tableData);
        disp('Metrics:');
        for i = 1:1:10
            fprintf(num2str(i));
            fprintf('. ');
            fprintf(report{i});
            fprintf('\n');
        end
        
    rmpath('../GUI/lib');
end