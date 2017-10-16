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

% Last Modified by GUIDE v2.5 15-Oct-2017 14:17:19

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
idx = strfind(pathname,'\');
if length(idx) > 1
    t1 = idx(end - 1) + 1;
    t2 = idx(end) - 1;
    folder_name = pathname(t1:t2);
else
    folder_name = pathname;
end
handles.img_set = img_set;
handles.img_set_index = 1;
handles.imag_statck_num = imag_statck_num;
handles.folder_name = folder_name;
handles.tiff_name = filename;
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
handles.roi_filename = filename;

guidata(hObject,handles);



% --- Executes on button press in btn_zprofile.
function btn_zprofile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% box_set = handles.roi_set;
img_set = handles.img_set;
stack_num = length(img_set);
for ii = 1:stack_num
    %     tem_boxs = box_set{ii};
    tem_img = img_set{ii};
    %     box_num = size(tem_boxs,1);
    %     for jj = 1:box_num
    profile_set{ii} = Get_Z_Profile(tem_img);
    %         t = 1;
    %     end
end
% all_profile = TIRF_Z_Profile(handles.images,boxs);
handles.eventinfo = FormPlot(profile_set);
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
    [centroids(ii,1:2),fit_imgs_weight] = GetCentroid(event_frams_roi);
    centroids(ii,5) = fit_imgs_weight;
    
end
tem_index = 1:len;
tem = centroids(:,1:2) + boxs(:,1:2);
tem(:,3) = 1;
tem = [tem tem_index'];
tem(:,5) = centroids(:,5);
centroids = tem;
% centroids = centroids + boxs(:,1:2);
col_name = {'centroid_x','centroid_y','event_order','order','intesity sum'};
row_name = handles.roi_name_set{img_set_index};
FormTable(centroids,boxs(:,5),col_name,row_name);

handles.centroids = centroids;
guidata(hObject,handles);

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
    %     profiles{idex} = Get_Z_Profile(imgSIM);
    
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
        %         fit_imgs_weight = sum(event_frams_roi(:));
        [centroid(ii,1:2),fit_imgs_weight] = GetCentroid(event_frams_roi);
        centroid(ii,5) = fit_imgs_weight;
        centroid(ii,6) = tem_box(5);%frame index in the image's stack
    end
    tem_index = 1:len;
    tem = centroid(:,1:2) + boxs(:,1:2);
    tem(:,3) = idex;
    tem = [tem tem_index'];
    tem(:,5:6) = centroid(:,5:6);
    centroid_set{idex} = tem;
    clear centroid;
end
col_name = {'centroid_x','centroid_y','event_order','order','intesity sum','frame'};
%centroids[centroids_x,centroids_y,roi_set index, index in roi_set{ii}]
centroids = cell2mat(centroid_set);
boxs = cell2mat(roi_set);

tem = handles.roi_name_set;
len = length(tem);
row_names = tem{1};
for ii = 2:len
    row_names = [row_names tem{ii}];
end

all_centroids = FormTable(centroids,boxs(:,5),col_name,row_names);
handles.all_centroids = all_centroids;
handles.fit_imgs_weight = fit_imgs_weight;
guidata(hObject,handles);


% --- Executes on button press in btn_Assort.
function btn_Assort_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Assort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if ~isfield(handles,'all_centroids')
%     disp('Press the FindAllParticles button firstly, please!');
%     return;
% end
% load all_centroids.mat 
% the coordinate of all nanospark unit points
all_centroids = handles.all_centroids;
centroids_num = size(all_centroids,1);
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
save('merged_centroids.mat','all_centroids');

% thrd2 = 50;
% figure
% new_centroids_num = size(all_centroids,1);
% for ii = 1 : new_centroids_num
%     p1 = all_centroids(ii,1:2);
%     hold on
%     plot(p1(1),p1(2),'b*');
%     for jj = 1:new_centroids_num
%         if ii~=jj
%             p2 = all_centroids(jj,1:2);
%             tem_p = p1 - p2;
%             tem_distance = sqrt(tem_p*tem_p');
%             if tem_distance <= thrd2
%                 hold on
%                 plot([p1(1),p2(1)],[p1(2),p2(2)],'r');
%             end
%         end
%     end
% end
% grid minor

handles.merged_centroids = all_centroids;
guidata(hObject,handles);

% --- Executes on button press in btn_cluster.
function btn_cluster_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt={'clusters number:'};
defaults={num2str(30)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
if ~isempty(info)
    cluster_num = str2double(info(1));
else
   return; 
end

merged_centroid = handles.merged_centroids;
X = merged_centroid(:,1:2);
cluster_centroid = clustering(X,cluster_num);

all_centroids = handles.all_centroids; 
cluster_idx = channel_assign(all_centroids(:,1:2),cluster_centroid(:,1:2));
event_infos = [all_centroids(:,[3,4,6]), cluster_idx];

handles.event_infos = event_infos;
handles.cluster_centroid = cluster_centroid;
guidata(hObject,handles);


% --- Executes on button press in ptn_savecluster.
function ptn_savecluster_Callback(hObject, eventdata, handles)
% hObject    handle to ptn_savecluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cluster_centroid = handles.cluster_centroid;
folder_name = handles.folder_name;
fName =['\',folder_name,'_cluster_centroids.xlsx'];
pName = cd;

str = [pName fName];
data = cluster_centroid;
% column_name = {'event_idx','roi_idx','frame','channel_idx','interval'};
% data_excel = cell(size(data,1) + 1, size(data,2));
% data_excel(1,1:end) = column_name;
% data_excel(2:end,1:end) = num2cell(data);
xlswrite(str,data);


% --- Executes on button press in btn_channel_analysis.
function btn_channel_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to btn_channel_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
event_infos = handles.event_infos;
[total_info,channel_info,channel_hist] = event_analysis(event_infos);

folder_name = handles.folder_name;
fName =['\',folder_name,'_total_info.xlsx'];
pName = cd;

str = [pName fName];

data = total_info;
column_name = {'event_idx','roi_idx','frame','channel_idx','interval'};
data_excel = cell(size(data,1) + 1, size(data,2));
data_excel(1,1:end) = column_name;
data_excel(2:end,1:end) = num2cell(data);
xlswrite(str,data_excel,'sheet1');

column_name = {'channel_idx','used_times','events_num'};
data = channel_info;
data_excel = cell(size(data,1) + 1, size(data,2));
data_excel(1,1:end) = column_name;
data_excel(2:end,1:end) = num2cell(data);
xlswrite(str,data_excel,'sheet2');

column_name = {'used_times','channel_num'};
data = channel_hist;
data_excel = cell(size(data,1) + 1, size(data,2));
data_excel(1,1:end) = column_name;
data_excel(2:end,1:end) = num2cell(data);
xlswrite(str,data_excel,'sheet3');


% --- Executes on button press in btn_temporal.
function btn_temporal_Callback(hObject, eventdata, handles)
% hObject    handle to btn_temporal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgs = handles.img_set;
imgs(cellfun(@isempty,imgs)) = [];
rois = handles.roi_set;
rois(cellfun(@isempty,rois)) = [];
scale = 4;
imgs_num = length(imgs);
display_flag = 0;
kk = 1;
for ii = 1:imgs_num
    tem_profile = Get_Z_Profile(imgs{ii});
    smooth_profile = My_SWT(tem_profile,scale);
    
    peak_info = Detect_Event(smooth_profile,display_flag);
    peak_loc{ii} = peak_info(2,:);
    
    tem_boxs = rois{ii};
    tem_img = imgs{ii};
    box_num = size(tem_boxs,1);

    profile_set = Get_Z_Profile(tem_img,tem_boxs);
    
    for jj = 1:box_num
        tem_roi = tem_boxs(jj,:);
        roi_loc = tem_roi(5);
        tem_peak_loc = peak_loc{ii};
        
        min_distance_element = GetNearestElement(roi_loc,tem_peak_loc);
        min_distance_diff = roi_loc - min_distance_element;

        small_trace_smooth = My_SWT(profile_set(jj,:),scale);
        tem_x = tem_boxs(jj,5);
        tem_y = small_trace_smooth(tem_x);
        [~,loc,width,~] = findpeaks(small_trace_smooth,'MinPeakHeight',tem_y - 1);
        nearest_loc = GetNearestElement(roi_loc,loc);
        idx = (loc == nearest_loc);
        width = width(idx);
        temporal_distance(kk,1) = min_distance_diff(1);
        temporal_distance(kk,2) = width(1);       
        
        kk = kk+1;        
        
        if 0
            figure;
            plot(small_trace_smooth);
            hold on
            plot(tem_x,tem_y,'r*');
            grid minor;
            t = 1;
        end
    end   
end


if 1
    [fName,pName,index] = uiputfile('*.xlsx','Save as','data_1.xlsx');
    if index && strcmp(fName(end-4:end),'.xlsx')
        str = [pName fName];
        data_excel = temporal_distance;
        xlswrite(str,data_excel);
    else
        disp('file path is not correct');
    end
end


function y = GetNearestElement(inputX,vectorY)
%return the element in @vectorY that is the nearest element of inputX

tem = inputX - vectorY;
tem_ds = tem.^2;
idx = (tem_ds == min(tem_ds));
nearest_element  = vectorY(idx);
y = nearest_element;


