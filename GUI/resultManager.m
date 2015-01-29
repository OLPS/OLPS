function varargout = resultManager(varargin)
% RESULTMANAGER MATLAB code for resultManager.fig
%      RESULTMANAGER, by itself, creates a new RESULTMANAGER or raises the existing
%      singleton*.
%
%      H = RESULTMANAGER returns the handle to a new RESULTMANAGER or the handle to
%      the existing singleton*.
%
%      RESULTMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTMANAGER.M with the given input arguments.
%
%      RESULTMANAGER('Property','Value',...) creates a new RESULTMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resultManager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resultManager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resultManager

% Last Modified by GUIDE v2.5 13-Jul-2013 16:20:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resultManager_OpeningFcn, ...
                   'gui_OutputFcn',  @resultManager_OutputFcn, ...
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


% --- Executes just before resultManager is made visible.
function resultManager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resultManager (see VARARGIN)
    
    % Read the 6 parameters
    handles.returns_daily = varargin{1};
    handles.returns = cumprod(handles.returns_daily+1 );
    handles.portfolio = varargin{2};
    handles.stats = varargin{3};
    handles.benchmarks = varargin{4};
    handles.benchmarks_daily = varargin{5}-1;
    handles.algorithmName = varargin{6};
    handles.frequency = varargin{7};
    [handles.r handles.c] = size(handles.portfolio);
    
    
    % Clear old values
    clearRadio(handles, [] , handles);
    set(handles.day,'String', 1);
    
    
    % Initial display
    cumReturns = [handles.benchmarks handles.returns];
    dailyReturns = [handles.benchmarks_daily handles.returns_daily];
    set(handles.rd_cumulativeReturns,'Value', 1); 
	plot(handles.mainGraph, cumReturns);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend(handles.mainGraph, 'Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', handles.algorithmName, 'Location', 'Best');
    grid on;
    
    

    % Compute the statsand display the important numbers in table using the
    % library functions
    addpath('./lib');
    
    % Get final Values
    [r c] = size(cumReturns);
    handles.finalValues = cumReturns(r,:);
    
    % Get the mean returnfor every day - This is a simple average
    handles.meanReturns = mean(dailyReturns);
    
    % Get annualised returns
    denominator = 252/handles.frequency;
    Y = r/denominator;
    handles.annualisedReturns = handles.finalValues.^(1/Y)-1;
    
    % Get standard deviation- a measureof risk
    handles.standardDeviation = std(dailyReturns);
    
    % Get annualised standard deviation
    handles.annualisedStandardDeviation = handles.standardDeviation * sqrt(denominator);
    
    % Get sharpe ratios
    handles.sharpeRatios = sharpe(dailyReturns, handles.finalValues,handles.frequency);
    
    % Get Sortino ratios                                                   %%%%%%%%%%%%%%% DO NOT KNOW HOW TO ANNUALIZE
    handles.sortinoRatios = sortino(dailyReturns, 0);
    
    % Get Value risks at level 5%
    handles.valueAtRisks = var5(dailyReturns);
    
    % Get Maximum draw down
    handles.mdds = maxDD_general(cumReturns);
    
    % Get Calmar ratios
    handles.calmars = calmar(cumReturns, handles.mdds, handles.frequency);
    
    
    % Fill up the tables
    tableData = [handles.finalValues; handles.meanReturns; handles.annualisedReturns; handles.standardDeviation; handles.annualisedStandardDeviation; handles.sharpeRatios; handles.calmars; handles.sortinoRatios; handles.valueAtRisks; handles.mdds];
    set(handles.table,'Data',tableData);
    
    rmpath('./lib');
    
    guidata(hObject, handles);



% Choose default command line output for resultManager
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resultManager wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resultManager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in watchAnimation.
function watchAnimation_Callback(hObject, eventdata, handles)
% hObject    handle to watchAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    window =  str2double(get(handles.windowAnimation,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);

    try
        animation(handles.portfolio, window);
    catch exception
        disp('Animation closed before completion');
    end

function windowAnimation_Callback(hObject, eventdata, handles)
% hObject    handle to windowAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowAnimation as text
%        str2double(get(hObject,'String')) returns contents of windowAnimation as a double


% --- Executes during object creation, after setting all properties.
function windowAnimation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_portfolioConcentration.
function rd_portfolioConcentration_Callback(hObject, eventdata, handles)
% hObject    handle to rd_portfolioConcentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    clearRadio(handles, [] , handles);
    set(handles.rd_portfolioConcentration,'Value', 1);
    
    portfolio = handles.portfolio;
    expected = mean(portfolio);
    deviation = std(portfolio);
    
    errorbar(handles.mainGraph, expected, deviation, 'xr');
    
    xlim(handles.mainGraph, [0 handles.c+1]);
    
% Hint: get(hObject,'Value') returns toggle state of rd_portfolioConcentration


% --- Executes on button press in rd_stepByStep.
function rd_stepByStep_Callback(hObject, eventdata, handles)
% hObject    handle to rd_stepByStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_stepByStep,'Value', 1);
    [r c] = size(handles.portfolio);
    bar(handles.portfolio(1,:));
    set(handles.day,'String', 1);
    xlim(handles.mainGraph, [0 handles.c+1]);
    ylim(handles.mainGraph, [-0.1 1.1]);
    grid on;
% Hint: get(hObject,'Value') returns toggle state of rd_stepByStep


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [r c] = size(handles.portfolio);
    day = str2double(get(handles.day,'string'));
    if get(handles.rd_stepByStep,'Value') == 1 && day <= r && (day-1) >= 1
        bar(handles.portfolio(day-1,:));
        set(handles.day,'String', (day-1));
        xlim(handles.mainGraph, [0 handles.c+1]);
        ylim(handles.mainGraph, [-0.1 1.1]);
        grid on;
    end

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [r c] = size(handles.portfolio);
    day = str2double(get(handles.day,'string'));
    if get(handles.rd_stepByStep,'Value') == 1 && day >= 1 && (day+1) <= r
        bar(handles.portfolio(day+1,:));
        set(handles.day,'String', (day+1));
        xlim(handles.mainGraph, [0 handles.c+1]);
        ylim(handles.mainGraph, [-0.1 1.1]);
        grid on;
    end

% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Reads the day number in the inputbox and changes barchart to
    % represent that day - 2 conditions - day must lie in range, step by
    % step is selected
    [r c] = size(handles.portfolio);
    day = str2double(get(handles.day,'string'));
    if get(handles.rd_stepByStep,'Value') == 1 && day >= 1 && day <= r
        bar(handles.portfolio(day,:));
        xlim(handles.mainGraph, [0 handles.c+1]);
        ylim(handles.mainGraph, [-0.1 1.1]);
        grid on;
    end
    
    
% Hint: get(hObject,'Value') returns toggle state of rd_animation


% --- Executes on button press in rd_sharpe.
function rd_sharpe_Callback(hObject, eventdata, handles)
% hObject    handle to rd_sharpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_sharpe,'Value', 1);
    
    window = str2double(get(handles.windowSharpe,'string'));
    
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    sharpeRatios = zeros(r,1);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        sharpeRatios(i) = sharpe(handles.returns_daily(start:finish), handles.returns(finish)/handles.returns(start), handles.frequency);
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, sharpeRatios);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend('Sharpe Ratio', 'Location', 'Best');
    
    
    
    
% Hint: get(hObject,'Value') returns toggle state of rd_sharpe



function windowSharpe_Callback(hObject, eventdata, handles)
% hObject    handle to windowSharpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowSharpe as text
%        str2double(get(hObject,'String')) returns contents of windowSharpe as a double


% --- Executes during object creation, after setting all properties.
function windowSharpe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSharpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_calmar.
function rd_calmar_Callback(hObject, eventdata, handles)
% hObject    handle to rd_calmar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_calmar,'Value', 1);
    
    window = str2double(get(handles.windowCalmar,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    calmarRatios = zeros(r,1);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        mdd = maxDD(handles.returns(start:finish));
        calmarRatios(i) = calmar(handles.returns(start:finish), mdd, handles.frequency);
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, calmarRatios);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend('Calmar Ratio', 'Location', 'Best');
    
    
    
    
    
% Hint: get(hObject,'Value') returns toggle state of rd_calmar


% --- Executes on button press in rd_var.
function rd_var_Callback(hObject, eventdata, handles)
% hObject    handle to rd_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_var,'Value', 1);
    
    window = str2double(get(handles.windowVar,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    vars = zeros(r,1);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        vars(i) = var5(handles.returns_daily(start:finish));
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, vars);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend('Value At Risk 5%', 'Location', 'Best');
    
% Hint: get(hObject,'Value') returns toggle state of rd_var



function windowCalmar_Callback(hObject, eventdata, handles)
% hObject    handle to windowCalmar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowCalmar as text
%        str2double(get(hObject,'String')) returns contents of windowCalmar as a double


% --- Executes during object creation, after setting all properties.
function windowCalmar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowCalmar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_mdd.
function rd_mdd_Callback(hObject, eventdata, handles)
% hObject    handle to rd_mdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_mdd,'Value', 1);
    
    window = str2double(get(handles.windowMDD,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    mdds = zeros(r,1);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        mdds(i) = maxDD(handles.returns(start:finish));
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, mdds);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend('Maximum Draw Down', 'Location', 'Best');
    
    
    
% Hint: get(hObject,'Value') returns toggle state of rd_mdd


% --- Executes on button press in rd_sortino.
function rd_sortino_Callback(hObject, eventdata, handles)
% hObject    handle to rd_sortino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_sortino,'Value', 1);
    
    window = str2double(get(handles.windowSortino,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    sortinos = zeros(r,1);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        sortinos(i) = sortino(handles.returns_daily(start:finish),0);
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, sortinos);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend('Sortino Ratio', 'Location', 'Best');
    
% Hint: get(hObject,'Value') returns toggle state of rd_sortino



function windowSortino_Callback(hObject, eventdata, handles)
% hObject    handle to windowSortino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowSortino as text
%        str2double(get(hObject,'String')) returns contents of windowSortino as a double


% --- Executes during object creation, after setting all properties.
function windowSortino_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSortino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_cumulativeReturns.
function rd_cumulativeReturns_Callback(hObject, eventdata, handles)
% hObject    handle to rd_cumulativeReturns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_cumulativeReturns,'Value', 1);
    logCheck = get(handles.logPlot, 'Value');
    if logCheck == 1
        semilogy([ handles.benchmarks handles.returns]);
    else
        plot([ handles.benchmarks handles.returns]);
    end
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend(handles.mainGraph ,'Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', handles.algorithmName, 'Location', 'Best');
    grid on;
% Hint: get(hObject,'Value') returns toggle state of rd_cumulativeReturns


% --- Executes on button press in rd_dailyReturns.
function rd_dailyReturns_Callback(hObject, eventdata, handles)
% hObject    handle to rd_dailyReturns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clearRadio(handles, [] , handles);
    set(handles.rd_dailyReturns,'Value', 1);
    bar(handles.mainGraph, handles.returns_daily);
    xlim(handles.mainGraph, [0 handles.r+1]);
% Hint: get(hObject,'Value') returns toggle state of rd_dailyReturns


function clearRadio(hObject, eventdata, handles)
% The function is a helper function to uncheck all radio buttons

    set(handles.rd_cumulativeReturns,'Value', 0); 
    set(handles.rd_dailyReturns,'Value', 0); 
    set(handles.rd_sharpe,'Value', 0); 
    set(handles.rd_calmar,'Value', 0); 
    set(handles.rd_sortino,'Value', 0); 
    set(handles.rd_var,'Value', 0); 
    set(handles.rd_mdd,'Value', 0); 
    set(handles.rd_portfolioConcentration,'Value', 0); 
    set(handles.rd_stepByStep,'Value', 0); 
    



function day_Callback(hObject, eventdata, handles)
% hObject    handle to day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of day as text
%        str2double(get(hObject,'String')) returns contents of day as a double


% --- Executes during object creation, after setting all properties.
function day_CreateFcn(hObject, eventdata, handles)
% hObject    handle to day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in logPlot.
function logPlot_Callback(hObject, eventdata, handles)
% hObject    handle to logPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logPlot

    % Check if user wants to see cumulative returns
    selected  = get(handles.rd_cumulativeReturns,'Value');
    
    % only if user wants to see the cumulative returns
    if selected == 1
        logCheck = get(handles.logPlot,'Value');
        
        if logCheck == 1
            semilogy([ handles.benchmarks handles.returns]);
        else
            plot([ handles.benchmarks handles.returns]);
        end
        xlim(handles.mainGraph, [0 handles.r+1]);
        legend(handles.mainGraph ,'Uniform BAH', 'Uniform CRP', 'Best Stock', 'Best CRP', handles.algorithmName, 'Location', 'Best');
        grid on;
    end



function windowVar_Callback(hObject, eventdata, handles)
% hObject    handle to windowVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowVar as text
%        str2double(get(hObject,'String')) returns contents of windowVar as a double


% --- Executes during object creation, after setting all properties.
function windowVar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowMDD_Callback(hObject, eventdata, handles)
% hObject    handle to windowMDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowMDD as text
%        str2double(get(hObject,'String')) returns contents of windowMDD as a double


% --- Executes during object creation, after setting all properties.
function windowMDD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowMDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
