function varargout = MatMapperGUIDE(varargin)
% MATMAPPERGUIDE MATLAB code for MatMapperGUIDE.fig
%      MATMAPPERGUIDE, by itself, creates a new MATMAPPERGUIDE or raises the existing
%      singleton*.
%
%      H = MATMAPPERGUIDE returns the handle to a new MATMAPPERGUIDE or the handle to
%      the existing singleton*.
%
%      MATMAPPERGUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATMAPPERGUIDE.M with the given input arguments.
%
%      MATMAPPERGUIDE('Property','Value',...) creates a new MATMAPPERGUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MatMapperGUIDE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MatMapperGUIDE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MatMapperGUIDE

% Last Modified by GUIDE v2.5 02-Oct-2019 11:57:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MatMapperGUIDE_OpeningFcn, ...
    'gui_OutputFcn',  @MatMapperGUIDE_OutputFcn, ...
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


% --- Executes just before MatMapperGUIDE is made visible.
function MatMapperGUIDE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MatMapperGUIDE (see VARARGIN)



%Initialise filter map.
assignin('base','filterMap',containers.Map);

assignin('base','newDataCall',@newDataCall2);

assignin('base','scalenode',0);

assignin('base','G',[]);

%Assign handles in base.
assignin('base','handles',handles);

%Set selHigh to 0 (this holds the plot of highlighted nodes)
assignin('base','selHigh',0);

%Set clusterSettingsTable rows and column names to nonexistent.
handles.clusterSettingsTable.RowName = [];
handles.clusterSettingsTable.ColumnName = [];




a = dir('Generators');
fnlocs = cell(length(a)-2,1);
fnnames = cell(length(a)-2,1);
for i=3:length(a)
    fnlocs{i-2} = [a(i).folder, '\', a(i).name];
    fnnames{i-2} = a(i).name(1:end-2);
end
handles.loadExampleData.String = fnnames;



% Choose default command line output for MatMapperGUIDE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MatMapperGUIDE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MatMapperGUIDE_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in clusterMethod.
function clusterMethod_Callback(hObject, eventdata, handles)
% hObject    handle to clusterMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
val = contents{get(hObject,'Value')};
if(strcmp(val,'None'))
    %disable distanceMethod box, since it doesn't matter.
    handles.distanceMethod.Enable = 'inactive';
    handles.distanceMethod.String = {};
    handles.clusterSettingsTable.Data = {};
    handles.clusteringAxes.Enable = 'inactive';
    handles.clusterSettingsTable.Enable = 'inactive';
    handles.text9.Enable = 'inactive';
    handles.text10.Enable = 'inactive';
    handles.text11.Enable = 'inactive';
else
    %enable distanceMethod box.
    handles.distanceMethod.Enable = 'on';
    handles.clusteringAxes.Enable = 'on';
    handles.clusterSettingsTable.Enable = 'on';
    handles.text9.Enable = 'on';
    handles.text10.Enable = 'on';
    handles.text11.Enable = 'on';
end

if(strcmp(val,'k-means'))
    %use k-means clustering.
    
    %set distanceMethod box to have options possible with k-means
    handles.distanceMethod.String = {'Squared Euclidean','Cityblock','Cosine','Correlation','Hamming'};
    handles.distanceMethod.Value = 1;
    
    %Set options such as which dimensions should be measured along
    
    
    %Allow definition of k, MaxIterations in clusterSettingsTable
    handles.clusterSettingsTable.Data = {'k',4;'MaxIterations',100};
    handles.clusterSettingsTable.ColumnEditable = [false,true];
    
    
elseif(strcmp(val,'Hierarchical'))
    handles.distanceMethod.String = {'Euclidean','Squared Euclidean','Standardised Euclidean','Mahalanobis','Cityblock','Minkowski','Chebychev','Cosine','Correlation','Hamming','Jaccard','Spearman','Custom...'};
    handles.distanceMethod.Value = 1;
    
    
    handles.clusterSettingsTable.Data = {'Criterion','distance';'Cutoff',0.1;'Linkage','single';'MaxClust',[]};
    %{'average','centroid','complete','median','single','ward','weighted'}
    
    
elseif(strcmp(val,'Custom...'))
    handles.distanceMethod.String = {};
    handles.distanceMethod.Value = [];

end


% Hints: contents = cellstr(get(hObject,'String')) returns clusterMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from clusterMethod


% --- Executes during object creation, after setting all properties.
function clusterMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clusterMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


handles.distanceMethod.Enable = 'inactive';
handles.distanceMethod.String = {};
handles.clusterSettingsTable.Data = {};
handles.clusteringAxes.Enable = 'inactive';
handles.clusterSettingsTable.Enable = 'inactive';
handles.text9.Enable = 'inactive';
handles.text10.Enable = 'inactive';
handles.text11.Enable = 'inactive';


% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in distanceMethod.
function distanceMethod_Callback(hObject, eventdata, handles)
% hObject    handle to distanceMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns distanceMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distanceMethod


% --- Executes during object creation, after setting all properties.
function distanceMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ambientTurn.
function ambientTurn_Callback(hObject, eventdata, handles)
% hObject    handle to ambientTurn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ambientTurn


% --- Executes on selection change in selectedFilters.
function selectedFilters_Callback(hObject, eventdata, handles)
% hObject    handle to selectedFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.CoveragePlot);
%None selected:
if(isempty(hObject.Value))
    
    handles.resolutionSlider.Enable = 'off';
    handles.resolutionTextbox.Enable = 'off';
    handles.overlapSlider.Enable = 'off';
    handles.overlapTextbox.Enable = 'off';
    return
end

%Determine if 1, 2, or more are selected.
%If 1 selected, figure out column in data that we want (or transformation
%on original data).


contents = cellstr(get(hObject,'String'));
selected = contents{get(hObject,'Value')};


if(length(get(hObject,'Value'))==1)
    %1 selected.
    
    %Enable sliders.
    handles.resolutionSlider.Enable = 'on';
    handles.resolutionTextbox.Enable = 'on';
    handles.overlapSlider.Enable = 'on';
    handles.overlapTextbox.Enable = 'on';
    
    %Get values for resolution and overlap or, if they do not exist, init.
    
    filterMap = evalin('base','filterMap');
    if(isKey(filterMap,selected))
        params = filterMap(selected);
        
        %TODO: Add check that params values are valid (eg 0<overlap<1).
        
        handles.resolutionSlider.Value = params(1);
        handles.resolutionTextbox.String = num2str(params(1));
        handles.overlapSlider.Value = params(2);
        handles.overlapTextbox.String = num2str(params(2));
    else
        filterMap(selected) = [10,0.5];
        handles.resolutionSlider.Value = 10;
        handles.resolutionTextbox.String = '10';
        handles.overlapSlider.Value = 0.5;
        handles.overlapTextbox.String = '0.5';
        assignin('base','filterMap',filterMap);
    end
    
    
    
    
    %
    
    %If the columns are numbered, then get the String and only keep number at
    %end.
    if(strcmp(handles.loadedData.ColumnName,'numbered'))
        if(strncmp(selected,'Column ',7))
            %If string starts with 'Column ', get number as number.
            %Data is stored as cell array so convert to numerical array.
            wantedData = cell2mat(handles.loadedData.Data(:,str2num(selected(8:end))));
        end
    else
        %If columns are named in table, use that.
        wantedData = cell2mat(handles.loadedData.Data(:,strcmp(handles.loadedData.ColumnName,selected)));
    end
    
    
    %If columns are named, lookup name and grab that column.
    %handles.loadedData.Data
    
    %disp(wantedData);
    h = histogram(handles.CoveragePlot,wantedData,handles.resolutionSlider.Value,'BinLimits',[min(wantedData),max(wantedData)]);
    axis(handles.CoveragePlot,'tight');
    
    
elseif(length(get(hObject,'Value'))==2)
    %2 selected simultaneously
    
    %Disable sliders.
    handles.resolutionSlider.Enable = 'off';
    handles.resolutionTextbox.Enable = 'off';
    handles.overlapSlider.Enable = 'off';
    handles.overlapTextbox.Enable = 'off';
    
    %Show multidimensional histogram using selected resolution values.
    
    filterMap = evalin('base','filterMap');
    nbins = ones(1,2);
    if(isKey(filterMap,contents{hObject.Value(1)}))
        params = filterMap(contents{hObject.Value(1)});
        nbins(1) = params(1);
    else
        nbins(1) = 10;
    end
    
    if(isKey(filterMap,contents{hObject.Value(2)}))
        params = filterMap(contents{hObject.Value(2)});
        nbins(2) = params(1);
    else
        nbins(2) = 10;
    end
    
    
    if(strcmp(handles.loadedData.ColumnName,'numbered'))
        if(strncmp(contents{hObject.Value(1)},'Column ',7))
            %If string starts with 'Column ', get number as number.
            %Data is stored as cell array so convert to numerical array.
            wantedData1 = cell2mat(handles.loadedData.Data(:,str2num(contents{hObject.Value(1)}(8:end))));
        end
    else
        %If columns are named in table, use that.
        wantedData1 = cell2mat(handles.loadedData.Data(:,strcmp(handles.loadedData.ColumnName,contents{hObject.Value(1)})));
    end
    
    if(strcmp(handles.loadedData.ColumnName,'numbered'))
        if(strncmp(contents{hObject.Value(1)},'Column ',7))
            %If string starts with 'Column ', get number as number.
            %Data is stored as cell array so convert to numerical array.
            wantedData2 = cell2mat(handles.loadedData.Data(:,str2num(contents{hObject.Value(2)}(8:end))));
        end
    else
        %If columns are named in table, use that.
        wantedData2 = cell2mat(handles.loadedData.Data(:,strcmp(handles.loadedData.ColumnName,contents{hObject.Value(2)})));
    end
    
    
    X = [wantedData1,wantedData2];
    hist3Edit(handles.CoveragePlot,X,nbins,'CdataMode','auto')
    xlabel(handles.CoveragePlot,contents{hObject.Value(1)})
    ylabel(handles.CoveragePlot,contents{hObject.Value(2)})
    colorbar(handles.CoveragePlot)
    view(handles.CoveragePlot,2)
    axis(handles.CoveragePlot,'tight');
    
else
    %More than 2 (or 0) selected simultaneously.
    %Clear coverage plot, disable sliders.
    cla(handles.CoveragePlot);
    
    %Disable sliders.
    handles.resolutionSlider.Enable = 'off';
    handles.resolutionTextbox.Enable = 'off';
    handles.overlapSlider.Enable = 'off';
    handles.overlapTextbox.Enable = 'off';
end

%drawOverlappingHistogram(handles.CoveragePlot,wantedData,nbins,overlap);


% Hints: contents = cellstr(get(hObject,'String')) returns selectedFilters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedFilters


% --- Executes during object creation, after setting all properties.
function selectedFilters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectedFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function resolutionSlider_Callback(hObject, eventdata, handles)
% hObject    handle to resolutionSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'Value',round(get(hObject,'Value')));
handles.resolutionTextbox.String = num2str(get(hObject,'Value'));


contents = cellstr(get(handles.selectedFilters,'String'));
selected = contents{get(handles.selectedFilters,'Value')};
filterMap = evalin('base','filterMap');
params = filterMap(selected);
params(1) = hObject.Value;
filterMap(selected) = params;
assignin('base','filterMap',filterMap);

if(isa(handles.CoveragePlot.Children,'matlab.graphics.chart.primitive.Histogram'))
    handles.CoveragePlot.Children.NumBins = get(hObject,'Value');
end


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function resolutionSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolutionSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function resolutionTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to resolutionTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = round(str2double(get(hObject,'String')));

if(isnan(val)||length(val)~=1||val<=1)
    handles.resolutionTextbox.String = num2str(handles.resolutionSlider.Value);
else
    hObject.String = num2str(val);
    handles.resolutionSlider.Value = max(min(val,handles.resolutionSlider.Max),handles.resolutionSlider.Min);
    
    contents = cellstr(get(handles.selectedFilters,'String'));
    selected = contents{get(handles.selectedFilters,'Value')};
    filterMap = evalin('base','filterMap');
    params = filterMap(selected);
    params(1) = str2double(hObject.String);
    filterMap(selected) = params;
    assignin('base','filterMap',filterMap);
    
    
    if(isa(handles.CoveragePlot.Children,'matlab.graphics.chart.primitive.Histogram'))
        handles.CoveragePlot.Children.NumBins = val;
    end
end



% Hints: get(hObject,'String') returns contents of resolutionTextbox as text
%        str2double(get(hObject,'String')) returns contents of resolutionTextbox as a double


% --- Executes during object creation, after setting all properties.
function resolutionTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolutionTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function overlapSlider_Callback(hObject, eventdata, handles)
% hObject    handle to overlapSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%set(hObject,'Value',round(get(hObject,'Value')));
handles.overlapTextbox.String = num2str(get(hObject,'Value'),3);


contents = cellstr(get(handles.selectedFilters,'String'));
selected = contents{get(handles.selectedFilters,'Value')};
filterMap = evalin('base','filterMap');
params = filterMap(selected);
params(2) = hObject.Value;
filterMap(selected) = params;
assignin('base','filterMap',filterMap);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function overlapSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlapSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function overlapTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to overlapTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = str2double(get(hObject,'String'));

if(isnan(val)||length(val)~=1||val<=0||val>=1)
    handles.overlapTextbox.String = num2str(handles.overlapSlider.Value,3);
else
    hObject.String = num2str(val);
    handles.overlapSlider.Value = max(min(val,handles.overlapSlider.Max),handles.overlapSlider.Min);
    
    contents = cellstr(get(handles.selectedFilters,'String'));
    selected = contents{get(handles.selectedFilters,'Value')};
    filterMap = evalin('base','filterMap');
    params = filterMap(selected);
    params(2) = str2double(hObject.String);
    filterMap(selected) = params;
    assignin('base','filterMap',filterMap);
    
    
    if(isa(handles.CoveragePlot.Children,'matlab.graphics.chart.primitive.Histogram'))
        handles.CoveragePlot.Children.NumBins = val;
    end
end



% Hints: get(hObject,'String') returns contents of overlapTextbox as text
%        str2double(get(hObject,'String')) returns contents of overlapTextbox as a double


% --- Executes during object creation, after setting all properties.
function overlapTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlapTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filterListbox.
function filterListbox_Callback(hObject, eventdata, handles)
% hObject    handle to filterListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp(get(hObject,'Value'));
contents = cellstr(get(hObject,'String'));

%Ensure that the existing selected filter settings remain the same
curSel = cellstr(get(handles.selectedFilters,'String'));
curSel = curSel(handles.selectedFilters.Value);

tot = zeros(size(contents(get(hObject,'Value'))));

for i=1:length(curSel)
    tot = tot + strcmp(curSel(i),contents(get(hObject,'Value')));
end

%disp(find(tot));

%disp(strcmp(curSel,contents(get(hObject,'Value'))));

if(isempty(tot))
    cla(handles.CoveragePlot);
    handles.resolutionTextbox.Enable='off';
    handles.resolutionSlider.Enable='off';
    handles.overlapSlider.Enable='off';
    handles.overlapTextbox.Enable='off';
else
    handles.resolutionTextbox.Enable='on';
    handles.resolutionSlider.Enable='on';
    handles.overlapSlider.Enable='on';
    handles.overlapTextbox.Enable='on';
end

handles.selectedFilters.Value = find(tot);
if(isempty(handles.selectedFilters.Value))
    cla(handles.CoveragePlot);
    handles.resolutionTextbox.Enable='off';
    handles.resolutionSlider.Enable='off';
    handles.overlapSlider.Enable='off';
    handles.overlapTextbox.Enable='off';
end
handles.selectedFilters.String = contents(get(hObject,'Value'));

% Hints: contents = cellstr(get(hObject,'String')) returns filterListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterListbox


% --- Executes during object creation, after setting all properties.
function filterListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addCustomFilter.
function addCustomFilter_Callback(hObject, eventdata, handles)
% hObject    handle to addCustomFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','LoadedData',handles.loadedData.Data);
assignin('base','ExistingFilters',handles.filterListbox.String);
newFilter = CreateNewFilter();
%Modal locks out other GUI elements until filter has been defined.
%newFilter.WindowStyle = 'modal';


%Create custom filter popup.
%A custom filter must take the point cloud as an input and export a real
%valued number for each point.


% --- Executes on button press in saveFileButton.
function saveFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveWorkspaceButton.
function saveWorkspaceButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveWorkspaceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter name for saving:'};
title = 'Saving to Workspace';
dims = [1 35];
definput = {'Data'};

answer = inputdlg(prompt,title,dims,definput);
%If the columns have names, carry them over.
if(strcmp(handles.loadedData.ColumnName,'numbered'))
    assignin('base',answer{1},handles.loadedData.Data);
else
    assignin('base',answer{1},cell2table(handles.loadedData.Data,'VariableNames',handles.loadedData.ColumnName));
end
%Then apply cell2mat to perform operations




% --- Executes on button press in loadFileButton.
function loadFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function y = isnotobject(x)
y = ~isobject(x);

% --- Executes on button press in loadWorkspaceButton.
function loadWorkspaceButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadWorkspaceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[tvar, tvarnames] = uigetvariables({'Please select the data to import.'},'ValidationFcn',@isnotobject);

%Check if empty.
%disp(1);
oldColumnNames = handles.loadedData.ColumnName;

%If a table, rename columns.
if(isa(tvar{1},'table'))
    handles.loadedData.ColumnName = tvar{1}.Properties.VariableNames;
    handles.loadedData.Data = table2cell(tvar{1});
elseif(isa(tvar{1},'cell'))
    handles.loadedData.ColumnName = 'numbered';
    handles.loadedData.Data = tvar{1};
else
    handles.loadedData.ColumnName = 'numbered';
    handles.loadedData.Data = num2cell(tvar{1});
end

newDataCall(hObject, eventdata, handles,oldColumnNames);


function newDataCall2(handles)
newDataCall([], [], handles, []);


function newDataCall(hObject, eventdata, handles, oldColumnNames)
%If a matrix, set column names to be numbered.

%Add rows to Filters and Select Axes.
%{
filterString = handles.filterListbox.String;

%Delete previous Column strings.
if(~isempty(filterString))
    if(strcmp(oldColumnNames,'numbered'))
        while(~isempty(filterString)&&contains(filterString{1},'Column '))
            filterString(1)=[];
        end
    else
        for i=1:length(oldColumnNames)
            if(strcmp(filterString(1),oldColumnNames{i}))
                filterString(1)=[];
            end
        end
    end
end
%}
assignin('base','G',[]);


filterString = {};

%Insert new Column strings.
if(strcmp(handles.loadedData.ColumnName,'numbered'))
    for i=size(handles.loadedData.Data,2):-1:1
        try
            if(isnumeric(table2array(handles.loadedData.Data(:,i))))
            filterString = [{['Column ' num2str(i)]};filterString];
            end
        catch
            try
            if(isnumeric(table2array(cell2table(handles.loadedData.Data(:,i)))))
            filterString = [{['Column ' num2str(i)]};filterString];
            end
            catch
            end
        end
    end
else
    for i=size(handles.loadedData.Data,2):-1:1
        try
        if(isnumeric(table2array(handles.loadedData.Data(:,i))))
            filterString = [handles.loadedData.ColumnName(i);filterString];
        end
        catch
            try
                if(isnumeric(table2array(cell2table(handles.loadedData.Data(:,i)))))
                    filterString = [handles.loadedData.ColumnName(i);filterString];
                end
            catch
            end
        end
    end
end


%TODO: Check if old filters still apply to newly imported data.
%      Delete old filters if they make no sense.

handles.filterListbox.String = filterString;
handles.filterListbox.Value = [];

handles.clusteringAxes.String = filterString;
handles.clusteringAxes.Value = 1:length(filterString);

%With new data, clear other values.
handles.selectedFilters.String = [];
handles.selectedFilters.Value = [];

handles.plotAxes.String = filterString;
handles.plotAxes.Value = [];

cla(handles.CoveragePlot);
cla(handles.DataPlot);
cla(handles.MapperPlot);



assignin('base','filterString',handles.filterListbox.String);
%Replot Data



% --- Executes on selection change in plotAxes.
function plotAxes_Callback(hObject, eventdata, handles)
% hObject    handle to plotAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
selAxes = contents(get(hObject,'Value'));

selHigh = evalin('base','selHigh');
if(selHigh~=0)
    delete(selHigh);
end

%Get at most the first 3 selected axes.
if(length(selAxes)>3)
    selAxes = selAxes(1:3);
end


%Get data associated with selected axes.
dataIndex = zeros(size(selAxes));
if(strcmp(handles.loadedData.ColumnName,'numbered'))
    for i=1:length(selAxes)
        if(strncmp(selAxes{i},'Column ',7))
            %If string starts with 'Column ', get number as number.
            %Data is stored as cell array so convert to numerical array.
            dataIndex(i) = str2double(selAxes{i}(8:end));
        end
    end
else
    for i=1:length(selAxes)
        dataIndex(i) = find(strcmp(handles.loadedData.ColumnName, selAxes{i}));
    end
end
    
%handles.loadedData.ColumnName

handles.loadedData.Data(dataIndex);

%Plot that data.

plotData = cell2mat(handles.loadedData.Data(:,dataIndex));

if(length(selAxes)==1)
    scatter(handles.DataPlot,plotData,zeros(size(plotData)),'.');
elseif(length(selAxes)==2)
    scatter(handles.DataPlot,plotData(:,1),plotData(:,2),'.');
elseif(length(selAxes)==3)
    scatter3(handles.DataPlot,plotData(:,1),plotData(:,2),plotData(:,3),'.');
end

contents = cellstr(get(handles.graphLayout,'String'));
str = contents{get(handles.graphLayout,'Value')};
if(strcmp(str,'Geometric Mean')&&~isempty(evalin('base','G')))
    graphLayout_Callback(handles.graphLayout, eventdata, handles);
end




%disp(selAxes);


% Hints: contents = cellstr(get(hObject,'String')) returns plotAxes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotAxes


% --- Executes during object creation, after setting all properties.
function plotAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in graphLayout.
function graphLayout_Callback(hObject, eventdata, handles)
% hObject    handle to graphLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


G = evalin('base','G');
PXYZ = evalin('base','PXYZ');


contents = cellstr(get(hObject,'String'));
str = contents{get(hObject,'Value')};

if(strcmp(str,'Geometric Mean'))
    if(length(handles.plotAxes.Value)==1)
        graphPlotHandle = plot(handles.MapperPlot,G,'Layout','force','XStart',PXYZ(:,handles.plotAxes.Value(1)),'YStart',ones(size(PXYZ(:,handles.plotAxes.Value(1)))),'Iterations',0);
    elseif(length(handles.plotAxes.Value)==2)
        graphPlotHandle = plot(handles.MapperPlot,G,'Layout','force','XStart',PXYZ(:,handles.plotAxes.Value(1)),'YStart',PXYZ(:,handles.plotAxes.Value(2)),'Iterations',0);
    elseif(length(handles.plotAxes.Value)>=3)
        graphPlotHandle = plot(handles.MapperPlot,G,'Layout','force3','XStart',PXYZ(:,handles.plotAxes.Value(1)),'YStart',PXYZ(:,handles.plotAxes.Value(2)),'ZStart',PXYZ(:,handles.plotAxes.Value(3)),'Iterations',0);
    end
elseif(strcmp(str,'Force Directed'))
    graphPlotHandle = plot(handles.MapperPlot,G,'Layout','force');
    axis(handles.MapperPlot,'equal');
elseif(strcmp(str,'Force 3D'))
    graphPlotHandle = plot(handles.MapperPlot,G,'Layout','force3');
    axis(handles.MapperPlot,'equal');
end

scaleNode = evalin('base','scalenode');
M = evalin('base','M');
if(scaleNode)
    graphPlotHandle.MarkerSize = 8*M/max(M);
end

graphPlotHandle.NodeLabel={};

assignin('base','graphPlotHandle',graphPlotHandle);
    
% Hints: contents = cellstr(get(hObject,'String')) returns graphLayout contents as cell array
%        contents{get(hObject,'Value')} returns selected item from graphLayout


% --- Executes during object creation, after setting all properties.
function graphLayout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graphLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function opt1Slider_Callback(hObject, eventdata, handles)
% hObject    handle to opt1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function opt1Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opt1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function opt1Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to opt1Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opt1Textbox as text
%        str2double(get(hObject,'String')) returns contents of opt1Textbox as a double


% --- Executes during object creation, after setting all properties.
function opt1Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opt1Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function opt2Slider_Callback(hObject, eventdata, handles)
% hObject    handle to opt2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function opt2Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opt2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function opt2Textbox_Callback(hObject, eventdata, handles)
% hObject    handle to opt2Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opt2Textbox as text
%        str2double(get(hObject,'String')) returns contents of opt2Textbox as a double


% --- Executes during object creation, after setting all properties.
function opt2Textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opt2Textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in doMapper.
function doMapper_Callback(hObject, eventdata, handles)
% hObject    handle to doMapper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selHigh = evalin('base','selHigh');
if(selHigh~=0)
    delete(selHigh);
end


grabData = handles.loadedData.Data;
filters = handles.selectedFilters.String;
filterMap = evalin('base','filterMap');
filterData = zeros(2,length(filters));
filterColumns = zeros(length(filters),1);
if(strcmp(handles.loadedData.ColumnName,'numbered'))
    columnMap = containers.Map('Column 1',1);
else
    columnMap = containers.Map(handles.loadedData.ColumnName,1:length(handles.loadedData.ColumnName));
end

for i=1:length(filters)
    if(isKey(filterMap,filters(i)))
        filterData(:,i) = filterMap(filters{i});
    else
        filterData(:,i) = [10,0.5];
    end
    if(strcmp(handles.loadedData.ColumnName,'numbered'))
        filterColumns(i) = str2double(filters{i}(8:end));
    else
        filterColumns(i) = columnMap(filters{i});
    end
end

nBins = filterData(1,:);
overlaps = filterData(2,:);

filterpts = cell2mat(grabData(:,filterColumns));

%From https://au.mathworks.com/matlabcentral/answers/140029-find-numeric-columns-in-a-cell-array#answer_143503
q = cellfun(@(x) isnumeric(x) && numel(x)==1, grabData);
IsAllNum = all(q,1);
numericalpts = cell2mat(grabData(:,IsAllNum));

%outGraph = mapperNDv2(numericalpts,@(n) filterpts,@(n)clusterdata(n,'Linkage','single','Maxclust',4),nBins,overlaps,false);

clusterChoice =  handles.clusterMethod.String{handles.clusterMethod.Value};

if(strcmp(clusterChoice,'None'))
    
elseif(strcmp(clusterChoice,'k-means'))
    ClusterFunction = @(n)kmeans(n(:,handles.clusteringAxes.Value),handles.clusterSettingsTable.Data{1,2},'MaxIter',handles.clusterSettingsTable.Data{2,2});
elseif(strcmp(clusterChoice,'Hierarchical'))
    if(~isempty(handles.clusterSettingsTable.Data{2,2}))
        ClusterFunction = @(n)clusterdata(n(:,handles.clusteringAxes.Value),'criterion',handles.clusterSettingsTable.Data{1,2},'cutoff',handles.clusterSettingsTable.Data{2,2},'linkage',handles.clusterSettingsTable.Data{3,2});
    else
         ClusterFunction = @(n)clusterdata(n(:,handles.clusteringAxes.Value),'criterion',handles.clusterSettingsTable.Data{1,2},'linkage',handles.clusterSettingsTable.Data{3,2},'Maxclust',handles.clusterSettingsTable.Data{4,2});
    end
else
    %Custom function. Weird!!!
end

%clusteringAxes
%ClusterFunction = @(n)clusterdata(n,'criterion','distance','cutoff',0.1);

if(isempty(filterpts))
    filterpts = zeros(size(grabData));
    nBins = 1;
    overlaps = 0;
    numericalpts = cell2mat(grabData(:,:));
end

outGraph = mapper(numericalpts,@(n) filterpts,ClusterFunction,nBins,overlaps,false);



contents = cellstr(get(handles.graphLayout,'String'));
str = contents{get(handles.graphLayout,'Value')};
PXYZ = evalin('base','PXYZ');

if(strcmp(str,'Geometric Mean'))
    if(length(handles.plotAxes.Value)==1)
        graphPlotHandle = plot(handles.MapperPlot,outGraph,'Layout','force','XStart',PXYZ(:,handles.plotAxes.Value(1)),'YStart',ones(size(PXYZ(:,handles.plotAxes.Value(1)))),'Iterations',0);
    elseif(length(handles.plotAxes.Value)==2)
        graphPlotHandle = plot(handles.MapperPlot,outGraph,'Layout','force','XStart',PXYZ(:,handles.plotAxes.Value(1)),'YStart',PXYZ(:,handles.plotAxes.Value(2)),'Iterations',0);
    elseif(length(handles.plotAxes.Value)>=3)
        graphPlotHandle = plot(handles.MapperPlot,outGraph,'Layout','force3','XStart',PXYZ(:,handles.plotAxes.Value(1)),'YStart',PXYZ(:,handles.plotAxes.Value(2)),'ZStart',PXYZ(:,handles.plotAxes.Value(3)),'Iterations',0);
    end
elseif(strcmp(str,'Force Directed'))
    graphPlotHandle = plot(handles.MapperPlot,outGraph,'Layout','force');
end

assignin('base','graphPlotHandle',graphPlotHandle);

scaleNode = evalin('base','scalenode');
M = evalin('base','M');
if(scaleNode)
    graphPlotHandle.MarkerSize = 8*M/max(M);
end

%plot(handles.MapperPlot,outGraph,'Layout','force','UseGravity','off');

graphPlotHandle.NodeLabel={};

dcm_obj = datacursormode(gcf);
%dcm_obj.UpdateFcn = @(obj,event_obj)cursorMove(obj,event_obj,G.Nodes);
set(dcm_obj,'UpdateFcn',@cursorMove);



%When a plot is rotated, rotate the other plot to match.
r3d_obj = rotate3d(gcf);
set(r3d_obj,'ActionPreCallback',@rotationStart);
set(r3d_obj,'ActionPostCallback',@rotationStop);


    
function output_txt = cursorMove(~,event_obj)
% ~            Currently not used (empty)
% event_obj    Object containing event data structure
% output_txt   Data cursor text
pos = get(event_obj,'Position');
tar = get(event_obj,'Target');


%cursor is placed on the symbol underneath.
selHigh = evalin('base','selHigh');
handles = evalin('base','handles');
assignin('base','tar',tar);
assignin('base','pos',pos);

%If selected item was previous highlight, set target to other object.
if(eq(selHigh,tar))
    output_txt = '';
    delete(selHigh);
    return
end




handles = evalin('base','handles');


tarClass = class(tar);
if(strcmp(tarClass,'matlab.graphics.chart.primitive.Scatter'))
    %If on scatter, plot within graph.
    ind = find(tar.XData == pos(1) & tar.YData == pos(2), 1);
    
    %Find first 3 selected axes
    chosenAxes = handles.plotAxes.Value;
    if(length(chosenAxes)==1)
        output_txt = {['Point ' num2str(ind)],[handles.plotAxes.String{handles.plotAxes.Value(1)} ' = ' num2str(pos(1))]};
    elseif(length(chosenAxes)==2)
        output_txt = {['Point ' num2str(ind)],[handles.plotAxes.String{handles.plotAxes.Value(1)} ' = ' num2str(pos(1))],[handles.plotAxes.String{handles.plotAxes.Value(2)} ' = ' num2str(pos(2))]};
    elseif(length(chosenAxes)>=3)
        output_txt = {['Point ' num2str(ind)],[handles.plotAxes.String{handles.plotAxes.Value(1)} ' = ' num2str(pos(1))],[handles.plotAxes.String{handles.plotAxes.Value(2)} ' = ' num2str(pos(2))],[handles.plotAxes.String{handles.plotAxes.Value(3)} ' = ' num2str(pos(3))]};
    end
    
    
    
    %Find and print a list of all nodes in plot containing this point
    indArr = [];
    N = evalin('base','N');
    
    for ind2=1:length(N)
        if(~isempty(find(N{ind2}==ind)))
            indArr = [indArr,ind2];
        end
    end
    %disp(indArr);
    
    %subplot(2,1,2);
    
    %handles.DataPlot
    %handles.MapperPlot
    handles = evalin('base','handles');
    graphPlot = handles.MapperPlot;
    selHigh = evalin('base','selHigh');
    if(selHigh~=0)
        delete(selHigh);
    end
    hold(graphPlot,'on');
    selHigh2 = plot3(graphPlot,graphPlot.Children.XData(indArr),graphPlot.Children.YData(indArr),graphPlot.Children.ZData(indArr),'Color','r','LineWidth',5,'Marker','.','MarkerSize',30);
    hold(graphPlot,'off');
    assignin('base','selHigh',selHigh2);
    assignin('base','curHighlight',0);
    %subplot(2,1,1);
    
elseif(strcmp(tarClass,'matlab.graphics.chart.primitive.GraphPlot'))
    %If on graph, plot within scatter.
    
    ind = find(tar.XData == pos(1) & tar.YData == pos(2), 1);
    
    %draw index section as scatter
    %subplot(2,1,1);
    G = evalin('base','G');
    N = evalin('base','N');
    output_txt = {['Node ' num2str(ind)],['Points: ' num2str(length(N{ind}))],['Degree: ' num2str(degree(G,ind))]};

    
    inData = evalin('base','inData');
    
    
    
    
    selHigh = evalin('base','selHigh');
    if(selHigh~=0)
        delete(selHigh);
    end
    handles = evalin('base','handles');
    
    hold(handles.DataPlot,'on');
    
    axvals = handles.plotAxes.Value;
    
    inData = inData(:,axvals);
    
    if(size(inData,2)==1)
        selHigh2 = scatter(handles.DataPlot,inData(N{ind},1),zeros(size(N{ind},1)),'MarkerEdgeColor','r');
    elseif(size(inData,2)==2)
        selHigh2 = scatter(handles.DataPlot,inData(N{ind},1),inData(N{ind},2),'MarkerEdgeColor','r');
    elseif(size(inData,2)>=3)
        selHigh2 = scatter3(handles.DataPlot,inData(N{ind},1),inData(N{ind},2),inData(N{ind},3),'MarkerEdgeColor','r');
    end
    hold(handles.DataPlot,'off')
    assignin('base','selHigh',selHigh2);
    assignin('base','curHighlight',1);
    %subplot(2,1,2);
end

function rotationStart(obj, event_obj)
%Start rotation timer task.
handles = evalin('base','handles');
contents = cellstr(get(handles.graphLayout,'String'));

if(strcmp(contents{get(handles.graphLayout,'Value')},'Geometric Mean'))
    
    viewAx = event_obj.Axes.View;
    assignin('base','az',viewAx(1));
    assignin('base','el',viewAx(2));
    
    rotTimer = timer('TimerFcn',@(~,~)rotationTimerTask(),'ExecutionMode','fixedDelay','Period',0.01);
    start(rotTimer);
    assignin('base','rotTimer',rotTimer);
end

function rotationStop(obj, event_obj)
%End rotation timer task.
handles = evalin('base','handles');
contents = cellstr(get(handles.graphLayout,'String'));
if(strcmp(contents{get(handles.graphLayout,'Value')},'Geometric Mean'))
    
    rotTimer = evalin('base','rotTimer');
    stop(rotTimer);
    delete(rotTimer);
    rotationTimerTask();
end


%TODO: Fix subplot
function rotationTimerTask()
%TODO: Don't change if if rotation has not changed.

az = evalin('base','az');
el = evalin('base','el');

handles = evalin('base','handles');

%[az,el] = view;
%subplot(2,1,1);
viewAx = handles.DataPlot.View;
az1 = viewAx(1);
el1 = viewAx(2);

viewAx = handles.MapperPlot.View;
az2 = viewAx(1);
el2 = viewAx(2);

if(az1~=az||el1~=el)
    assignin('base','az',az1);
    assignin('base','el',el1);
    %subplot(2,1,2);
    handles.MapperPlot.View = [az1,el1];
elseif(az2~=az||el2~=el)
    assignin('base','az',az2);
    assignin('base','el',el2);
    %subplot(2,1,1);
    handles.DataPlot.View = [az2,el2];
    %view(az2,el2);
end


% --- Executes on selection change in colormapSelection.
function colormapSelection_Callback(hObject, eventdata, handles)
% hObject    handle to colormapSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colormapSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colormapSelection


% --- Executes during object creation, after setting all properties.
function colormapSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormapSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in loadExampleData.
function loadExampleData_Callback(hObject, eventdata, handles)
% hObject    handle to loadExampleData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
selected = contents{get(hObject,'Value')};

cd('Generators');
pts = eval([selected,'()']);
cd('..');

oldColumnNames = handles.loadedData.ColumnName;

handles.loadedData.ColumnName = 'numbered';
handles.loadedData.Data = num2cell(pts);



if(size(pts,2)==2)
    handles.clusterMethod.Value = 3;
    clusterMethod_Callback(handles.clusterMethod,eventdata,handles);
    handles.distanceMethod.Value = 1;
    handles.clusteringAxes.Value = [1,2];
elseif(size(pts,2)==3)
    
end


newDataCall(hObject, eventdata, handles, oldColumnNames);

handles.plotAxes.Value = [1,2];
plotAxes_Callback(handles.plotAxes,eventdata,handles);
handles.filterListbox.Value = 1;
filterListbox_Callback(handles.filterListbox,eventdata,handles);
handles.selectedFilters.Value = 1;
selectedFilters_Callback(handles.selectedFilters,eventdata,handles);



% Hints: contents = cellstr(get(hObject,'String')) returns loadExampleData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from loadExampleData


% --- Executes during object creation, after setting all properties.
function loadExampleData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadExampleData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function downsampleSlider_Callback(hObject, eventdata, handles)
% hObject    handle to downsampleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function downsampleSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to downsampleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function downsampleTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to downsampleTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of downsampleTextbox as text
%        str2double(get(hObject,'String')) returns contents of downsampleTextbox as a double


% --- Executes during object creation, after setting all properties.
function downsampleTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to downsampleTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in labelList.
function labelList_Callback(hObject, eventdata, handles)
% hObject    handle to labelList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns labelList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labelList


% --- Executes during object creation, after setting all properties.
function labelList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labelList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in makeLabel.
function makeLabel_Callback(hObject, eventdata, handles)
% hObject    handle to makeLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in mapperAutolabel.
function mapperAutolabel_Callback(hObject, eventdata, handles)
% hObject    handle to mapperAutolabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in renameLabel.
function renameLabel_Callback(hObject, eventdata, handles)
% hObject    handle to renameLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in deleteLabel.
function deleteLabel_Callback(hObject, eventdata, handles)
% hObject    handle to deleteLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in scaleNodeSize.
function scaleNodeSize_Callback(hObject, eventdata, handles)
% hObject    handle to scaleNodeSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphPlotHandle = evalin('base','graphPlotHandle');
M = evalin('base','M');

if(get(hObject,'Value'))
    %Scale node size.
    assignin('base','scalenode',1);
    graphPlotHandle.MarkerSize = 8*M/max(M);
else
    %Do not scale node size.
    assignin('base','scalenode',0);
    graphPlotHandle.MarkerSize = 2;
end


% Hint: get(hObject,'Value') returns toggle state of scaleNodeSize


% --- Executes when entered data in editable cell(s) in clusterSettingsTable.
function clusterSettingsTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to clusterSettingsTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data

%TODO: Make sure that numerical values are positive.


% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in clusteringAxes.
function clusteringAxes_Callback(hObject, eventdata, handles)
% hObject    handle to clusteringAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns clusteringAxes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from clusteringAxes


% --- Executes during object creation, after setting all properties.
function clusteringAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clusteringAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on selection change in listbox11.
function listbox11_Callback(hObject, eventdata, handles)
% hObject    handle to listbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox11


% --- Executes during object creation, after setting all properties.
function listbox11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in scaleEdgeWidth.
function scaleEdgeWidth_Callback(hObject, eventdata, handles)
% hObject    handle to scaleEdgeWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scaleEdgeWidth
