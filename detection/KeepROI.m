function varargout = KeepROI(imgStack,boxROI)
% select the roi region in the @imgStack
% boxROI = [Top_left(y,x),Bottom_right(y,x)];
% tem_imgs = zeros(size(imgStack(:,:,1)));
img_sz = size(imgStack(:,:,1));
box_mat = boxROI;
box_mat = max(box_mat,1);
box_mat([1 3]) = min(box_mat([1 3]),img_sz(1));
box_mat([2 4]) = min(box_mat([2 4]),img_sz(2));
% start_p = box_mat(:,1:2);
% stop_p = start_p + box_mat(:,3:4);

id_x = box_mat(2):box_mat(4);
id_y = box_mat(1):box_mat(3);

varargout{1} = imgStack(id_y,id_x,:);