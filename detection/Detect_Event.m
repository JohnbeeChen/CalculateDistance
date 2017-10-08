function varargout = Detect_Event(profiles,displayFlag)
% detect the event of each curve in profiles

if ~exist('displayFlag','var')
    display_flag = 0;
else
    display_flag = displayFlag;
end

swt_value = profiles;
[pck_infos,event_info] = VectorsFindPeaks(swt_value);

if display_flag
    if ~isempty(pck_infos)
        figure
        plot(swt_value)
        hold on
        plot(pck_infos(2,:),pck_infos(1,:),'r*')
    end
end
varargout{1} = pck_infos;
varargout{2} = event_info;


