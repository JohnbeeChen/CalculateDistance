function varargout = FormTable(varargin)
% FORMTABLE MATLAB code for FormTable.fig
%      FORMTABLE, by itself, creates a new FORMTABLE or raises the existing
%      singleton*.
%
%      H = FORMTABLE returns the handle to a new FORMTABLE or the handle to
%      the existing singleton*.
%
%      FORMTABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORMTABLE.M with the given input arguments.
%
%      FORMTABLE('Property','Value',...) creates a new FORMTABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FormTable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FormTable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FormTable

% Last Modified by GUIDE v2.5 05-Sep-2017 16:41:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FormTable_OpeningFcn, ...
    'gui_OutputFcn',  @FormTable_OutputFcn, ...
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


% --- Executes just before FormTable is made visible.
function FormTable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FormTable (see VARARGIN)

% Choose default command line output for FormTable
handles.output = hObject;
fit_result = varargin{1};
fram_index = varargin{2};
col_name = varargin{3};
row_name = varargin{4};
set(handles.uitable1,'RowName',row_name,'ColumnName',col_name,'Data',fit_result);

% Update handles structure
handles.displaydata{1} = fit_result;
handles.rawdata = fit_result;
handles.index = 1;
handles.row_name = row_name;
handles.col_name = col_name;
handles.fram_index = fram_index;
guidata(hObject, handles);

% UIWAIT makes FormTable wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FormTable_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_analysis.
function btn_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to btn_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt={'Pixel size(nm):'};
defaults={num2str(32.5)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
pixesize = 1;
if ~isempty(info)
    pixesize = str2double(info(1));
end
rawdata = handles.rawdata;
len = size(rawdata,1);
ds = zeros(len,len);
tem = len*(len - 1)/1;
% hist_data = zeros(1,tem);
fram_index = handles.fram_index;
kk = 1;
for ii = 1:len
    point_one = rawdata(ii,1:2);
    min_distance = 1000;
    for jj = 1:len
        point_two = rawdata(jj,1:2);
        tem_ds = pixesize*GetDistance(point_one,point_two);
        if ii ~= jj
            if(tem_ds < min_distance)
                min_distance = tem_ds;
            end
        end
        
        if ii<jj
            ds(ii,jj) = fram_index(jj) - fram_index(ii);
        else
            ds(ii,jj) = tem_ds;
        end
    end
    hist_data(kk) = min_distance;
    kk = kk+1;
end
set(handles.uitable1,'ColumnName',handles.row_name,'Data',ds);
figure
histogram(hist_data,40);

handles.nearestdistance = hist_data';
handles.distance = ds;
handles.displaydata{2} = ds;
guidata(hObject, handles);
grid minor;

figure
if size(rawdata,2) == 2
    rawdata(:,3) = 1;
end
event_num = max(rawdata(:,3));
legend_name{event_num} = [];
for ii = 1:event_num
    idx = rawdata(:,3) == ii;
    point_set_loc =pixesize * rawdata(idx,1:2);
    
    plot(point_set_loc(:,1),point_set_loc(:,2),'*');
    hold on
    legend_name{ii} = ['nanospark ',num2str(ii)];
end
hold off
grid minor;
legend(legend_name);
xlabel 'x/nm',ylabel 'y/nm';
centroids = pixesize * rawdata(:,1:2);
save('centroids.mat','centroids');

function y = GetDistance(pointOne, pointTwo)
t = pointOne - pointTwo;
y = sqrt(t*t');
% t = sum(t);
% y = sqrt(t);

% --- Executes on button press in btn_saveexcel.
function btn_saveexcel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_saveexcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fName,pName,index] = uiputfile('*.xlsx','Save as','data_1.xlsx');
if index && strcmp(fName(end-4:end),'.xlsx')
    str = [pName fName];
    data = get(handles.uitable1,'data');
    data_excel = cell(size(data,1) + 1, size(data,2) + 1);
    data_excel(1,2:end) = get(handles.uitable1,'ColumnName');
    data_excel(2:end,1) = get(handles.uitable1,'RowName');
    data_excel(2:end,2:end) = num2cell(data);
    xlswrite(str,data_excel);
else
    disp('file path is not correct');
end


% --- Executes on button press in btn_select.
function btn_select_Callback(hObject, eventdata, handles)
% hObject    handle to btn_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'distance')
    disp('please analysis firstly');
    return;
end
prompt={'distance threshold (nm):'};
defaults={num2str(30)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
if ~isempty(info)
    level = str2double(info(1));
    data = handles.distance;
    len = length(data);
    for ii = 2:len
        for jj = 1:(ii-1)
            %the distance less than the @level
            if data(ii,jj)>level
                data(ii,jj) = 0;
            end
        end
    end
    set(handles.uitable1,'Data',data);
    handles.select_data = data;
    handles.displaydata{3} = data;
end
guidata(hObject, handles);


% --- Executes on button press in btn_savenearestdistance.
function btn_savenearestdistance_Callback(hObject, eventdata, handles)
% hObject    handle to btn_savenearestdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'nearestdistance')
    disp('the nearest distance does not exist');
end
[fName,pName,index] = uiputfile('*.xlsx','Save as','nearest_disance.xlsx');
if index && strcmp(fName(end-4:end),'.xlsx')
    str = [pName fName];
    data = handles.nearestdistance;
    %     data_excel = cell(size(data,1) + 1, size(data,2) + 1);
    %     data_excel(1,2:end) = get(handles.uitable1,'ColumnName');
    %     data_excel(2:end,1) = get(handles.uitable1,'RowName');
    %     data_excel(2:end,2:end) = num2cell(data);
    xlswrite(str,data);
else
    disp('file path is not correct');
end


% --- Executes on button press in btn_assort.
function btn_assort_Callback(hObject, eventdata, handles)
% hObject    handle to btn_assort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'distance')
    disp('please analysis firstly');
    return;
end
prompt={'threshold1 (nm):','threshold2 (nm):'};
defaults={num2str(0),num2str(0)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
if ~isempty(info)
    thrd1 = str2double(info(1));
    thrd2 = str2double(info(2));
    %     data = handles.distance;
end
