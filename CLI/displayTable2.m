%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = displayTable2( results )
 % Initial display
    cumReturns      = [results.cum_ret];
    dailyReturns    = [results.daily_ret];    

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
    
    load ../GUI/config/config.mat;
    algos = algorithmName(results.selectedAlgorithms);
    algTable = '';
    for i = 1:1:c
        statement = cell2mat(algos(i));
        algTable = strcat(algTable, statement);
        algTable = strcat(algTable, ',');
        statement = strcat(statement, '=');
        statement = strcat(statement, 'tableData(:,');
        statement = strcat(statement, num2str(i));
        statement = strcat(statement, ');');
        eval(statement);
    end
    
    
    report      = {'Final Value','Mean Return for every period','Annualised Return','Standard Deviation','Annualised Standard Deviation','Sharpe Ratio','Calmar Ratio','Sortino Ratio','Value at Risk','Maximum Draw Down'};
    statement   = 'table(';
    statement   = strcat(statement, algTable);
    statement   = strcat(statement, ' ''RowNames'', report);');
    
    
    
    disp('Performance of the Algorithm compared to baselines based on several metrics');  
    if ~exist ('OCTAVE_VERSION', 'builtin');
        %tableData   = table(Market,Uniform,BestStock,BCRP, Algorithm, 'RowNames', report);
        tableData = eval(statement);
        disp(tableData);
    else
        % Do the display of column titles
        fprintf('\t Sl. No. \t');
        for j = 1:1:5
            fprintf(char(algos(j)));
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
    end
     
    rmpath('../GUI/lib');
end