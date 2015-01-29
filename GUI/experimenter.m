function varargout = experimenter(varargin)
% EXPERIMENTER M-file for experimenter.fig
%      EXPERIMENTER, by itself, creates a new EXPERIMENTER or raises the existing
%      singleton*.
%
%      H = EXPERIMENTER returns the handle to a new EXPERIMENTER or the handle to
%      the existing singleton*.
%
%      EXPERIMENTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMENTER.M with the given input arguments.
%
%      EXPERIMENTER('Property','Value',...) creates a new EXPERIMENTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before experimenter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to experimenter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experimenter

% Last Modified by GUIDE v2.5 31-Jan-2013 19:47:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @experimenter_OpeningFcn, ...
                   'gui_OutputFcn',  @experimenter_OutputFcn, ...
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


% --- Executes just before experimenter is made visible.
function experimenter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to experimenter (see VARARGIN)

% Choose default command line output for experimenter
handles.output = hObject;

    % Load the interface detail through the config and set it to the GUI
    load config/config;
    handles.config.algorithmList = algorithmList;
    handles.config.algorithmName = algorithmName;
    handles.config.algorithmParameters = algorithmParameters;
    handles.config.dataList = dataList;
    handles.config.dataName = dataName;
    handles.config.defaultParameters = defaultParameters;
    handles.config.dataFrequency = dataFrequency;
    
    % Read data, load it
    dataSelected = (get(handles.dataList, 'value'));
    dataName = handles.config.dataName(dataSelected);
    dataName = dataName{1};
    handles.dataset = load( fullfile('../Data', dataName) );
    handles.frequency = handles.config.dataFrequency(dataSelected);
    
    
    % The list of data and algorithm names for menu
    set(handles.dataList,'String',handles.config.dataList);
    set(handles.algorithmList,'String',handles.config.algorithmList);
    [r c] = size(algorithmList);
    handles.selectionBits = zeros(r,1);
    handles.selectedIds = 0;
    
    % Read data, load it
    dataSelected = (get(handles.dataList, 'value'));
    dataName = handles.config.dataName(dataSelected);
    dataName = dataName{1};
    handles.dataset = load( fullfile('../Data', dataName) );
    guidata(hObject, handles);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes experimenter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = experimenter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in dataList.
function dataList_Callback(hObject, eventdata, handles)
% hObject    handle to dataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataList
  
    % Read data, load it
    dataSelected = (get(handles.dataList, 'value'));
    dataName = handles.config.dataName(dataSelected);
    dataName = dataName{1};
    handles.dataset = load( fullfile('../Data', dataName) );
    handles.frequency = handles.config.dataFrequency(dataSelected);
    guidata(hObject, handles);

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


% --- Executes on selection change in algorithmList.
function algorithmList_Callback(hObject, eventdata, handles)
% hObject    handle to algorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns algorithmList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from algorithmList


% --- Executes during object creation, after setting all properties.
function algorithmList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to algorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the selected algorithm and add to list of selected algorithms
    chosenOne = get(handles.algorithmList,'Value');
    handles.selectionBits(chosenOne) = 1;
    list = get(handles.algorithmList,'String');
    [selectedList ids] = getSelectedList(list, handles.selectionBits);
    handles.selectedIds = ids;
    set(handles.selectedAlgorithmList,'String',selectedList);
    guidata(hObject, handles);
    
    updateInputForm(hObject, eventdata, handles);
    

% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if handles.selectedIds ~= 0
        toDelete = get(handles.selectedAlgorithmList,'Value');
        chosenOne = handles.selectedIds(toDelete);
        handles.selectionBits(chosenOne) = 0;

        list = get(handles.algorithmList,'String');
        [selectedList ids] = getSelectedList(list, handles.selectionBits);
        handles.selectedIds(toDelete) = [];

        set(handles.selectedAlgorithmList,'String',selectedList);

        [r c] = size(selectedList);
        if toDelete > r
            if r == 0
                r = r+1;
            end
            set(handles.selectedAlgorithmList,'Value',r);
        end
        guidata(hObject, handles);
    end
    
    updateInputForm(hObject, eventdata, handles);

% --- Executes on selection change in selectedAlgorithmList.
function selectedAlgorithmList_Callback(hObject, eventdata, handles)
% hObject    handle to selectedAlgorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectedAlgorithmList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedAlgorithmList

    
    % When an algorithm is selected here, you update the input form
    set(handles.savedMessage,'String','');
    updateInputForm(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function selectedAlgorithmList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectedAlgorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % If no algorithm is selected do nothing
    if sum(handles.selectionBits) == 0
        return;
    end
    
    % Now execute each algortihm one by one in a loop
    
    ctr = 1;
    totalAlgorithms = sum(handles.selectionBits);
    
    [r c] = size(handles.selectionBits);
    % Check if any of the inputs are invalid, do not execute if so.
    error = 0;
    for i = 1:1:r
        % Inputs for the parameter
        inputs = handles.config.defaultParameters(i,:);
        emptyCells = cellfun(@isempty,inputs);
        inputs(emptyCells) = [];
        error = error + sum (cellfun(@(V) any(isnan(V(:))), inputs));
        if error > 0
            disp('Warning: Erroneous input detected');
            errorMessage('Erroneous input detected! Please verify the inputs.');
            return;
        end
    end
    
    
    
    % Using functions from other directories - the library
    addpath('./lib');
    addpath('../Strategy');
    
    for i = 1:1:r
        if handles.selectionBits(i) == 1
            selectedAlgorithms(ctr) = handles.config.algorithmList(i);
            ctr = ctr+1;
        end
    end
    
    
    % Check if algorithm is selected, and execute
    ctr = 1;
    progressList = waitbar(0,'Executing Algorithms');
    
    dim = get(0,'screensize');
    movegui(progressList, [(dim(3)/2)-182 (dim(4)/2)+75]);
    
    
    
    
    
    for i = 1:1:r
        
        if handles.selectionBits(i) == 1
            % This means this algorthm was selected by user
            message = ['Now executing ', handles.config.algorithmList(i)];
            waitbar((ctr-1)/totalAlgorithms,progressList,message);
            
            
            % Part similar to trading manager
            data = handles.dataset.data;
            
            % Inputs for the parameter
            inputs = handles.config.defaultParameters(i,:);
            emptyCells = cellfun(@isempty,inputs);
            inputs(emptyCells) = [];
            
            % Run the algorithm in compatibility with Bin's format
            % Define the options
            opts.quiet_mode = 1; opts.display_interval = 500;
            opts.log_mode = 1; opts.mat_mode = 1;
            opts.analyze_mode = 1;
            opts.his = 0;
            opts.progress = 1;

            strategy_name = handles.config.algorithmName(i);
            strategy_fun = strcat(strategy_name, '(1, data, inputs, opts)');
            strategy_fun = cell2mat(strategy_fun);
            [stats(:,ctr) cumprod_ret(:,ctr) daily_ret(:,ctr), daily_portfolio{ctr}] = eval(strategy_fun);
            
            ctr = ctr + 1;
        end
        
    end
    
    waitbar((ctr-1)/totalAlgorithms,progressList,'All algorithms Executed');
    close(progressList);
    
    resultManager2(daily_ret, daily_portfolio, selectedAlgorithms', handles.frequency);

function [selected ids] = getSelectedList(list, selectionBits)

    ids = 0;
    selected = {'No Algorithm Selected'};
    [r c] = size(selectionBits);
    ctr = 1;
    for i = 1:1:r
        if selectionBits(i) == 1
            selected{ctr,1} = list{i};
            ids(ctr) = i;
            ctr = ctr+1;
        end
    end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input1_Callback(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input1 as text
%        str2double(get(hObject,'String')) returns contents of input1 as a double


% --- Executes during object creation, after setting all properties.
function input1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input2_Callback(hObject, eventdata, handles)
% hObject    handle to input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input2 as text
%        str2double(get(hObject,'String')) returns contents of input2 as a double


% --- Executes during object creation, after setting all properties.
function input2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input3_Callback(hObject, eventdata, handles)
% hObject    handle to input3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input3 as text
%        str2double(get(hObject,'String')) returns contents of input3 as a double


% --- Executes during object creation, after setting all properties.
function input3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input4_Callback(hObject, eventdata, handles)
% hObject    handle to input4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input4 as text
%        str2double(get(hObject,'String')) returns contents of input4 as a double


% --- Executes during object creation, after setting all properties.
function input4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input5_Callback(hObject, eventdata, handles)
% hObject    handle to input5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input5 as text
%        str2double(get(hObject,'String')) returns contents of input5 as a double


% --- Executes during object creation, after setting all properties.
function input5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input6_Callback(hObject, eventdata, handles)
% hObject    handle to input6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input6 as text
%        str2double(get(hObject,'String')) returns contents of input6 as a double


% --- Executes during object creation, after setting all properties.
function input6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set.
function set_Callback(hObject, eventdata, handles)
% hObject    handle to set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % When set is pressed, a message saying the the parameters have been
    % saved should be displayed, and the parameters should actually be
    % saved
    if sum(handles.selectionBits) == 0
        return;
    end
    
    toUpdate = get(handles.selectedAlgorithmList,'Value');
    algorithmId = handles.selectedIds(toUpdate);
    
    % Read the input parameters from the GUI Input Form   
    temp = get(handles.input1,'string');
    if strcmp(temp ,'-') == 0
        inputs{1} = str2double(temp);
    end
    temp = get(handles.input2,'string');
    if strcmp(temp ,'-') == 0
        inputs{2} = str2double(temp);
    end
    temp = get(handles.input3,'string');
    if strcmp(temp ,'-') == 0
        inputs{3} = str2double(temp);
    end
    temp = get(handles.input4,'string');
    if strcmp(temp ,'-') == 0
        inputs{4} = str2double(temp);
    end
    temp = get(handles.input5,'string');
    if strcmp(temp ,'-') == 0
        inputs{5} = str2double(temp);
    end
    temp = get(handles.input6,'string');
    if strcmp(temp ,'-') == 0
        inputs{6} = str2double(temp);
    end
    
    [r c] = size(inputs);
    handles.config.defaultParameters(algorithmId,1:c) = inputs;
    
    
    set(handles.savedMessage,'String','Saved!');
    % Update handles structure
    guidata(hObject, handles);

    
    

function updateInputForm(hObject, eventdata, handles)
    
    % Update static text fields for input
    set(handles.inputAlgorithm,'String','No Algorithm Selected');
    
    set(handles.in1,'String','N/A');set(handles.in2,'String','N/A');
    set(handles.in3,'String','N/A');set(handles.in4,'String','N/A');
    set(handles.in5,'String','N/A');set(handles.in6,'String','N/A');
    
    set(handles.input1,'String','-');set(handles.input2,'String','-');
    set(handles.input3,'String','-');set(handles.input4,'String','-');
    set(handles.input5,'String','-');set(handles.input6,'String','-');


    if sum(handles.selectionBits) == 0
        return;
    end

    % First read selected algorithm in the selected algorithm list
    % Then from teh config extract and fill up the input form
    toShow = get(handles.selectedAlgorithmList,'Value');
    algorithmId = handles.selectedIds(toShow);
    
    parameters = handles.config.algorithmParameters(algorithmId,:);
    defaultParameters = handles.config.defaultParameters(algorithmId,:);
    emptyCells = cellfun(@isempty,parameters);
    parameters(emptyCells) = [];
    emptyCells = cellfun(@isempty,defaultParameters);
    defaultParameters(emptyCells) = [];
    
    set(handles.inputAlgorithm,'String',handles.config.algorithmList(algorithmId));
    
    [tmp1 tmp2] = size(parameters);
    if tmp2 > 0
        set(handles.in1,'String',parameters(1));
        set(handles.input1,'String',defaultParameters(1));
    end
    if tmp2 > 1
        set(handles.in2,'String',parameters(2));
        set(handles.input2,'String',defaultParameters(2));
    end
    if tmp2 > 2
        set(handles.in3,'String',parameters(3));
        set(handles.input3,'String',defaultParameters(3));
    end
    if tmp2 > 3
        set(handles.in4,'String',parameters(4));
        set(handles.input4,'String',defaultParameters(4));
    end
    if tmp2 > 4
        set(handles.in5,'String',parameters(5));
        set(handles.input5,'String',defaultParameters(5));
    end
    if tmp2 > 5
        set(handles.in6,'String',parameters(6));
        set(handles.input6,'String',defaultParameters(6));
    end
    

        
