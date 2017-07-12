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

% Last Modified by GUIDE v2.5 06-Jul-2017 20:22:52

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
    'Select Image File',pathname);
if isequal([filename,pathname],[0,0])
    return
else
    File = fullfile(pathname,filename);
    handles.File=File;
    if filename
        t=strfind(filename,'.tif');
        filebase=filename(1:t-1);
        handles.filebase = filebase;
        %         handles.pathname = pathname;
    end
end
% [handles.images,handles.ImageNumber]=tiffread(File);
handles.images = imreadstack_TIRF(File,1);
SetAxesImage(handles.axes1,handles.images(:,:,1));
guidata(hObject,handles);
save('lastfile.mat','pathname','filename');


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
    'Select ROI File',pathname);
roi_filename = fullfile(pathname,filename);
if filename
    rois = ReadImageJROI(roi_filename);
    roi_num = length(rois);
    box =zeros(roi_num,5);
    if roi_num == 1
        box(1,1:4) = rois.vnRectBounds;
        box(1,5) = rois.nPositon;
    elseif roi_num > 1
        for ii = 1:roi_num
            tem = rois{ii};
            box(ii,1:4) = tem.vnRectBounds;
            box(ii,5) = tem.nPosition;
        end
    end
    % changes the format of @box to [x y w h]
    % notice: the loc in ImageJ start from 0, but Matlab start from 1
    box(:,[4 3]) = box(:,3:4) - box(:,1:2) - 1;
    box(:,1:2) = box(:,[2 1]) + 1; 
    idx = box(:,[1 2]) == 0;
    box(idx) = 1;
    img_size = size(handles.images(:,:,1));
    idx = box(:,1) > img_size(2);
    box(idx) = img_size(2);
    idx = box(:,2) > img_size(1);
    box(idx) = img_size(1);    
    
    handles.roiboxs = box;
    AddRectagle(handles.axes1,box);
    guidata(hObject,handles);
else
    
end


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

boxs = handles.roiboxs;
imgSIM = handles.images;
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
handles.centroids = centroids;
guidata(hObject,handles);
s = {'centroid_x','centroid_y'};
FormTable(centroids,s);