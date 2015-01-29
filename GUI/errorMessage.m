function varargout = errorMessage(varargin)
% ERRORMESSAGE M-file for errorMessage.fig
%      ERRORMESSAGE, by itself, creates a new ERRORMESSAGE or raises the existing
%      singleton*.
%
%      H = ERRORMESSAGE returns the handle to a new ERRORMESSAGE or the handle to
%      the existing singleton*.
%
%      ERRORMESSAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORMESSAGE.M with the given input arguments.
%
%      ERRORMESSAGE('Property','Value',...) creates a new ERRORMESSAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before errorMessage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to errorMessage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help errorMessage

% Last Modified by GUIDE v2.5 09-Jul-2013 23:40:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @errorMessage_OpeningFcn, ...
                   'gui_OutputFcn',  @errorMessage_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before errorMessage is made visible.
function errorMessage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to errorMessage (see VARARGIN)

% Choose default command line output for errorMessage
handles.output = hObject;
    message = varargin{1};
    set(handles.message,'String', message);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes errorMessage wait for user response (see UIRESUME)
% uiwait(handles.errorMessage);


% --- Outputs from this function are returned to the command line.
function varargout = errorMessage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
