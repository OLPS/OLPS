function [] = OLPS_gui()
% OLPS_gui: run OLPS toolbox in GUI (current version available in Matlab only)
% This function starts the GUI of the OLPS toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo, Bin LI, Steven C.H. Hoi
% Contributors: 
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if (isOctave) % GUI is not yet available in Octave
    disp('The GUI is not yet available in Octave. We welcome developers to help build GUI for Octave!');
else % run GUI in Matlab
    cd GUI;
    start;
end
