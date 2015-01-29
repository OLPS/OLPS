function demo_all() 
% this program manages different bandit strategies and dataset for portfolio selection

opts.quiet_mode = 1; opts.display_interval = 500;
opts.log_mode = 1; opts.mat_mode = 1;
opts.analyze_mode = 1;
opts.his = 0;

dataset = 'djia';

%----------Benchmarks--------------
manager('ubah', dataset, {0}, opts);
manager('best', dataset, {0}, opts);
manager('ucrp', dataset, {0}, opts);
manager('bcrp', dataset, {0}, opts);

%---------Follow the Winner-------------------
manager('up', dataset, {0}, opts);
manager('eg',  dataset, {0.05, 0}, opts);
manager('ons', dataset, {0, 1, 1/8, 0}, opts);

% manager('sp_start', dataset, {0.25, 0}, opts);
% manager('grw_start', dataset, {0.00005, 0}, opts);
% manager('m0_start', dataset, {0.5, 0}, opts);

%----------Follow the Loser------------------------
manager('anticor', dataset, {30, 0}, opts);
manager('anticor_anticor', dataset, {30, 0}, opts);
manager('pamr', dataset, {0.5, 0}, opts);
manager('pamr_1', dataset, {0.5, 500, 0}, opts);
manager('pamr_2', dataset, {0.5, 500, 0}, opts);
manager('cwmr_var', dataset, {2, 0.5, 0}, opts);
manager('cwmr_stdev', dataset, {2, 0.5, 0}, opts);
manager('olmar1', dataset, {10, 5, 0}, opts);
manager('olmar2', dataset, {10, 0.5, 0}, opts);

%--------Pattern Matching based approach---------
manager('bk', dataset, {5, 10, 1, 0}, opts);
manager('bnn', dataset, {5, 10, 0}, opts);
manager('corn', dataset, {5, 0.1, 0}, opts);
manager('cornu', dataset, {5, 1, 0.1, 0}, opts);
manager('cornk', dataset, {5, 10, 0.1, 0, 1}, opts);

end