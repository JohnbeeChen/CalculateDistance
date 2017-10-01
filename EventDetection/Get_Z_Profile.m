function varargout = Get_Z_Profile(imgIn,roiIn)
% return the z_profiles of each box region at @bound_box
% return the z_profiles of the whole field of @imgIn if @roiIn doesn't exist

imgs = imgIn;
if ~exist('roiIn','var')
    profile(1,:) = Get_Profile(imgIn);
else
    boxs = roiIn;
%     imgs_num = size(imgs,3);
    regoin_num = size(boxs,1);
    boxs(:,3:4) = boxs(:,1:2) + boxs(:,3:4);
    for ii = 1: regoin_num
        com = (boxs(ii,1):boxs(ii,3)) + 1;
        row = (boxs(ii,2):boxs(ii,4)) + 1;
        tem_regoin = imgs(row,com,:);
        profile(ii,:) = Get_Profile(tem_regoin);
%         for jj = 1:imgs_num
%             tem = tem_regoin(:,:,jj);
%             profile(ii,jj) = sum(tem(:))/numel(tem);
%         end
    end
end
varargout{1} = profile;
end

function y = Get_Profile(img)

imgs_num = size(img,3);
for jj = 1:imgs_num
    tem = img(:,:,jj);
    y(1,jj) = sum(tem(:))/numel(tem);
end

end