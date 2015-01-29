function varargout = deletedMessage(varargin)
% DELETEDMESSAGE M-file for deletedMessage.fig
%      DELETEDMESSAGE, by itself, creates a new DELETEDMESSAGE or raises the existing
%      singleton*.
%
%      H = DELETEDMESSAGE returns the handle to a new DELETEDMESSAGE or the handle to
%      the existing singleton*.
%
%      DELETEDMESSAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELETEDMESSAGE.M with the given input arguments.
%
%      DELETEDMESSAGE('Property','Value',...) creates a new DELETEDMESSAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before deletedMessage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to deletedMessage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help deletedMessage

% Last Modified by GUIDE v2.5 13-Jul-2013 01:23:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @deletedMessage_OpeningFcn, ...
                   'gui_OutputFcn',  @deletedMessage_OutputFcn, ...
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


% --- Executes just before deletedMessage is made visible.
function deletedMessage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to deletedMessage (see VARARGIN)

    message = varargin{1};
    set(handles.message,'String', message);
% Choose default command line output for deletedMessage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes deletedMessage wait for user response (see UIRESUME)
% uiwait(handles.deletedMessage);


% --- Outputs from this function are returned to the command line.
function varargout = deletedMessage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
