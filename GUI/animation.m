function varargout = animation(varargin)
% ANIMATION M-file for animation.fig
%      ANIMATION, by itself, creates a new ANIMATION or raises the existing
%      singleton*.
%
%      H = ANIMATION returns the handle to a new ANIMATION or the handle to
%      the existing singleton*.
%
%      ANIMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANIMATION.M with the given input arguments.
%
%      ANIMATION('Property','Value',...) creates a new ANIMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before animation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to animation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help animation

% Last Modified by GUIDE v2.5 09-Jul-2013 19:10:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @animation_OpeningFcn, ...
                   'gui_OutputFcn',  @animation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before animation is made visible.
function animation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to animation (see VARARGIN)

    handles.portfolio = varargin{1};
    handles.windowAnimation = varargin{2};
    handles.status = 1;
    [r c] = size(handles.portfolio);
    handles.nframes = r;
    handles.c = c;
    guidata(hObject, handles);
   
    startAnimating(hObject, eventdata, handles, varargin);
    
    % Choose default command line output for temp
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
% UIWAIT makes animation wait for user response (see UIRESUME)
% uiwait(handles.animationGui);

function startAnimating(hObject, eventdata, handles, varargin)
    c = handles.c;
    handles.status = 1;
    
    try
        for i = 1:handles.nframes
            start = max(1, i-handles.windowAnimation+1);
            finish = i;
            toPlot = mean(handles.portfolio(start:finish,:));
            bar(handles.animationGraph,toPlot);
            axis([0.5 (c+0.5) 0 1]); 
            grid on; 
            if ishandle(handles.animationGui)
                M(i) = getframe;
                set(handles.time,'String',strcat('Time Period: ', int2str(i)));
            else
                return;
            end
            if handles.status == 0
                return;
            end
        end
    catch exception
    end
    
    handles.output = hObject;

% --- Outputs from this function are returned to the command line.
function varargout = animation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in closeAnimation.
function closeAnimation_Callback(hObject, eventdata, handles)
% hObject    handle to closeAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.status = 0;
    guidata(hObject, handles);
    close(handles.animationGui);
