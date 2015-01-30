function varargout = resultManager2(varargin)
% RESULTMANAGER2 MATLAB code for resultManager2.fig
%      RESULTMANAGER2, by itself, creates a new RESULTMANAGER2 or raises the existing
%      singleton*.
%
%      H = RESULTMANAGER2 returns the handle to a new RESULTMANAGER2 or the handle to
%      the existing singleton*.
%
%      RESULTMANAGER2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTMANAGER2.M with the given input arguments.
%
%      RESULTMANAGER2('Property','Value',...) creates a new RESULTMANAGER2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resultManager2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resultManager2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resultManager2
% Last Modified by GUIDE v2.5 11-Jul-2013 01:16:29
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
                   'gui_OpeningFcn', @resultManager2_OpeningFcn, ...
                   'gui_OutputFcn',  @resultManager2_OutputFcn, ...
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


% --- Executes just before resultManager2 is made visible.
function resultManager2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resultManager2 (see VARARGIN)

    handles.returns_daily = varargin{1} - 1;
    handles.returns = cumprod(varargin{1});
    handles.portfolio = varargin{2};
    handles.selectedAlgorithms = varargin{3};
    handles.frequency = varargin{4};
    [handles.r handles.c] = size(handles.portfolio{1});
    rd_cumulativeReturns_Callback(hObject, eventdata, handles);
    
    
     % Compute the statsand display the important numbers in table using the
    % library functions
    addpath('./lib');
    
    
    cumReturns = handles.returns;
    dailyReturns = handles.returns_daily;
    
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
    handles.sharpeRatios = sharpe(dailyReturns, handles.finalValues, handles.frequency);
    
    % Get Sortino ratios
    handles.sortinoRatios = sortino(dailyReturns, 0);
    
    % Get Value risks at level 5%
    handles.valueAtRisks = var5(dailyReturns);
    
    % Get Maximum draw down
    handles.mdds = maxDD_general(cumReturns);
    
    % Get Calmar ratios
    handles.calmars = calmar(cumReturns, handles.mdds, handles.frequency);
    
    % Fill up the tables
    set(handles.table,'ColumnName',handles.selectedAlgorithms);
    tableData = [handles.finalValues; handles.meanReturns; handles.annualisedReturns; handles.standardDeviation; handles.annualisedStandardDeviation; handles.sharpeRatios; handles.calmars; handles.sortinoRatios; handles.valueAtRisks; handles.mdds];
    set(handles.table,'Data',tableData);
    
    rmpath('./lib');
    
    guidata(hObject, handles);



% Choose default command line output for resultManager2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resultManager2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resultManager2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function rd_sharpe_Callback(hObject, eventdata, handles)
% hObject    handle to rd_sharpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_sharpe
    clearRadio(hObject, eventdata, handles);
    set(handles.rd_sharpe,'Value', 1);
    
    window = str2double(get(handles.windowSharpe,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    sharpeRatios = zeros(r,c);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        sharpeRatios(i,:) = sharpe(handles.returns_daily(start:finish,:), handles.returns(finish,:)./handles.returns(start,:), handles.frequency);
    end
    
    rmpath('./lib');
     
    plot(handles.mainGraph, sharpeRatios);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend(handles.mainGraph , handles.selectedAlgorithms, 'Location', 'Best');

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

% Hint: get(hObject,'Value') returns toggle state of rd_calmar
    clearRadio(hObject, eventdata, handles);
    set(handles.rd_calmar,'Value', 1); 
    
    
    window = str2double(get(handles.windowCalmar,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    calmarRatios = zeros(r,c);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        mdd = maxDD_general(handles.returns(start:finish,:));
        calmarRatios(i,:) = calmar(handles.returns(start:finish,:), mdd,  handles.frequency);
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, calmarRatios);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend(handles.mainGraph , handles.selectedAlgorithms, 'Location', 'Best');
 
% --- Executes on button press in rd_var.
function rd_var_Callback(hObject, eventdata, handles)
% hObject    handle to rd_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_var
    clearRadio(hObject, eventdata, handles);
    set(handles.rd_var,'Value', 1); 
    
    window = str2double(get(handles.windowVar,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    vars = zeros(r,c);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        vars(i,:) = var5(handles.returns_daily(start:finish,:));
    end
    
    rmpath('./lib');
    plot(handles.mainGraph, vars);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend(handles.mainGraph , handles.selectedAlgorithms, 'Location', 'Best');
    

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

% Hint: get(hObject,'Value') returns toggle state of rd_mdd
    clearRadio(hObject, eventdata, handles);
    set(handles.rd_mdd,'Value', 1);
    
    window = str2double(get(handles.windowMDD,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    mdds = zeros(r,c);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        mdds(i,:) = maxDD_general(handles.returns(start:finish,:));
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, mdds);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend(handles.mainGraph , handles.selectedAlgorithms, 'Location', 'Best');

    
% --- Executes on button press in rd_sortino.
function rd_sortino_Callback(hObject, eventdata, handles)
% hObject    handle to rd_sortino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_sortino
    clearRadio(hObject, eventdata, handles);
    set(handles.rd_sortino,'Value', 1);
    
    window = str2double(get(handles.windowSortino,'string'));
    if isnan(window) || window < 2 
        errorMessage('Window size must be a number greater than or equal to 2');
        return;
    end
    window = round(window);
    addpath('./lib');
    
    [r c] = size(handles.returns_daily);
    sortinos = zeros(r,c);
    for i = 50:1:r
        start = max(i-window+1, 1);
        finish = i;
        sortinos(i,:) = sortino(handles.returns_daily(start:finish,:),0);
    end
    
    rmpath('./lib');
    
    plot(handles.mainGraph, sortinos);
    xlim(handles.mainGraph, [0 handles.r+1]);
    legend(handles.mainGraph , handles.selectedAlgorithms, 'Location', 'Best');


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


% --- Executes on button press in rd_cumulativeReturns.
function rd_cumulativeReturns_Callback(hObject, eventdata, handles)
% hObject    handle to rd_cumulativeReturns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_cumulativeReturns
    clearRadio(hObject, eventdata, handles);
    set(handles.rd_cumulativeReturns,'Value', 1); 
    if get(handles.logCheck,'Value') ~=1
        plot(handles.mainGraph, handles.returns);
        xlim(handles.mainGraph, [0 handles.r+1]);
        legend(handles.mainGraph , handles.selectedAlgorithms, 'Location', 'Best');
        grid on;
    else
        logCheck_Callback(hObject, eventdata, handles);
    end
    
    
% --- Executes on button press in logCheck.
function logCheck_Callback(hObject, eventdata, handles)
% hObject    handle to logCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logCheck
    
    % Check if user wants to see cumulative returns
    selected  = get(handles.rd_cumulativeReturns,'Value');
    
    % only if user wants to see the cumulative returns
    if selected == 1
        logPlot = get(handles.logCheck,'Value');
        
        if logPlot == 1
            semilogy(handles.returns);
        else
            plot(handles.returns);
        end 
        xlim(handles.mainGraph, [0 handles.r+1]);
        legend(handles.mainGraph , handles.selectedAlgorithms, 'Location', 'Best');
        grid on;
    end


function clearRadio(hObject, eventdata, handles)
% The function is a helper function to uncheck all radio buttons

    set(handles.rd_cumulativeReturns,'Value', 0); 
    set(handles.rd_sharpe,'Value', 0); 
    set(handles.rd_calmar,'Value', 0); 
    set(handles.rd_sortino,'Value', 0); 
    set(handles.rd_var,'Value', 0); 
    set(handles.rd_mdd,'Value', 0); 


% --- Executes on button press in dailyReturnsButton.
function dailyReturnsButton_Callback(hObject, eventdata, handles)
% hObject    handle to dailyReturnsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    first = str2double(get(handles.dailyStart,'string'));
    last = str2double(get(handles.dailyEnd,'string'));
    
    if isnan(first) || isnan(last) || first < 1 || last - first < 1
        errorMessage('Error in entering start and end days. End day must be greater than start day. Start day must be positive integer.');
        return;
    end
    first = round(first);
    last = round(last);
    
    [r c] = size(handles.returns_daily);
    last = min(last,r);
    bar(handles.mainGraph, handles.returns_daily(first:last,:));
    xlim([0 last-first+2]);
    legend(handles.mainGraph,handles.selectedAlgorithms, 'Location', 'Best');


% --- Executes on button press in portfolioAllocationButton.
function portfolioAllocationButton_Callback(hObject, eventdata, handles)
% hObject    handle to portfolioAllocationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    first = str2double(get(handles.portfolioStart,'string'));
    last = str2double(get(handles.portfolioEnd,'string'));
    
    if isnan(first) || isnan(last) || first < 1 || last - first < 1
        errorMessage('Error in entering start and end days. End day must be greater than start day. Start day must be positive integer.');
        return;
    end
    first = round(first);
    last = round(last);
    
    [r c] = size(handles.portfolio{1});
    last = min(last,r);
    
    % Number of algorithms 
    [tmp n] = size(handles.portfolio);
    for i = 1:1:n
        portfolio = handles.portfolio{i};
        portfolio = portfolio(first:last,:);
        expected(:,i) = mean(portfolio)';
        deviation(:,i) = std(portfolio)';
    end
    errorbar(handles.mainGraph, expected, deviation,'x');
    xlim([0 c+1]);
    minMean = min(min(expected));
    maxMean = max(max(expected));
    maxDev = max(max(deviation));
    legend(handles.mainGraph, handles.selectedAlgorithms, 'Location', 'Best');

function portfolioStart_Callback(hObject, eventdata, handles)
% hObject    handle to portfolioStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of portfolioStart as text
%        str2double(get(hObject,'String')) returns contents of portfolioStart as a double


% --- Executes during object creation, after setting all properties.
function portfolioStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portfolioStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function portfolioEnd_Callback(hObject, eventdata, handles)
% hObject    handle to portfolioEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of portfolioEnd as text
%        str2double(get(hObject,'String')) returns contents of portfolioEnd as a double


% --- Executes during object creation, after setting all properties.
function portfolioEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portfolioEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dailyStart_Callback(hObject, eventdata, handles)
% hObject    handle to dailyStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dailyStart as text
%        str2double(get(hObject,'String')) returns contents of dailyStart as a double


% --- Executes during object creation, after setting all properties.
function dailyStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dailyStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dailyEnd_Callback(hObject, eventdata, handles)
% hObject    handle to dailyEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dailyEnd as text
%        str2double(get(hObject,'String')) returns contents of dailyEnd as a double


% --- Executes during object creation, after setting all properties.
function dailyEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dailyEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
