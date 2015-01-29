% Manager: 
% This program universally calls different on-line portfolio selection strategies and datasets
%
% function [cum_ret, cumprod_ret, daily_ret, ra_ret, run_time]...
%          = manager(strategy_name, dataset_name, varargins, opts)
% cum_ret: a number representing the final cumulative wealth.
% cumprod_ret: cumulative return until each trading period
% daily_ret: individual returns for each trading period
% ra_ret:  result analysis, output risk-adjusted return and other
% run_time: computational time for a algorithm on a dataset
%
% strategy_name: the string of a strategy.
% dataset_name: the string of a dataset.
% varargins: parameter array, depends on the algorithms
% opts: a variable to control the behavior of back testing. Described as
% follows.
%
% Option parameters:
%     opts.quiet_mode = 0/1;    display debug info[Y/N];
%     opts.display_interval = 500; display info time interval
%     opts.log_record = 0/1;    record the .log file[N/Y]
%     opts.mat_record = 0/1;    record the .mat file[N/Y]
%     opts.analyze_mode = 0/1;  analyze the algorithm? [N/Y]
%
% Example: [cum_ret, cumprod_ret, daily_ret, ra_ret, run_time] ...
%          = manager('market', 'nyse_o', {0}, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cum_ret, cumprod_ret, daily_ret, ra_ret, run_time]...
    = manager(strategy_name, dataset_name, varargins, opts) 

%% Loading the Dataset stringed dataset_name
if (~opts.quiet_mode)
    fprintf(1, 'Running strategy %s on dataset %s\nLoading dataset %s.\n', strategy_name, dataset_name, dataset_name);
end
load(sprintf('../Data/%s.mat', dataset_name));
if (~opts.quiet_mode)
    fprintf(1, 'Finish loading dataset %s\nThe size of the dataset is %dx%d.\n', dataset_name, size(data, 1), size(data, 2));
end

%% Logging stage, format the log file name
if (opts.log_mode)
    dt = datestr(now, 'yyyy-mmdd-HH-MM-SS');
    file_name = ['../Log/Log/' strategy_name '-' dataset_name '-' dt '.txt'];
    fid=fopen(file_name, 'wt');
    
    fprintf(fid, 'Running strategy %s on dataset %s.\n', strategy_name, dataset_name);
else
    fid = 1;  % use 1 to ensure no leak
end

start_time = datestr(now, 'yyyy-mmdd-HH-MM-SS-FFF');

if (opts.log_mode)
    fprintf(fid, 'Start Time: %s.\n', start_time);
end
if (~opts.quiet_mode)
    fprintf(1, 'Start Time: %s.\n', start_time);
end

%%%%%%%%%%%%%%Calling Strategy Stage%%%%%%%%%%%%%%%%%%%
fprintf(1, '----Begin %s on %s-----\n', strategy_name, dataset_name);
start_watch = tic;

strategy_fun = [strategy_name '(fid, data, varargins, opts)'];
[cum_ret, cumprod_ret, daily_ret, daily_portfolio] = eval(strategy_fun);

tElapse = toc(start_watch);
fprintf(1, '----End %s on %s-----\n', strategy_name, dataset_name);

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if (isOctave) fflush(stdout); % force output in Octave
%%%%%%%%%%%%%%Logging Stage%%%%%%%%%%%%%%%%%%%%%%
stop_time = datestr(now, 'yyyy-mmdd-HH-MM-SS-FFF');

if (opts.log_mode)
    fprintf(fid, 'Stop Time: %s.\n', stop_time);
    fprintf(fid, 'Elapse time(s): %f.\n', tElapse);
end

if (~opts.quiet_mode)
    fprintf(1, 'Stop Time: %s.\n', stop_time);
    fprintf(1, 'Elapse time(s): %f.\n', tElapse);
end

%%%%%%%%%%%%%%Analysis Stage%%%%%%%%%%%%%%%%%%%%%%
% Analyze the results, output to the log file and screen
ra_ret = [];
run_time = tElapse;
if (opts.analyze_mode)
    [ra_ret] = ra_result_analyze(fid, data, cum_ret, cumprod_ret, daily_ret, opts);
end

%% Save the result variables to a .mat file
if (opts.mat_mode)
    mat_dt = datestr(now, 'yyyy-mmdd-HH-MM');
    mat_name = ['../Log/Mat/' strategy_name '-' dataset_name '-' mat_dt '.mat'];
    save(mat_name,  'cum_ret', 'cumprod_ret', 'daily_ret', 'ra_ret', 'run_time', 'daily_portfolio');
end

% Clear the log file
if (opts.log_mode)
    fclose(fid);
end

%% Email notivation, currently disabled.
% %% Send the results to email: libin.yz@gmail.com
% if (opts.log_mode) && (opts.mat_mode)
%     msg_rcv = ['libin.yz@gmail.com'];
%     msg_head = ['Results from MATLAB:' strategy_name '-' dataset_name '-' dt ];
%     msg_body = ['cum_ret' num2str(cum_ret) '    ' 'run_time' num2str(run_time)];
%     msg_attach =[file_name];
% %    sendmail(msg_rcv, msg_head, msg_body,{msg_attach})
% end

end
%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%
