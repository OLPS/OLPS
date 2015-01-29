function varargout = aboutOLPS(varargin)
% ABOUTOLPS MATLAB code for aboutOLPS.fig
%      ABOUTOLPS, by itself, creates a new ABOUTOLPS or raises the existing
%      singleton*.
%
%      H = ABOUTOLPS returns the handle to a new ABOUTOLPS or the handle to
%      the existing singleton*.
%
%      ABOUTOLPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUTOLPS.M with the given input arguments.
%
%      ABOUTOLPS('Property','Value',...) creates a new ABOUTOLPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aboutOLPS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aboutOLPS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aboutOLPS

% Last Modified by GUIDE v2.5 31-Jan-2013 17:42:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aboutOLPS_OpeningFcn, ...
                   'gui_OutputFcn',  @aboutOLPS_OutputFcn, ...
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


% --- Executes just before aboutOLPS is made visible.
function aboutOLPS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aboutOLPS (see VARARGIN)
    
    algoFramework = imread('Resources/algoFramework2.JPG');
    axes(handles.algorithmFramework);
    image(algoFramework);
    axis off;
    
    handles.m1 = 'OLPS is an open-source toolbox for studying on-line portofolio selection using some state-of-the-art machine learning algorithms. In an on-line portfolio selection task, a portfolio manager is a decision maker, whose goal is to produce a portfolio strategy, aiming to maximize the cumulative wealth. He/she computes the portfolios sequentially. On each period, the manager has access to the sequence of previous price relative vectors. Then, he/she computes a new portfolio for next unknown price relative vector, where the decision criterion varies among different managers. The portfolio is scored based on portfolio period return. This procedure is repeated until the end, and the portfolio strategy is finally scored according to portfolio cumulative wealth.';
    handles.m2 = {'Project Leader', 'Prof. Steven C.H. Hoi', 'Associate Professor, SMU, Singapore','','Active Project Members','Bin Li','Doyen Sahoo','','Alumni','Peilin Zhao',''};
    handles.m3  = {'Bin Li, Steven C.H. Hoi, Peilin Zhao, and Vivekanand Gopalkrishnan.','Confidence Weighted Mean Reversion Strategy for On-Line Portfolio Selection.','ACM Transactions on Knowledge Discovery from Data (TKDD), 2013. To appear.','','Bin Li, and Steven C.H. Hoi.', 'On-Line Portfolio with Moving Average Reversion.', 'International Conference on Machine Learning (ICML), 2012.','','Bin Li, Peilin Zhao, Steven C.H. Hoi, and Vivekanand Gopalkrishnan.','PAMR: Passive Aggressive Mean Reversion Strategy for Portfolio Selection.','Machine Learning (MLJ), 2012, 87(2), 221 - 258.','','Bin Li, Steven C.H. Hoi, Peilin Zhao, and Vivekanand Gopalkrishnan.','Confidence Weighted Mean Reversion Strategy for On-Line Portfolio Selection.','Journal of Machine Learning Research, W&CP (AISTATS 2011), 2011, 15, 434 - 442.','','Bin Li, Steven C.H. Hoi, and Vivekanand Gopalkrishnan.','CORN: Correlation-driven Nonparametric Learning Approach for Portfolio Selection.','ACM Transactions on Intelligent Systems and Technology (TIST), 2011, 2(3), 21:1 - 21:29.'}; 
    handles.m4 = {'All the datasets are collected from public domains, and we do not guarantee the correctness of the data.','','Each datasets consists of matrix of n*m, where n is the number of trading days and m is number of assets.','','All data sets are stored in MATLAB file format (.MAT)','','When using the data sets for publishing your reseasrch, you need to cite our data set ("NTU-OLPS") and our related papers.','','This tool uses the following 6 datasets','- Dow Jones Industrial Average (14-Jan-01 to 14-Jan-03)','- MSCI World Index (01-Apr-06 to 31-Mar-10)','- New York Stock Exchange (03-Jul-62 to 31-Dec-84)','- New York Stock Exchange (01-Jan-85 to 30-Jun-10)','- Standard & Poor 500 (02-Jan-98 to 31-Jan-2003)','- Toronto Stock Exchange (04-Jan-94 to 31-Dec-98)'};
    rd_about_Callback(hObject, eventdata, handles);
    
% Choose default command line output for aboutOLPS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes aboutOLPS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = aboutOLPS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rd_about.
function rd_about_Callback(hObject, eventdata, handles)
% hObject    handle to rd_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(hObject, eventdata, handles)
    set(handles.rd_about,'Value', 1); 
    set(handles.info,'String',handles.m1);
    set(handles.info,'FontSize',12);
% Hint: get(hObject,'Value') returns toggle state of rd_about


% --- Executes on button press in rd_people.
function rd_people_Callback(hObject, eventdata, handles)
% hObject    handle to rd_people (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(hObject, eventdata, handles)
    set(handles.rd_people,'Value', 1); 
    set(handles.info,'String',handles.m2);
    set(handles.info,'FontSize',11)
% Hint: get(hObject,'Value') returns toggle state of rd_people


% --- Executes on button press in rd_publications.
function rd_publications_Callback(hObject, eventdata, handles)
% hObject    handle to rd_publications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(hObject, eventdata, handles)
    set(handles.rd_publications,'Value', 1); 
    set(handles.info,'String',handles.m3);
    set(handles.info,'FontSize',8)
% Hint: get(hObject,'Value') returns toggle state of rd_publications


% --- Executes on button press in rd_datasets.
function rd_datasets_Callback(hObject, eventdata, handles)
% hObject    handle to rd_datasets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(hObject, eventdata, handles)
    set(handles.rd_datasets,'Value', 1); 
    set(handles.info,'String',handles.m4);
    set(handles.info,'FontSize',10)
% Hint: get(hObject,'Value') returns toggle state of rd_datasets

function clearRadio(hObject, eventdata, handles)
% The function is a helper function to uncheck all radio buttons

    set(handles.rd_about,'Value', 0); 
    set(handles.rd_people,'Value', 0); 
    set(handles.rd_publications,'Value', 0); 
    set(handles.rd_datasets,'Value', 0); 
