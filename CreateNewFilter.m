function varargout = CreateNewFilter(varargin)
% CREATENEWFILTER MATLAB code for CreateNewFilter.fig
%      CREATENEWFILTER, by itself, creates a new CREATENEWFILTER or raises the existing
%      singleton*.
%
%      H = CREATENEWFILTER returns the handle to a new CREATENEWFILTER or the handle to
%      the existing singleton*.
%
%      CREATENEWFILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATENEWFILTER.M with the given input arguments.
%
%      CREATENEWFILTER('Property','Value',...) creates a new CREATENEWFILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateNewFilter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateNewFilter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateNewFilter

% Last Modified by GUIDE v2.5 21-Feb-2019 16:34:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CreateNewFilter_OpeningFcn, ...
                   'gui_OutputFcn',  @CreateNewFilter_OutputFcn, ...
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


% --- Executes just before CreateNewFilter is made visible.
function CreateNewFilter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateNewFilter (see VARARGIN)

% Choose default command line output for CreateNewFilter
handles.output = hObject;




handles.dataColumnSelect.String = evalin('base','ExistingFilters');

assignin('base','handles2',handles);


%Search through Filters folder and add each to the list.

a = dir('Filters');
fnlocs = cell(length(a)-2,1);
fnnames = cell(length(a)-2,1);
for i=3:length(a)
    fnlocs{i-2} = [a(i).folder, '\', a(i).name];
    fnnames{i-2} = a(i).name(1:end-2);
end
handles.transformationSelect.String = fnnames;

cd('Filters');
properties = eval([fnnames{1},'()']);
cd('..');
assignin('base','filterProperties',properties);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CreateNewFilter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CreateNewFilter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function customFilterFormula_Callback(hObject, eventdata, handles)
% hObject    handle to customFilterFormula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of customFilterFormula as text
%        str2double(get(hObject,'String')) returns contents of customFilterFormula as a double


% --- Executes during object creation, after setting all properties.
function customFilterFormula_CreateFcn(hObject, eventdata, handles)
% hObject    handle to customFilterFormula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dataColumnSelect.
function dataColumnSelect_Callback(hObject, eventdata, handles)
% hObject    handle to dataColumnSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Change the number of outputs to match inputs.
%disp(get(hObject,'Value'))
numIn = length(get(handles.dataColumnSelect,'Value'));
handles.outputSelect.String = {};
handles.outputSelect.Value = [];
properties = evalin('base','filterProperties');
params = properties{1};
outnum = properties{2};
prefix = properties{3};

if(isempty(params))
    handles.parameterTable.RowName = {};
    handles.parameterTable.Data = {};
else
    %Populate parameter table.
    handles.parameterTable.RowName = params{1};
    handles.parameterTable.Data = params{2};
end

switch outnum
    case "1"
        if(numIn>0)
            handles.outputSelect.String{1}=prefix;
        end
    case "inNum"
        for i=1:numIn
            handles.outputSelect.String{i}=strcat(prefix, num2str(i));
        end
    case "Param(1)"
        for i=1:str2double(handles.parameterTable.Data{1})
            handles.outputSelect.String{i}=strcat(prefix, num2str(i));
        end
end

switch prefix
    case 'Radial from '
end

% Hints: contents = cellstr(get(hObject,'String')) returns dataColumnSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataColumnSelect


% --- Executes during object creation, after setting all properties.
function dataColumnSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataColumnSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addFilterButton.
function addFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to addFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
baseHandles = evalin('base','handles');


%Add, save, and apply new filter, then close

%Remove spaces in customFilterName and Formula
filterName = erase(handles.customFilterName.String," ");
formula = erase(handles.customFilterFormula.String," ");
%disp(filterName);
%disp(formula);
f = msgbox('Calculating output, please wait...');

%Get loadedData in base, turn into cell array if not

%Replace Data Column names in custom filter with actual values.
%Eval formula and add as column
%disp(formula);
if(strcmp(baseHandles.loadedData.ColumnName,'numbered'))
    for i=1:size(baseHandles.loadedData.Data,2)
    formula = strrep(formula,['Column',num2str(i)],['[', num2str(cell2mat(baseHandles.loadedData.Data(:,i))'), ']''']);
    end
else
    for i=1:size(baseHandles.loadedData.Data,2)
    formula = strrep(formula,baseHandles.loadedData.ColumnName{i},['[', num2str(cell2mat(baseHandles.loadedData.Data(:,i))'), ']''']);
    end
end

cd('Filters');
newCol = num2cell(eval(formula));
cd('..');


%dataHandle = baseHandles.loadedData;
%baseHandles.loadedData.Data = baseHandles.loadedData.Data
if(strcmp(baseHandles.loadedData.ColumnName,'numbered'))
    %If previously just numbered, assign names
    newNames = {};
    for i=1:size(baseHandles.loadedData.Data,2)
        newNames{i} = ['Column', num2str(i)];
    end
else
    %If already named, carry through.
    newNames = baseHandles.loadedData.ColumnName;
end
%Add new name.
%TODO: Make sure new name is not already in use.
newNames{size(baseHandles.loadedData.Data,2)+1} = filterName;
%Assign new column names.
baseHandles.loadedData.ColumnName = newNames;

baseHandles.loadedData.Data = [baseHandles.loadedData.Data, newCol];

evalin('base','newDataCall(handles)');
close(f);





% --- Executes on selection change in transformationSelect.
function transformationSelect_Callback(hObject, eventdata, handles)
% hObject    handle to transformationSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
transform = contents{get(hObject,'Value')};
numSelected = length(handles.dataColumnSelect.Value);

cd('Filters');
properties = eval([transform,'()']);
cd('..');

assignin('base','filterProperties',properties);


dataColumnSelect_Callback(handles.dataColumnSelect, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns transformationSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from transformationSelect


% --- Executes during object creation, after setting all properties.
function transformationSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transformationSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function customFilterName_Callback(hObject, eventdata, handles)
% hObject    handle to customFilterName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of customFilterName as text
%        str2double(get(hObject,'String')) returns contents of customFilterName as a double


% --- Executes during object creation, after setting all properties.
function customFilterName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to customFilterName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in outputSelect.
function outputSelect_Callback(hObject, eventdata, handles)
% hObject    handle to outputSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outputSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputSelect


% --- Executes during object creation, after setting all properties.
function outputSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addColumnToFormulaButton.
function addColumnToFormulaButton_Callback(hObject, eventdata, handles)
% hObject    handle to addColumnToFormulaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the selected data columns and add them to Custom Filter.
selected = string(handles.dataColumnSelect.String(handles.dataColumnSelect.Value));
selected = erase(selected," ");
%disp(strjoin(selected, ' + '));
if(strlength(handles.customFilterFormula.String)==0)
    handles.customFilterFormula.String = strjoin(selected, ' + ');
else
    handles.customFilterFormula.String = strjoin([handles.customFilterFormula.String, ' + ', strjoin(selected, ' + ')]);
end

% --- Executes on button press in addOutputsAsFilters.
function addOutputsAsFilters_Callback(hObject, eventdata, handles)
% hObject    handle to addOutputsAsFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:length(handles.outputSelect.String)
    handles.customFilterFormula.String='';
    handles.outputSelect.Value=i;
    addSelectedToFormula_Callback(handles.addSelectedToFormula, eventdata, handles);
    handles.customFilterName.String=handles.outputSelect.String{i};
    addFilterButton_Callback(handles.addFilterButton, eventdata, handles);
end

handles.customFilterFormula.String='';
handles.customFilterName.String = '';


%For now, assume PCA. Run it.


% --- Executes on button press in addSelectedToFormula.
function addSelectedToFormula_Callback(hObject, eventdata, handles)
% hObject    handle to addSelectedToFormula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get contents
%disp(handles.outputSelect.Value)

inStr = handles.dataColumnSelect.String(handles.dataColumnSelect.Value);
inStr = ['[',strjoin(erase(inStr," "), ','),']'];
%inStr is of the form '[Column1,Column2,Column3]'
outSel = handles.outputSelect.Value;
funcName = handles.transformationSelect.String(handles.transformationSelect.Value);
for i=1:length(outSel)
    selected = [funcName{1},'(',inStr,',',num2str(outSel(i)),')'];
    if(strlength(handles.customFilterFormula.String)==0)
        handles.customFilterFormula.String = selected;
    else
        handles.customFilterFormula.String = [handles.customFilterFormula.String, ' + ', selected];
    end
end
