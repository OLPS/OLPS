function varargout = configManager(varargin)
% CONFIGMANAGER MATLAB code for configManager.fig
%      CONFIGMANAGER, by itself, creates a new CONFIGMANAGER or raises the existing
%      singleton*.
%
%      H = CONFIGMANAGER returns the handle to a new CONFIGMANAGER or the handle to
%      the existing singleton*.
%
%      CONFIGMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGMANAGER.M with the given input arguments.
%
%      CONFIGMANAGER('Property','Value',...) creates a new CONFIGMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before configManager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to configManager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help configManager

% Last Modified by GUIDE v2.5 21-Jul-2013 15:10:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @configManager_OpeningFcn, ...
                   'gui_OutputFcn',  @configManager_OutputFcn, ...
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


% --- Executes just before configManager is made visible.
function configManager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to configManager (see VARARGIN)

    load config/config;
    handles.config.algorithmList = algorithmList;
    handles.config.algorithmName = algorithmName;
    handles.config.algorithmParameters = algorithmParameters;
    handles.config.dataList = dataList;
    handles.config.dataName = dataName;
    handles.config.defaultParameters = defaultParameters;
    handles.config.dataFrequency = dataFrequency;
    
    % The list of data and algorithm names for menu
    set(handles.dataList,'String',handles.config.dataList);
    set(handles.algorithmList,'String',handles.config.algorithmList);

% Choose default command line output for configManager
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes configManager wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = configManager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dataNameString_Callback(hObject, eventdata, handles)
% hObject    handle to dataNameString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataNameString as text
%        str2double(get(hObject,'String')) returns contents of dataNameString as a double


% --- Executes during object creation, after setting all properties.
function dataNameString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataNameString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dataFileName_Callback(hObject, eventdata, handles)
% hObject    handle to dataFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataFileName as text
%        str2double(get(hObject,'String')) returns contents of dataFileName as a double


% --- Executes during object creation, after setting all properties.
function dataFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency as text
%        str2double(get(hObject,'String')) returns contents of frequency as a double


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addData.
function addData_Callback(hObject, eventdata, handles)
% hObject    handle to addData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.deleteDataMessage, 'String', '');
    set(handles.deleteAlgorithmMessage, 'String', '');
   
    [r c] = size(handles.config.dataList);
    fileName = get(handles.dataFileName, 'string');
    handles.config.dataList(r+1,c) = {get(handles.dataNameString, 'string')};
    handles.config.dataName(r+1,c) = {fileName};
    handles.config.dataFrequency(r+1,c) = str2num(get(handles.frequency, 'string'));
    
    % Check if file exists
    fullPath = strcat('..\Data\',fileName, '.mat');
    if ~(exist(fullPath) == 2)
        errorMessage('File does not exist. Please create the file before running the tool box to avoid errors. If the file exists, please enter file name without the .mat extension to avoid this warning. Data has been added.');
    end
    
    
    set(handles.dataList,'String',handles.config.dataList);
    
    set(handles.addDataMessage, 'String', 'Added!');
    pause(1);
    set(handles.addDataMessage, 'String', '');
    
    guidata(hObject, handles);
    
    
    
% --- Executes on selection change in dataList.
function dataList_Callback(hObject, eventdata, handles)
% hObject    handle to dataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataList
    set(handles.deleteDataMessage, 'String', '');
    set(handles.deleteAlgorithmMessage, 'String', '');


% --- Executes during object creation, after setting all properties.
function dataList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deleteData.
function deleteData_Callback(hObject, eventdata, handles)
% hObject    handle to deleteData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    set(handles.deleteDataMessage, 'String', '');
    set(handles.deleteAlgorithmMessage, 'String', '');
    
    [r c] = size(handles.config.dataList);
    if r > 1
        % Delete the selected data set from config
        dataId = get(handles.dataList, 'Value');
        toBeDeleted = handles.config.dataList(dataId);
        handles.config.dataList(dataId) = [];
        handles.config.dataName(dataId) = [];
        handles.config.dataFrequency(dataId) = [];

        % Update data list
        if dataId == r
            set(handles.dataList, 'value', r-1);
        end
        set(handles.dataList,'String',handles.config.dataList);
        guidata(hObject, handles);
        
        % print an updated message for 1 second that something got deleted
        set(handles.deleteDataMessage, 'String', 'Deleted!');
        message = ['Deleted the following data set:' ' ' toBeDeleted];
        deletedMessage(message);
        
    else
        set(handles.deleteDataMessage, 'String', 'Cannot delete all the data from config');
    end
    

function algorithmName_Callback(hObject, eventdata, handles)
% hObject    handle to algorithmName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of algorithmName as text
%        str2double(get(hObject,'String')) returns contents of algorithmName as a double


% --- Executes during object creation, after setting all properties.
function algorithmName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to algorithmName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function algorithmFileName_Callback(hObject, eventdata, handles)
% hObject    handle to algorithmFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of algorithmFileName as text
%        str2double(get(hObject,'String')) returns contents of algorithmFileName as a double


% --- Executes during object creation, after setting all properties.
function algorithmFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to algorithmFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p1_Callback(hObject, eventdata, handles)
% hObject    handle to p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1 as text
%        str2double(get(hObject,'String')) returns contents of p1 as a double


% --- Executes during object creation, after setting all properties.
function p1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p2_Callback(hObject, eventdata, handles)
% hObject    handle to p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2 as text
%        str2double(get(hObject,'String')) returns contents of p2 as a double


% --- Executes during object creation, after setting all properties.
function p2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p3_Callback(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p3 as text
%        str2double(get(hObject,'String')) returns contents of p3 as a double


% --- Executes during object creation, after setting all properties.
function p3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p4_Callback(hObject, eventdata, handles)
% hObject    handle to p4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p4 as text
%        str2double(get(hObject,'String')) returns contents of p4 as a double


% --- Executes during object creation, after setting all properties.
function p4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p5_Callback(hObject, eventdata, handles)
% hObject    handle to p5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p5 as text
%        str2double(get(hObject,'String')) returns contents of p5 as a double


% --- Executes during object creation, after setting all properties.
function p5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p6_Callback(hObject, eventdata, handles)
% hObject    handle to p6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p6 as text
%        str2double(get(hObject,'String')) returns contents of p6 as a double


% --- Executes during object creation, after setting all properties.
function p6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d1_Callback(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d1 as text
%        str2double(get(hObject,'String')) returns contents of d1 as a double


% --- Executes during object creation, after setting all properties.
function d1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d2_Callback(hObject, eventdata, handles)
% hObject    handle to d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d2 as text
%        str2double(get(hObject,'String')) returns contents of d2 as a double


% --- Executes during object creation, after setting all properties.
function d2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d3_Callback(hObject, eventdata, handles)
% hObject    handle to d3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d3 as text
%        str2double(get(hObject,'String')) returns contents of d3 as a double


% --- Executes during object creation, after setting all properties.
function d3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d4_Callback(hObject, eventdata, handles)
% hObject    handle to d4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d4 as text
%        str2double(get(hObject,'String')) returns contents of d4 as a double


% --- Executes during object creation, after setting all properties.
function d4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d5_Callback(hObject, eventdata, handles)
% hObject    handle to d5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d5 as text
%        str2double(get(hObject,'String')) returns contents of d5 as a double


% --- Executes during object creation, after setting all properties.
function d5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d6_Callback(hObject, eventdata, handles)
% hObject    handle to d6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d6 as text
%        str2double(get(hObject,'String')) returns contents of d6 as a double


% --- Executes during object creation, after setting all properties.
function d6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in algorithmList.
function algorithmList_Callback(hObject, eventdata, handles)
% hObject    handle to algorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns algorithmList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from algorithmList
    set(handles.deleteDataMessage, 'String', '');
    set(handles.deleteAlgorithmMessage, 'String', '');


% --- Executes during object creation, after setting all properties.
function algorithmList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to algorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deleteAlgorithm.
function deleteAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
    set(handles.deleteDataMessage, 'String', '');
    set(handles.deleteAlgorithmMessage, 'String', '');
    
    [r c] = size(handles.config.algorithmList);
    if r > 1
        
        % Delete the selected algorithm from config
        algorithmId = get(handles.algorithmList, 'Value');
        toBeDeleted = handles.config.algorithmList(algorithmId);
        handles.config.algorithmList(algorithmId) = [];
        handles.config.algorithmName(algorithmId) = [];
        handles.config.algorithmParameters(algorithmId,:) = [];
        handles.config.defaultParameters(algorithmId,:) = [];
        
        % Update data list
        if algorithmId == r
            set(handles.algorithmList, 'value', r-1);
        end
        set(handles.algorithmList,'String',handles.config.algorithmList);
        guidata(hObject, handles);
        
        % print an updated message for 1 second that something got deleted
        set(handles.deleteAlgorithmMessage, 'String', 'Deleted!'); 
        message = ['Deleted the following algorithm:' ' ' toBeDeleted];
        deletedMessage(message);
        guidata(hObject, handles);
    else
        set(handles.deleteAlgorithmMessage, 'String', 'Cannot delete all algorithms from config');
    end


% --- Executes on button press in addAlgorithm.
function addAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to addAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.deleteDataMessage, 'String', '');
    set(handles.deleteAlgorithmMessage, 'String', '');
    
    [r c] = size(handles.config.algorithmList);
    fileName = get(handles.algorithmFileName, 'string');
    
    % Check if file exists, else return
    fullPath = strcat('..\Strategy\',fileName, '.m');
    if ~(exist(fullPath) == 2)
        errorMessage('File does not exist. Please create the file before running the tool box to avoid errors. If the file exists, please enter file name without the .m extension to avoid this warning. Algortihm has been added.');
    end
    
    handles.config.algorithmList(r+1,c) = {get(handles.algorithmName, 'string')};
    handles.config.algorithmName(r+1,c) = {fileName};
    
    % Construct input vectors before adding them to config
    newParameters = {};
    newDefault = {};
    
    temp = get(handles.p1,'string');
    if strcmp(temp ,'-') == 0
        newParameters{1} = (temp);
        newDefault{1} = str2double(get(handles.d1,'string'));
    else
        newParameters{1} = [];
        newDefault{1} = [];
    end
    temp = get(handles.p2,'string');
    if strcmp(temp ,'-') == 0
        newParameters{2} = (temp);
        newDefault{2} = str2double(get(handles.d1,'string'));
    else
        newParameters{2} = [];
        newDefault{2} = [];
    end
    temp = get(handles.p3,'string');
    if strcmp(temp ,'-') == 0
        newParameters{3} = (temp);
        newDefault{3} = str2double(get(handles.d1,'string'));
    else
        newParameters{3} = [];
        newDefault{3} = [];    
    end
    temp = get(handles.p4,'string');
    if strcmp(temp ,'-') == 0
        newParameters{4} = (temp);
        newDefault{4} = str2double(get(handles.d1,'string'));
    else
        newParameters{4} = [];
        newDefault{4} = [];    
    end
    temp = get(handles.p5,'string');
    if strcmp(temp ,'-') == 0
        newParameters{5} = (temp);
        newDefault{5} = str2double(get(handles.d1,'string'));
    else
        newParameters{5} = [];
        newDefault{5} = [];
    end
    temp = get(handles.p6,'string');
    if strcmp(temp ,'-') == 0
        newParameters{6} = (temp);
        newDefault{6} = str2double(get(handles.d1,'string'));
    else
        newParameters{6} = [];
        newDefault{6} = [];
    end
    
    % Update the parameters in config
    if length(newParameters) > 0
        handles.config.algorithmParameters(r+1,:) = newParameters;
        handles.config.defaultParameters(r+1,:) = newDefault;
    else
        handles.config.algorithmParameters(r+1,:) = {[]};
        handles.config.algorithmParameters(r+1,:) = {[]};
    end

    set(handles.algorithmList,'String',handles.config.algorithmList);
    
    set(handles.addAlgorithmMessage, 'String', 'Added!');
    pause(1);
    set(handles.addAlgorithmMessage, 'String', '');
    
    guidata(hObject, handles);
    



function configFileName_Callback(hObject, eventdata, handles)
% hObject    handle to configFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of configFileName as text
%        str2double(get(hObject,'String')) returns contents of configFileName as a double


% --- Executes during object creation, after setting all properties.
function configFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to configFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in activeConfigCheck.
function activeConfigCheck_Callback(hObject, eventdata, handles)
% hObject    handle to activeConfigCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of activeConfigCheck


% --- Executes on button press in saveConfig.
function saveConfig_Callback(hObject, eventdata, handles)
% hObject    handle to saveConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Save the new preferences to config
    try
        
        chosenFileName = (get(handles.configFileName,'string'));
        if strcmp (chosenFileName, 'config')
            errorMessage('File cannot be named "config"! "config" saves the active preferences.');
            return;
        end
        
        n = handles.config;
        algorithmList = n.algorithmList;
        algorithmName = n.algorithmName;
        algorithmParameters = n.algorithmParameters; 
        dataFrequency = n.dataFrequency;
        dataList = n.dataList;
        dataName = n.dataName;
        defaultParameters = n.defaultParameters;
        
        filePath = strcat('config/',chosenFileName);

        if ~(exist(strcat(filePath,'.mat')) == 2)

            save(filePath, 'algorithmList','algorithmName', 'algorithmParameters', 'dataFrequency','dataList','dataName','defaultParameters');

            % If the user wants to make this the active configuration
            if get(handles.activeConfigCheck, 'Value')
                filePath = strcat('config/','config');
                save(filePath, 'algorithmList','algorithmName', 'algorithmParameters', 'dataFrequency','dataList','dataName','defaultParameters');
            end
            
            %display saved message
            set(handles.configSave, 'String', 'Saved this configuration!');
            
        else
            errorMessage('This configuration file name already exists!');
            return;
        end
    catch exception
        errorMessage('Error in naming config file! Please enter a valid file name.');
    end
