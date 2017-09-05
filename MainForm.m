function varargout = MainForm(varargin)
% MAINFORM MATLAB code for MainForm.fig
%      MAINFORM, by itself, creates a new MAINFORM or raises the existing
%      singleton*.
%
%      H = MAINFORM returns the handle to a new MAINFORM or the handle to
%      the existing singleton*.
%
%      MAINFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINFORM.M with the given input arguments.
%
%      MAINFORM('Property','Value',...) creates a new MAINFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainForm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainForm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainForm

% Last Modified by GUIDE v2.5 05-Sep-2017 14:25:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainForm_OpeningFcn, ...
    'gui_OutputFcn',  @MainForm_OutputFcn, ...
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


% --- Executes just before MainForm is made visible.
function MainForm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainForm (see VARARGIN)

% Choose default command line output for MainForm
handles.output = hObject;
set(handles.axes1,'visible','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainForm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainForm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function MenuFile_Callback(hObject, eventdata, handles)
% hObject    handle to MenuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to MenuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('lastfile.mat','file')
    P=importdata('lastfile.mat');
    pathname=P.pathname;
else
    pathname=cd;
end
[filename, pathname] = uigetfile( ...
    {'*.tif;*.tiff', 'All TIF-Files (*.tif,*.tiff)'; ...
    '*.*','All Files (*.*)'}, ...
    'Select Image File',pathname,'MultiSelect','on');
if isequal([filename,pathname],[0,0])
    disp('file path is not correct!');
    return
end
imag_statck_num = length(filename);
img_set = cell(1,imag_statck_num);
full_filename = fullfile(pathname,filename);
if ~iscell(full_filename)
    tem{1} = full_filename;
    clear full_filename;
    full_filename{1} = tem{1};
    imag_statck_num = 1;
end
for ii = 1:imag_statck_num
    img_set{ii} = imreadstack_TIRF(full_filename{ii},1);
end
SetAxesImage(handles.axes1,img_set{1}(:,:,1));
s = ['1/',num2str(imag_statck_num)];
SetTextString(handles.text_title,s);
handles.img_set = img_set;
handles.img_set_index = 1;
handles.imag_statck_num = imag_statck_num;
guidata(hObject,handles);
save('lastfile.mat','pathname','filename');


function SetTextString(myText,s)
set(myText,'String',s);

function SetAxesImage(myAxes,myImages)
set(myAxes,'visible','on');
axes(myAxes);
cla reset;
imshow(myImages,[]);
% hold on
% rectangle('Position',[10,100,100,50],'Curvature',[0,0],'LineWidth',2,'LineStyle','--','EdgeColor','r');
% hold off
% AddRectagle(myAxes);


function AddRectagle(myAxes, myBoxs)
num = size(myBoxs,1);
axes(myAxes);
hold on
for ii = 1:num
    rectangle('Position',myBoxs(ii,1:4),'Curvature',[0,0],'LineWidth',1,'LineStyle','--','EdgeColor','r');
end
hold off


% --- Executes on button press in btn_readROI.
function btn_readROI_Callback(hObject, eventdata, handles)
% hObject    handle to btn_readROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('lastfile.mat','file')
    P=importdata('lastfile.mat');
    pathname=P.pathname;
else
    pathname=cd;
end
[filename, pathname] = uigetfile( ...
    {'*.zip;*.roi', 'All zip-Files (*.zip,*.zip)'; ...
    '*.*','All Files (*.*)'}, ...
    'Select ROI File',pathname,'MultiSelect','on');
if isequal([filename,pathname],[0,0])
    disp('file path is not correct!');
    return
end
roi_set_num = length(filename);
roi_set = cell(roi_set_num,1);
roi_name_set = cell(roi_set_num,1);
full_filename = fullfile(pathname,filename);
% if @full_filename isn't a cell type that idicate that it inputs one file
if ~iscell(full_filename)
    tem{1} = full_filename;
    clear full_filename;
    full_filename{1} = tem{1};
    roi_set_num = 1;
end
for ii = 1:roi_set_num
    rois = ReadImageJROI(full_filename{ii});
    roi_num = length(rois);
    box =zeros(roi_num,5);
    roi_names= cell(1,roi_num);
    if roi_num == 1
        box(1,1:4) = rois{1}.vnRectBounds;
        box(1,5) = rois{1}.nPosition;
        roi_names{1} = rois{1}.strName;
    elseif roi_num > 1
        for jj = 1:roi_num
            tem = rois{jj};
            box(jj,1:4) = tem.vnRectBounds;
            box(jj,5) = tem.nPosition;
            roi_names{jj} = tem.strName;
        end
    end
    % changes the format of @box to [x y w h]
    % notice: the loc in ImageJ start from 0, but Matlab start from 1
    box(:,[4 3]) = box(:,3:4) - box(:,1:2) - 1;
    box(:,1:2) = box(:,[2 1]) + 1;
    idx = box(:,[1 2]) == 0;
    box(idx) = 1;
    img_size = size(handles.img_set{ii}(:,:,1));
    idx = box(:,1) > img_size(2);
    box(idx) = img_size(2);
    idx = box(:,2) > img_size(1);
    box(idx) = img_size(1);
    
    roi_set{ii} = box;
    roi_name_set{ii} = roi_names;
end
img = handles.img_set{1}(:,:,1);
imag_statck_num = handles.imag_statck_num;
SetAxesImage(handles.axes1,img);
s = ['1/',num2str(imag_statck_num)];
SetTextString(handles.text_title,s);
AddRectagle(handles.axes1,roi_set{1});

handles.img_set_index = 1;
handles.roi_set = roi_set;
handles.roi_name_set = roi_name_set;

guidata(hObject,handles);



% --- Executes on button press in btn_zprofile.
function btn_zprofile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
boxs = handles.roiboxs;
all_profile = TIRF_Z_Profile(handles.images,boxs);
handles.eventinfo = FormPlot(all_profile);
guidata(hObject,handles);


% --- Executes on button press in btn_findparticles.
function btn_findparticles_Callback(hObject, eventdata, handles)
% hObject    handle to btn_findparticles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'roi_set')
    disp('Please read roi files firstly!');
    return;
end
img_set_index = handles.img_set_index;
boxs = handles.roi_set{img_set_index};
imgSIM = handles.img_set{img_set_index};
len = size(boxs,1);
img_num = size(imgSIM,3);
centroids(len,2) = 0;
for ii = 1:len
    event_loc = boxs(ii,5);
    if event_loc == 1
        event_duration = 1:3;
    elseif event_loc == img_num
        event_duration = (img_num-2):img_num;
    else
        event_duration = (event_loc-1):(event_loc+1);
    end
    
    event_frams = imgSIM(:,:,event_duration);
    %selects the roi region in @event_fram
    tem_box = boxs(ii,:);
    event_frams_roi = KeepROI(event_frams,tem_box);
    centroids(ii,:) = GetCentroid(event_frams_roi);
end
centroids = centroids + boxs(:,1:2);
col_name = {'centroid_x','centroid_y'};
row_name = handles.roi_name_set{img_set_index};
FormTable(centroids,boxs(:,5),col_name,row_name);
handles.centroids = centroids;
guidata(hObject,handles);

% --- Executes on button press in btn_previous.
function btn_previous_Callback(hObject, eventdata, handles)
% hObject    handle to btn_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'img_set')
    disp('Please read images firstly!');
    return;
end
index = handles.img_set_index;
if index > 1
    index = index - 1;
    img = handles.img_set{index};
    SetAxesImage(handles.axes1,img(:,:,1));
    s = [num2str(index),'/',num2str(handles.imag_statck_num)];
    SetTextString(handles.text_title,s);
    if isfield(handles,'roi_set')
        box = handles.roi_set{index};
        AddRectagle(handles.axes1,box);
    end
    handles.img_set_index = index;
    guidata(hObject, handles);
end

% --- Executes on button press in btn_next.
function btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'img_set')
    disp('Please read images firstly!');
    return;
end
index = handles.img_set_index;
if index < handles.imag_statck_num
    index = index + 1;
    img = handles.img_set{index};
    SetAxesImage(handles.axes1,img(:,:,1));
    s = [num2str(index),'/',num2str(handles.imag_statck_num)];
    SetTextString(handles.text_title,s);
    if isfield(handles,'roi_set')
        box = handles.roi_set{index};
        AddRectagle(handles.axes1,box);
    end
    handles.img_set_index = index;
    guidata(hObject, handles);
end

% --- Executes on button press in bty_find_all.
function bty_find_all_Callback(hObject, eventdata, handles)
% hObject    handle to bty_find_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'roi_set')
    disp('Please read roi files firstly!');
    return;
end
img_set = handles.img_set;
roi_set = handles.roi_set;
img_set_num = handles.imag_statck_num;
centroid_set{img_set_num,1} = [];
for idex = 1:img_set_num
    img_set_index = idex;
    boxs = roi_set{img_set_index};
    imgSIM = img_set{img_set_index};
    len = size(boxs,1);
    img_num = size(imgSIM,3);
    %     centroid(len,2) = 0;
    for ii = 1:len
        event_loc = boxs(ii,5);
        if event_loc == 1
            event_duration = 1:3;
        elseif event_loc == img_num
            event_duration = (img_num-2):img_num;
        else
            event_duration = (event_loc-1):(event_loc+1);
        end
        
        event_frams = imgSIM(:,:,event_duration);
        %selects the roi region in @event_fram
        tem_box = boxs(ii,:);
        event_frams_roi = KeepROI(event_frams,tem_box);
        centroid(ii,1:2) = GetCentroid(event_frams_roi);
    end
    tem_index = 1:len;
    tem = centroid + boxs(:,1:2);
    tem(:,3) = idex;
    tem = [tem tem_index'];
    centroid_set{idex} = tem;
    clear centroid;
end
col_name = {'centroid_x','centroid_y','event_order','order'};
%centroids[centroids_x,centroids_y,roi_set index, index in roi_set{ii}]
centroids = cell2mat(centroid_set);
boxs = cell2mat(roi_set);

tem = handles.roi_name_set;
len = length(tem);
row_names = tem{1};
for ii = 2:len
    row_names = [row_names tem{ii}];
end

FormTable(centroids,boxs(:,5),col_name,row_names);
handles.all_centroids = centroids;
guidata(hObject,handles);


% --- Executes on button press in btn_Assort.
function btn_Assort_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Assort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'all_centroids')
    disp('Press the FindAllParticles button firstly, please!');
    return;
end
centroids = handles.all_centroids;
centroids_num = size(centroids,1);
dis = zeros(centroids_num);
thrd1 = 18; %the first threshold(per nanometer)
ii = 1;
while 1
    centroids_num = size(centroids,1);
    if ii < centroids_num
        point_one = centroids(ii,:);
        jj = ii+1;
        while 1
            tem_len = size(centroids,1);
            if jj > tem_len
               break; 
            end
            point_two = centroids(jj,:);
            tem_point = point_two(1:2) - point_one(1:2);
            distance = 32.5*sqrt(tem_point*tem_point');
            if distance <= thrd1
                centroids(jj,:) =[];%delet the same point 
            else
                jj = jj + 1;
            end
        end
        ii = ii + 1;
    else
        break;
    end
    
end

jj = 0;
