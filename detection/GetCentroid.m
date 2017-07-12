function varargout = GetCentroid(varargin)
% calculate the centroid of all region

debug_flag = 0;

imags = double(varargin{1});
len = size(imags,3);
tem_img = 1.0*zeros(size(imags(:,:,1)));
for ii = 1:len
    tem_img = tem_img + imags(:,:,ii);
end
mass = sum(tem_img(:));
x_len = size(tem_img,2);
xc = 0;
for ii = 1:x_len
   tem = tem_img(:,ii);
   xc = xc + ii*sum(tem);
end
xc = xc/mass;

y_len = size(tem_img,1);
yc = 0;
for ii = 1:y_len
   tem = tem_img(ii,:);
   yc = yc + ii*sum(tem);
end
yc = yc/mass;

if debug_flag
    figure
    imagesc(tem_img);
    hold on
    plot(xc,yc,'r*');
end
varargout{1} = [xc,yc];
