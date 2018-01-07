function varargout = event_analysis(varargin)
% the input @varargin is event_info [roi_idx,roi_sub_idx,frame,channel_idx]
% outupt @avargout = [total_info,channel_info,channel_hist];
% @total_info = ['event_idx','roi_idx','frame','channel_idx','interval']
% @channel_info = ['channel_idx','used_times','events_num']
% @channel_hist = ['used_times','channel_num']

event_info = varargin{1};
event_idx = event_info(:,4);
idx_tabulate = unique(event_idx);
channel_num = length(idx_tabulate);
y = [];
for ii = 1:channel_num
    kk = idx_tabulate(ii);
    idx = (event_info(:,4) == kk);
    tem = event_info(idx,:);
    num_tem = size(tem,1);
    unique_num = length(unique(tem(:,1)));
    channel_point_number(ii,:) = [ii,num_tem,unique_num];
    
    tem = sortrows(tem,3); %sort descending by frame
    tem_frame = tem(:,3);
    tem_frame = tem_frame - tem_frame(1);
    tem(:,5) = tem_frame;
%     channel_point_set{ii} = tem;
    y = add_array(y,tem);
end
temp = channel_point_number(:,2);
max_use_num = max(temp);
use_num_histogram =[1:max_use_num;histcounts(temp,1:(max_use_num+1))];
use_num_histogram  = use_num_histogram';

varargout{1} = y;
varargout{2} = channel_point_number;
varargout{3} = use_num_histogram;

function varargout = add_array(array, added_part)

if isempty(array)
    varargout{1} = added_part;
    return
end
varargout{1} = [array; added_part];

