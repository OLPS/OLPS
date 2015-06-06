function OLPS_cli2
% OLPS_cli: run OLPS toolbox in CLI (available in both Matlab and Octave)
% this program demos different strategies of on-line portfolio selection
% in the mode of command-line interface (CLI)
%
% OLPS_cli(dataset) 
%
% dataset: one can choose any of the following data sets 
%  - 'djia':    (default) DJIA (US) perioid 01/14/2001 - 01/14/2003
%  - 'msci':    MSCI (global)       peroid 04/01/2006 - 03/31/2010
%  - 'nyse-n':  NYSE (US)           peroid 01/01/1985 - 06/30/2010
%  - 'nyse-o':  NYSE (US)           peroid 07/03/1962 - 12/31/1984 
%  - 'sp500':   S&P500(US)          period 01/02/1998 - 01/31/2003
%  - 'tse':     TSE (CA)            peroid 01/04/1994 - 12/31/1998

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Doyen Sahoo, Steven C.H. Hoi
% Contributors: 
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

homeMenu;