function varargout = tradingManager(varargin)
% TRADINGMANAGER M-file for tradingManager.fig
%      TRADINGMANAGER, by itself, creates a new TRADINGMANAGER or raises the existing
%      singleton*.
%
%      H = TRADINGMANAGER returns the handle to a new TRADINGMANAGER or the handle to
%      the existing singleton*.
%
%      TRADINGMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRADINGMANAGER.M with the given input arguments.
%
%      TRADINGMANAGER('Property','Value',...) creates a new TRADINGMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tradingManager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tradingManager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tradingManager
% Last Modified by GUIDE v2.5 20-Dec-2012 14:38:46
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tradingManager_OpeningFcn, ...
                   'gui_OutputFcn',  @tradingManager_OutputFcn, ...
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


% --- Executes just before tradingManager is made visible.
function tradingManager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tradingManager (see VARARGIN)

    % Load the interface detail through the config and save it to the GUI
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
    

    % Read data, load it
    dataSelected = (get(handles.dataList, 'value'));
    dataName = handles.config.dataName(dataSelected);
    dataName = dataName{1};
    cd ..;
    handles.dataset = load( fullfile('Data', dataName) );
    cd GUI;
    handles.dataFrequency = handles.config.dataFrequency(dataSelected);
    
    % Display summary analysis on graph plots
    
    % Cumulative data for all stocks
    cumprodData = cumprod(handles.dataset.data);
    
    % The 4 basic algorithms - market b&h, uniform, best stock, worst stock
    [r c] = size(handles.dataset.data);
    
    % Market
    market = zeros(r,1);
    market_daily = zeros(r,1);
    initialValue = handles.dataset.data(1,:);
    for i = 1:1:r
        finalValue = cumprodData(i,:);
        change = finalValue./initialValue;
        market(i) = mean(change);
    end
    
    market_daily(1) = 1;
    for i = 2:1:r
        market_daily(i) = market(i)/market(i-1);
    end
    
    % Uniform
    uniform_daily = ((mean(handles.dataset.data,2 )));
    uniform = cumprod(uniform_daily);
    
    
    indexBest = 1; best = -1;
    for i = 1:1:c
        if cumprodData(r,i) > best
            indexBest = i;
            best = cumprodData(r,i);
        end
    end
    
    % Best
    best_daily = handles.dataset.data(:,indexBest);
    best = cumprod(best_daily); 
    
    % Performing BCRP
    opts.quiet_mode = 1; opts.display_interval = 500;
    opts.log_mode = 1; opts.mat_mode = 1;
    opts.analyze_mode = 1;
    opts.his = 0;
    addpath('../Strategy');
    strategy_fun = ['bcrp' '(1, handles.dataset.data, 0, opts)'];
    tc{1} = 0;
    [stats cumprod_ret daily_ret, daily_portfolio] = bcrp(1, handles.dataset.data, tc, opts);
    rmpath('../Strategy');
    bcrp_ret = cumprod_ret;
    bcrp_daily = daily_ret;
    
    
    % Now computing the performance of every stock with mean and standard
    % deviation of returns
    expected = (mean(handles.dataset.data) - 1)*252;
    deviation = std(handles.dataset.data)*sqrt(252);
     
    % Plottting the 3 graphs
    handles.benchmarks = [market uniform best bcrp_ret];
    handles.benchmarks_daily = [market_daily uniform_daily best_daily bcrp_daily];
    handles.expected =  expected;
    handles.deviation = deviation;
    handles.allStocks = cumprodData;
    
    plot(handles.graph1, handles.benchmarks);
    errorbar(handles.graph2, expected, deviation, 'xr');
    plot(handles.graph3,handles.allStocks);
    
    
    % Plotting the main graph
    plot(handles.mainGraph, handles.benchmarks);
    xlim(handles.mainGraph, [0 r+2]);
    legend(handles.mainGraph, 'Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP' ,'Location', 'Best');
    
    xlim(handles.graph1, [0 r+2]);
    xlim(handles.graph2, [0 c+1]);
    xlim(handles.graph3, [0 r+2]);
    
    set(handles.rd1,'Value', 1); 
    set(handles.rd2,'Value', 0); 
    set(handles.rd3,'Value', 0); 
    
    guidata(hObject, handles);
    
    guidata(hObject, handles);



% Choose default command line output for tradingManager
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tradingManager wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tradingManager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in dataset.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Read the parameters and start running the algorithm, and display the
    % results in a new GUI
    %______________________________________________________________________
    
    % Read the input parameters from the GUI    
    temp = get(handles.input1,'string');
    inputs{1} = [];
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
    
    % Error handling for erroneous inputs
    error = sum (cellfun(@(V) any(isnan(V(:))), inputs));
    if error > 0
        disp('Warning: Erroneous input detected');
        errorMessage('Erroneous input detected! Please verify the inputs.');
        return;
    end
    
    % Get detail about algorithm selected
    algoId = get(handles.algorithmList, 'Value');
    algorithmName = handles.config.algorithmName{algoId};    
    
    % Read the dataset on which the algo has to be run
    data = handles.dataset.data;
    
    
    % Using functions from other directories - the library
    addpath('./lib');
    addpath('../Strategy');

    % Run the algorithm in compatibility with Bin's format
    
    % Define the options
    opts.quiet_mode = 1; opts.display_interval = 500;
    opts.log_mode = 1; opts.mat_mode = 1;
    opts.analyze_mode = 1;
    opts.his = 0;
    opts.progress = 1;
    
    strategy_name = algorithmName;
    strategy_fun = [strategy_name '(1, data, inputs, opts)'];
    
    [stats cumprod_ret daily_ret, daily_portfolio] = eval(strategy_fun);
    
    % Remove path not needed anymore
    rmpath('./lib');
    rmpath('../Strategy');
    
    returns = daily_ret - 1;
    portfolio = daily_portfolio;
    
    chosenStrategy = handles.config.algorithmList{algoId};
    resultManager(returns, portfolio, stats, handles.benchmarks, handles.benchmarks_daily,chosenStrategy, handles.dataFrequency);
    %______________________________________________________________________

% --- Executes on selection change in dataList.
function dataList_Callback(hObject, eventdata, handles)
% hObject    handle to dataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataList

    % When data set is selected we want some summary analysis to be shown
    
    % Read data, load it
    dataSelected = (get(handles.dataList, 'value'));
    dataName = handles.config.dataName(dataSelected);
    dataName = dataName{1};
    handles.dataset = load( fullfile('../Data', dataName) );
    handles.dataFrequency = handles.config.dataFrequency(dataSelected);
    
    % Display summary analysis on graph plots
    
    % Cumulative data for all stocks
    cumprodData = cumprod(handles.dataset.data);
    
    % The 4 basic algorithms - market b&h, uniform, best stock, worst stock
    [r c] = size(handles.dataset.data);
    
    % Market
    market = zeros(r,1);
    market_daily = zeros(r,1);
    initialValue = handles.dataset.data(1,:);
    for i = 1:1:r
        finalValue = cumprodData(i,:);
        change = finalValue./initialValue;
        market(i) = mean(change);
    end
    
    market_daily(1) = 1;
    for i = 2:1:r
        market_daily(i) = market(i)/market(i-1);
    end
    
    % Uniform
    uniform_daily = ((mean(handles.dataset.data,2 )));
    uniform = cumprod(uniform_daily);
    
    
    indexBest = 1; best = -1;
    for i = 1:1:c
        if cumprodData(r,i) > best
            indexBest = i;
            best = cumprodData(r,i);
        end
    end
    
    % Best
    best_daily = handles.dataset.data(:,indexBest);
    best = cumprod(best_daily); 
    
    % Performing BCRP
    opts.quiet_mode = 1; opts.display_interval = 500;
    opts.log_mode = 1; opts.mat_mode = 1;
    opts.analyze_mode = 1;
    opts.his = 0;
    addpath('../Strategy');
    strategy_fun = ['bcrp' '(1, handles.dataset.data, 0, opts)'];
    tc{1} = 0;
    [stats cumprod_ret daily_ret, daily_portfolio] = bcrp(1, handles.dataset.data, tc, opts);
    rmpath('../Strategy');
    bcrp_ret = cumprod_ret;
    bcrp_daily = daily_ret;
    
    
    % Now computing the performance of every stock with mean and standard
    % deviation of returns
    expected = (mean(handles.dataset.data) - 1)*252;
    deviation = std(handles.dataset.data)*sqrt(252);
     
    % Plottting the 3 graphs
    handles.benchmarks = [market uniform best bcrp_ret];
    handles.benchmarks_daily = [market_daily uniform_daily best_daily bcrp_daily];
    handles.expected =  expected;
    handles.deviation = deviation;
    handles.allStocks = cumprodData;
    
    plot(handles.graph1, handles.benchmarks);
    errorbar(handles.graph2, expected, deviation, 'xr');
    plot(handles.graph3,handles.allStocks);
    
    
    % Plotting the main graph
    plot(handles.mainGraph, handles.benchmarks);
    xlim(handles.mainGraph, [0 r+2]);
    legend(handles.mainGraph, 'Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP' ,'Location', 'Best');
    
    
    xlim(handles.graph1, [0 r+2]);
    xlim(handles.graph2, [0 c+1]);
    xlim(handles.graph3, [0 r+2]);
    
    set(handles.rd1,'Value', 1); 
    set(handles.rd2,'Value', 0); 
    set(handles.rd3,'Value', 0); 
    
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


% --- Executes on selection change in dataList.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to dataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataList


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
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

% Update the Parameters required by algorithm based on the config

% Based on algorithm selected, get the  correct names of parameters and the
% default values from the config
    
    algorithmId = get(handles.algorithmList, 'value');
    parameters = handles.config.algorithmParameters(algorithmId,:);
    defaultParameters = handles.config.defaultParameters(algorithmId,:);
    emptyCells = cellfun(@isempty,parameters);
    parameters(emptyCells) = [];
    emptyCells = cellfun(@isempty,defaultParameters);
    defaultParameters(emptyCells) = [];
    
    % Update static text fields for input
    set(handles.in1,'String','N/A');set(handles.in2,'String','N/A');
    set(handles.in3,'String','N/A');set(handles.in4,'String','N/A');
    set(handles.in5,'String','N/A');set(handles.in6,'String','N/A');
    
    set(handles.input1,'String','-');set(handles.input2,'String','-');
    set(handles.input3,'String','-');set(handles.input4,'String','-');
    set(handles.input5,'String','-');set(handles.input6,'String','-');
    
    
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
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


% --- Executes on button press in rd1.
function rd1_Callback(hObject, eventdata, handles)
% hObject    handle to rd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd1

    rd1 = get(handles.rd1,'Value');
    if rd1 == 1
        set(handles.rd2,'Value', 0); 
        set(handles.rd3,'Value', 0); 
        % Plotting the main graph
        plot(handles.mainGraph, handles.benchmarks);
        [r c] = size(handles.dataset.data);
        xlim(handles.mainGraph, [0 r+2]);
        legend(handles.mainGraph, 'Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', 'Location', 'Best');
    end
   

% --- Executes on button press in rd2.
function rd2_Callback(hObject, eventdata, handles)
% hObject    handle to rd2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd2
    rd2 = get(handles.rd2,'Value');
    if rd2 == 1
        set(handles.rd1,'Value', 0); 
        set(handles.rd3,'Value', 0); 
        errorbar(handles.mainGraph, handles.expected, handles.deviation, 'xr');
        [r c] = size(handles.dataset.data);
        xlim(handles.mainGraph, [0 c+1]);
    end
    


% --- Executes on button press in rd3.
function rd3_Callback(hObject, eventdata, handles)
% hObject    handle to rd3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd3
    rd3 = get(handles.rd3,'Value');
    if rd3 == 1
        set(handles.rd1,'Value', 0); 
        set(handles.rd2,'Value', 0); 
        plot(handles.mainGraph,handles.allStocks);
        [r c] = size(handles.dataset.data);
        xlim(handles.mainGraph, [0 r+2]);
    end


% --- Executes on button press in bcrp_check.
function bcrp_check_Callback(hObject, eventdata, handles)
% hObject    handle to bcrp_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bcrp_check
