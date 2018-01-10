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

% Last Modified by GUIDE v2.5 13-Oct-2017 20:07:46

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
try
    roi_idx = varargin{5};
catch
    roi_idx = 0;
end
set(handles.uitable1,'RowName',row_name,'ColumnName',col_name,'Data',fit_result);

% Update handles structure
handles.displaydata{1} = fit_result;
handles.rawdata = fit_result;
handles.index = 1;
handles.row_name = row_name;
handles.col_name = col_name;
handles.fram_index = fram_index;
handles.roi_idx = roi_idx;
guidata(hObject, handles);

% UIWAIT makes FormTable wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% uiresume(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = FormTable_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% t = handles.output;
% varargout{1} = handles.output;
t = 1;
varargout{1} = handles.out1;


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
centroids = handles.rawdata;
centroids(:,1:2) = pixesize * centroids(:,1:2);
len = size(centroids,1);
ds = zeros(len,len);
% tem = len*(len - 1)/1;
% hist_data = zeros(1,tem);
fram_index = handles.fram_index;
kk = 1;
for ii = 1:len
    point_one = centroids(ii,1:2);
    min_distance = 1000;
    for jj = 1:len
        point_two = centroids(jj,1:2);
        tem_ds = GetDistance(point_one,point_two);
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
% figure
% histogram(hist_data,40);
% grid minor;
handles.nearestdistance = hist_data';
handles.distance = ds;
handles.displaydata{2} = ds;
handles.pixe_size = pixesize;
handles.all_centroids = centroids;
handles.out1 = centroids;
guidata(hObject, handles);


figure
if size(centroids,2) == 2
    centroids(:,3) = 1;
end
event_num = max(centroids(:,3));
legend_name{event_num} = [];
for ii = 1:event_num
    idx = centroids(:,3) == ii;
    point_set_loc = centroids(idx,1:2);
    
    plot(point_set_loc(:,1),point_set_loc(:,2),'.','MarkerSize',13);
    hold on
    legend_name{ii} = ['nanospark ',num2str(ii)];
end
hold off
grid minor;
axis equal;
print(gcf,'-dpng',' all_centroids.png');
legend(legend_name);
xlabel 'x/nm',ylabel 'y/nm';
if event_num > 0
    all_centroids = centroids;
    save('all_centroids.mat','all_centroids');
end
uiresume(handles.figure1);


function y = GetDistance(pointOne, pointTwo)
t = pointOne - pointTwo;
y = sqrt(t*t');


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

all_centroids = handles.all_centroids;
% centroids_num = size(all_centroids,1);
thrd1 = 16; %the first threshold(per nanometer)

all_centroids(:,1:2) = all_centroids(:,1:2);
ii = 1;
while 1
    centroids_num = size(all_centroids,1);
    if ii < centroids_num
        point_one = all_centroids(ii,:);
        jj = ii+1;
        while 1
            tem_len = size(all_centroids,1);
            if jj > tem_len
                break;
            end
            point_two = all_centroids(jj,:);
            %notice: calculate the
            tem_point = point_two(1:2) - point_one(1:2);
            distance =   sqrt(tem_point*tem_point');
            if distance <= thrd1
                weight1 = point_one(5);
                weight2 = point_two(5);
                w = [weight1,weight2];
                p = [point_one(1:2);point_two(1:2)];
                %calculate the new centroids of @point_one and @point_two
                new_p = (w*p)./(sum(w));
                point_one(1:2) = new_p;
                point_one(5) = sum(w);
                all_centroids(ii,:) = point_one;
                all_centroids(jj,:) =[];%delet the same point
            else
                jj = jj + 1;
            end
        end
        ii = ii + 1;
    else
        break;
    end
end
figure
plot(all_centroids(:,1),all_centroids(:,2),'*');
xlabel('x/nm');
ylabel('y.nm');
grid minor
axis equal;
print(gcf,'-dpng',' merged_centroids.png');
handles.merged_centroids = all_centroids;
guidata(hObject,handles);

% --- Executes on button press in btn_circle.
function btn_circle_Callback(hObject, eventdata, handles)
% hObject    handle to btn_circle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~exist('cluster_centroieds.mat','file')
    disp('clusetring firstly please!');
    return;
end
% load cluster_centroieds.mat;
load omited_cluster_centroid.mat;
C = omited_cluster_centroid;

roi_idx = handles.roi_idx;
% centroids = handles.all_centroids;
load omited_all_centroids.mat
centroids = omited_all_centroids;
len = max(centroids(:,3));
for kk = 1:len
    idx = omited_all_centroids(:,3) == kk;
    centroids = omited_all_centroids(idx,:);
    figure;
    plot(centroids(:,1),centroids(:,2),'*');
    
    
    hold on
    circle(C(:,1:2),15);
    grid minor;
    point_num = size(centroids,1);
    cluster_num = size(C,1);
    for ii = 1:point_num
        p1 = centroids(ii,1:2);
        p1 = p1(ones(cluster_num,1),:);
        tem = p1 - C;
        ds = diag(tem*tem');
        idex = find(ds == min(ds));
        hold on;
        circle(C(idex,1:2),15,'r');
    end
    
    print(gcf,'-dpng',['event distribution_',num2str(kk),'.png']);
end