function [] = OLPS_gui()
% This functions starts the GUI
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if (isOctave) % GUI is not yet available in Octave
    disp('The GUI is not yet available in Octave. We welcome developers to help build GUI for Octave!');
else % run GUI in Matlab
    cd GUI;
    start;
end
