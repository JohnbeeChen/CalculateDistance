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

% Last Modified by GUIDE v2.5 12-Jul-2017 15:03:25

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
col_name = varargin{2};
set(handles.uitable1,'ColumnName',col_name,'Data',fit_result);

% Update handles structure
handles.displaydata = fit_result;
handles.rawdata = fit_result;
handles.index = 1;
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
rawdata = handles.rawdata;
len = size(rawdata,1);
ds = zeros(len,len);
for ii = 1:len
   point_one = rawdata(ii,:);
   for jj = 1:len
      point_two = rawdata(jj,:);
      ds(ii,jj) = GetDistance(point_one,point_two);
   end    
end
set(handles.uitable1,'ColumnName','numbered','Data',ds);
handles.displaydata = ds;
guidata(hObject, handles);

% --- Executes on button press in btn_saveexcel.
function btn_saveexcel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_saveexcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fName,pName,index] = uiputfile('*.xls','Save as','data_1.xls');
if index && strcmp(fName(end-3:end),'.xls')
    str = [pName fName];
    data = handles.displaydata;
    xlswrite(str,data);   
else
   disp('file path is not correct');    
end

function y = GetDistance(pointOne, pointTwo)
t = (pointOne - pointTwo).^2;
t = sum(t);
y = sqrt(t);
