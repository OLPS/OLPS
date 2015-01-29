function OLPS_cli(dataset) 
% this program demos the usage of different strategies of on-line portfolio selection
% in the mode of command-line interface (CLI)
% dataset: one can choose any of the following data sets 
%  - 'djia' (default): DJIA (US) perioid 01/14/2001 - 01/14/2003
%  - 'msci' : MSCI (global) peroid 04/01/2006 - 03/31/2010
%  - 'nyse-n': NYSE (US) peroid 01/01/1985 - 06/30/2010
%  - 'nyse-o': NYSE (US) peroid 07/03/1962 - 12/31/1984 
%  - 'sp500':  S&P500 (US) period 01/02/1998 - 01/31/2003
%  - 'tse': TSE (CA) peroid 01/04/1994 - 12/31/1998
cd Strategy;

opts.quiet_mode = 1; opts.display_interval = 500;
opts.log_mode = 1; opts.mat_mode = 1;
opts.analyze_mode = 1; opts.progress = 0;
opts.his = 0;

if (nargin<1)
    dataset = 'djia';
end

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